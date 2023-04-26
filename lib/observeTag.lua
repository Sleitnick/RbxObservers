--!strict

local CollectionService = game:GetService("CollectionService")

type InstanceStatus = "__inflight__" | "__dead__"

--[=[
	@within Observers

	Creates an observer around a CollectionService tag. The given callback will fire for each instance
	that has the given tag.

	The callback should return a function, which will be called when the given instance's tag is either
	destroyed, loses the given tag, or (if the `ancestors` table is provided) goes outside of the allowed
	ancestors.

	The function itself returns a function that can be called to stop the observer. This will also call
	any cleanup functions of currently-observed instances.

	```lua
	local stopObserver = Observers.observeTag("MyTag", function(instance: Instance)
		print("Observing", instance)

		-- The "cleanup" function:
		return function()
			print("Stopped observing", instance)
		end
	end)

	-- Optionally, the `stopObserver` function can be called to completely stop the observer:
	task.wait(10)
	stopObserver()
	```

	#### Ancestor Inclusion List
	By default, the `observeTag` function will observe a tagged instance anywhere in the Roblox game
	hierarchy. The `ancestors` table can optionally be used, which will restrict the observer to only
	observe tagged instances that are descendants of instances within the `ancestors` table.

	For instance, if a tagged instance should only be observed when it is in the Workspace, the Workspace
	can be added to the `ancestors` list. This might be useful if a tagged model prefab exist somewhere
	such as ServerStorage, but shouldn't be observed until placed into the Workspace.

	```lua
	local allowedAncestors = { workspace }

	Observers.observeTag(
		"MyTag",
		function(instance: Instance)
			...
		end,
		allowedAncestors
	)
	```
]=]
function observeTag<T>(tag: string, callback: (instance: T) -> () -> (), ancestors: { Instance }?): () -> ()
	local instances: { [Instance]: InstanceStatus | () -> () } = {}
	local ancestryConn: { [Instance]: RBXScriptConnection } = {}

	local onInstAddedConn: RBXScriptConnection
	local onInstRemovedConn: RBXScriptConnection

	local function IsGoodAncestor(instance: Instance)
		if ancestors == nil then
			return true
		end

		for _, ancestor in ancestors do
			if instance:IsDescendantOf(ancestor) then
				return true
			end
		end

		return false
	end

	local function AttemptStartup(instance: Instance)
		-- Mark instance as starting up:
		instances[instance] = "__inflight__"

		-- Attempt to run the callback:
		task.defer(function()
			if instances[instance] ~= "__inflight__" then
				return
			end

			-- Run the callback in protected mode:
			local success, cleanup = xpcall(function(inst: T)
				local clean = callback(inst)
				assert(typeof(clean) == "function", "callback must return a function")
				return clean
			end, debug.traceback, instance :: any)

			-- If callback errored, print out the traceback:
			if not success then
				local err = ""
				local firstLine = string.split(cleanup :: any, "\n")[1]
				local lastColon = string.find(firstLine, ": ")
				if lastColon then
					err = firstLine:sub(lastColon + 1)
				end
				warn(`error while calling observeTag("{tag}") callback:{err}\n{cleanup}`)
				return
			end

			if instances[instance] ~= "__inflight__" then
				-- Instance lost its tag or was destroyed before callback completed; call cleanup immediately:
				task.spawn(cleanup :: any)
			else
				-- Good startup; mark the instance with the associated cleanup function:
				instances[instance] = cleanup :: any
			end
		end)
	end

	local function AttemptCleanup(instance: Instance)
		local cleanup = instances[instance]
		instances[instance] = "__dead__"

		if typeof(cleanup) == "function" then
			task.spawn(cleanup)
		end
	end

	local function OnAncestryChanged(instance: Instance)
		if IsGoodAncestor(instance) then
			if instances[instance] == "__dead__" then
				AttemptStartup(instance)
			end
		else
			AttemptCleanup(instance)
		end
	end

	local function OnInstanceAdded(instance: Instance)
		if not onInstAddedConn.Connected then
			return
		end
		if instances[instance] ~= nil then
			return
		end

		instances[instance] = "__dead__"

		ancestryConn[instance] = instance.AncestryChanged:Connect(function()
			OnAncestryChanged(instance)
		end)
		OnAncestryChanged(instance)
	end

	local function OnInstanceRemoved(instance: Instance)
		AttemptCleanup(instance)

		local ancestry = ancestryConn[instance]
		if ancestry then
			ancestry:Disconnect()
			ancestryConn[instance] = nil
		end

		instances[instance] = nil
	end

	-- Hook up added/removed listeners for the given tag:
	onInstAddedConn = CollectionService:GetInstanceAddedSignal(tag):Connect(OnInstanceAdded)
	onInstRemovedConn = CollectionService:GetInstanceRemovedSignal(tag):Connect(OnInstanceRemoved)

	-- Attempt to mark already-existing tagged instances right away:
	task.defer(function()
		if not onInstAddedConn.Connected then
			return
		end

		for _, instance in CollectionService:GetTagged(tag) do
			task.spawn(OnInstanceAdded, instance)
		end
	end)

	-- Full observer cleanup function:
	return function()
		onInstAddedConn:Disconnect()
		onInstRemovedConn:Disconnect()

		-- Clear all instances:
		local instance = next(instances)
		while instance do
			OnInstanceRemoved(instance)
			instance = next(instances)
		end
	end
end

return observeTag
