--!strict

type Callback<T> = (child: T) -> (() -> ())?

--[=[
	@within Observers

	Creates an observer that captures each child of the given instance.

	```lua
	observeChildren(workspace, function(child)
		print("Child added:", child.Name)

		return function()
			-- Cleanup
			print("Child removed:", child.Name)
		end
	end)
	```
]=]
local function observeChildren<T>(instance: Instance, callback: Callback<T>): () -> ()
	local childAddedConn: RBXScriptConnection
	local childRemovedConn: RBXScriptConnection

	local cleanupsPerChild: { [Instance]: () -> () } = {}

	local function OnChildAdded(child: Instance)
		if not childAddedConn.Connected then
			return
		end

		task.spawn(function()
			local cleanup = (callback :: any)(child)
			if typeof(cleanup) == "function" then
				if childAddedConn.Connected and child.Parent == instance then
					cleanupsPerChild[child] = cleanup
				else
					-- Child is already gone or observer has stopped; call cleanup immediately:
					task.spawn(cleanup)
				end
			end
		end)
	end

	local function OnChildRemoved(child: Instance)
		local cleanup = cleanupsPerChild[child]
		cleanupsPerChild[child] = nil
		if typeof(cleanup) == "function" then
			task.spawn(cleanup)
		end
	end

	-- Listen for changes:
	childAddedConn = instance.ChildAdded:Connect(OnChildAdded)
	childRemovedConn = instance.ChildRemoved:Connect(OnChildRemoved)

	-- Initial children:
	task.defer(function()
		if not childAddedConn.Connected then
			return
		end

		for _, child in instance:GetChildren() do
			task.spawn(OnChildAdded, child)
		end
	end)

	-- Cleanup:
	return function()
		childAddedConn:Disconnect()
		childRemovedConn:Disconnect()

		local child = next(cleanupsPerChild)
		while child do
			OnChildRemoved(child)
			child = next(cleanupsPerChild)
		end
	end
end

return observeChildren
