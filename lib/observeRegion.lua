--!strict
local RunService = game:GetService("RunService")

--[=[
	@within Observers

	 Creates an observer that captures every `BasePart` enters the Given Part

	```lua
	local OverlapParam = OverlapParams.new()
	OverlapParam.FilterDescendantsInstances = {workspace.Part}
	OverlapParam.FilterType = Enum.RaycastFilterType.Exclude

	observeRegion(workspace.Part, OverlapParam, function(part: BasePart)
		print(`part enterd:- {part.Name}`)

		return function()
			-- Cleanup
			print(`part leaves:- {part.Name}`)
		end
	end)
	```
]=]
local function observeRegion(basePart: BasePart , OverlapParam: OverlapParams , callback: (part:BasePart)-> () -> ()): () -> ()
	local PartCache: {[Instance]: (() -> ())} = {}
	local HeartbeatConnection: RBXScriptConnection = nil

	local function Cleanup(currentPart: {Instance})
		for Part , cleanFn in PartCache do
			if not table.find(currentPart , Part) then
				task.spawn(cleanFn)
				PartCache[Part] = nil
			end
		end
	end

	local function CleanupForAll()
		for ins , cleanFn in PartCache do
			task.spawn(cleanFn)
			PartCache[ins] = nil
		end
	end

	local function OnUpdate()
		local result = workspace:GetPartsInPart(basePart , OverlapParam)
		task.spawn(Cleanup , result)
		for _ , part: BasePart in result do
			if PartCache[part] then continue end
			task.spawn(function()
				PartCache[part] = callback(part)
			end)
		end
	end
	-- update:
	HeartbeatConnection = RunService.Heartbeat:Connect(OnUpdate)
	-- initial call:
	task.defer(function()
		if HeartbeatConnection.Connected then
			return
		end
		OnUpdate()
	end)

	return function()
		HeartbeatConnection:Disconnect()
		task.spawn(CleanupForAll)
	end
end

return observeRegion
