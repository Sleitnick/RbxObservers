--!strict

local RunService = game:GetService("RunService")

--[=[
	@within Observers

	 Creates an observer that captures every `BasePart` that enters the given region.

	```lua
	local overlapParams = OverlapParams.new()
	overlapParams.FilterDescendantsInstances = {workspace.Part}
	overlapParams.FilterType = Enum.RaycastFilterType.Exclude

	observeRegion(workspace.Part, overlapParams, function(part: BasePart)
		print(`Part Entered: {part.Name}`)

		return function()
			print(`Part Left: {part.Name}`)
		end
	end)
	```
]=]
local function observeRegion(
	basePart: BasePart,
	overlapParams: OverlapParams,
	callback: (part: BasePart) -> () -> ()
): () -> ()
	local heartbeatConn: RBXScriptConnection

	local cleanupsPerPart: { [BasePart]: () -> () } = {}

	local function OnPartLeft(part: BasePart)
		local cleanup = cleanupsPerPart[part]
		cleanupsPerPart[part] = nil
		if typeof(cleanup) == "function" then
			task.spawn(cleanup)
		end
	end

	local function Clean(currentParts: { BasePart })
		for part in cleanupsPerPart do
			if not table.find(currentParts, part) then
				task.spawn(OnPartLeft, part)
			end
		end
	end

	local function OnHeartbeat()
		local result = workspace:GetPartsInPart(basePart, overlapParams)
		task.spawn(Clean, result)

		for _, part in result do
			if cleanupsPerPart[part] then
				continue
			end
			task.spawn(function()
				cleanupsPerPart[part] = callback(part)
			end)
		end
	end

	heartbeatConn = RunService.Heartbeat:Connect(OnHeartbeat)

	return function()
		heartbeatConn:Disconnect()

		local part = next(cleanupsPerPart)
		while part do
			OnPartLeft(part)
			part = next(cleanupsPerPart)
		end
	end
end

return observeRegion
