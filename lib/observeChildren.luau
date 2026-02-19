--!strict
type Callback = (child: Instance) -> ((removed: Instance) -> ())?

--[=[
	@within Observers

	Creates an observer that captures each child of a given instance.

	The returned callback is called with removed instances. It's called for every child if the observer is disconnected

	```lua
	observeChildren(parent:Instance, function(child:Instance)
		print("Child added to parent", child.Name)

		return function(child:Instance)
			-- Cleanup
	   		print("Child is being removed",child.Name)
		end
	end)
	```
]=]
local function observeChildren(parent: Instance, callback: Callback): () -> ()
	local childAddedConn: RBXScriptConnection
	local childRemovedConn: RBXScriptConnection

	local cleanupsPerChild: { [Instance]: (child: Instance) -> () } = {}

	local function onChildAdded(child: Instance)
		if not childAddedConn.Connected then
			return
		end

		task.spawn(function()
			local cleanup = (callback)(child)
			if typeof(cleanup) == "function" then
				if childAddedConn.Connected then
					cleanupsPerChild[child] = cleanup
				else
					task.spawn(cleanup, child)
				end
			end
		end)
	end

	local function onChildRemoved(child: Instance)
		local cleanup = cleanupsPerChild[child]
		cleanupsPerChild[child] = nil
		if typeof(cleanup) == "function" then
			task.spawn(cleanup, child)
		end
	end

	-- Listen for changes:
	childAddedConn = parent.ChildAdded:Connect(onChildAdded)
	childRemovedConn = parent.ChildRemoved:Connect(onChildRemoved)

	-- Initial:
	task.defer(function()
		if not childAddedConn.Connected then
			return
		end

		for _, child in parent:GetChildren() do
			task.spawn(onChildAdded, child)
		end
	end)

	return function()
		childAddedConn:Disconnect()
		childRemovedConn:Disconnect()

		childAddedConn = nil :: any
		childRemovedConn = nil :: any

		local child = next(cleanupsPerChild)
		while child do
			onChildRemoved(child)
			child = next(cleanupsPerChild)
		end
	end
end

return observeChildren
