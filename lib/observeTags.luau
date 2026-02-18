--!strict

local CollectionService = game:GetService("CollectionService")

type InstanceStatus = "__inflight__" | "__dead__"
type Callback<T> = (instance: T) -> (() -> ())?

--[=[
	@within Observers

	Creates an observer around a list of CollectionService tags. The given callback will fire for each instance
	that has **all** of the given tags.

	The callback should return a function, which will be called when the given instance loses any of the given tags,
	is destroyed, or (if the `ancestors` table is provided) goes outside of the allowed ancestors.

	The function itself returns a function that can be called to stop the observer. This will also call
	any cleanup functions of currently-observed instances.

	```lua
	local stopObserver = Observers.observeTags({"MyTag1", "MyTag2"}, function(instance: Instance)
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
	By default, the `observeTags` function will observe a tagged instance anywhere in the Roblox game
	hierarchy. The `ancestors` table can optionally be used, which will restrict the observer to only
	observe tagged instances that are descendants of instances within the `ancestors` table.

	For instance, if a tagged instance should only be observed when it is in the Workspace, the Workspace
	can be added to the `ancestors` list. This might be useful if a tagged model prefab exist somewhere
	such as ServerStorage, but shouldn't be observed until placed into the Workspace.

	```lua
	local allowedAncestors = { workspace }

	Observers.observeTags(
		{"MyTag1", "MyTag2"},
		function(instance: Instance)
			...
		end,
		allowedAncestors
	)
	```
]=]
local function observeTags<T>(tags: { string }, callback: Callback<T>, ancestors: { Instance }?): () -> ()
	local instances: { [Instance]: InstanceStatus | () -> () } = {}
	local ancestryConn: { [Instance]: RBXScriptConnection } = {}
	local tagConns: { [string]: { Added: RBXScriptConnection, Removed: RBXScriptConnection } } = {}

	local isAlive = true

	local function isGoodAncestor(instance: Instance)
		if not instance:IsDescendantOf(game) then
			return false
		end

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

	local function hasAllTags(instance: Instance)
		for _, tag in tags do
			if not instance:HasTag(tag) then
				return false
			end
		end
		return true
	end

	local function attemptStartup(instance: Instance)
		-- Mark instance as starting up:
		instances[instance] = "__inflight__"

		-- Attempt to run the callback:
		task.defer(function()
			if instances[instance] ~= "__inflight__" then
				return
			end

			-- Run the callback in protected mode:
			local success, cleanup = xpcall(function(inst: Instance)
				local clean = callback(inst :: any)
				if clean ~= nil then
					assert(typeof(clean) == "function", "callback must return a function or nil")
				end
				return clean
			end, debug.traceback :: (string) -> string, instance)

			-- If callback errored, print out the traceback:
			if not success then
				local err = ""
				local firstLine = string.split(cleanup :: any, "\n")[1]
				local lastColon = string.find(firstLine, ": ")
				if lastColon then
					err = firstLine:sub(lastColon + 1)
				end
				warn(`error while calling observeTags({table.concat(tags, ", ")}) callback: {err}\n{cleanup}`)
				return
			end

			if instances[instance] ~= "__inflight__" then
				-- Requirements changed before callback completed; call cleanup immediately:
				if cleanup ~= nil then
					task.spawn(cleanup :: any)
				end
			else
				-- Good startup; mark the instance with the associated cleanup function:
				instances[instance] = cleanup :: any
			end
		end)
	end

	local function attemptCleanup(instance: Instance)
		local cleanup = instances[instance]
		instances[instance] = "__dead__"

		if typeof(cleanup) == "function" then
			task.spawn(cleanup)
		end
	end

	local function onStateChanged(instance: Instance)
		if not isAlive then
			return
		end

		local shouldBeObserved = hasAllTags(instance) and isGoodAncestor(instance)
		local currentStatus = instances[instance]

		if shouldBeObserved then
			if currentStatus == "__dead__" or currentStatus == nil then
				if currentStatus == nil then
					instances[instance] = "__dead__"
					ancestryConn[instance] = instance.AncestryChanged:Connect(function()
						onStateChanged(instance)
					end)
				end
				attemptStartup(instance)
			end
		else
			if currentStatus ~= "__dead__" and currentStatus ~= nil then
				attemptCleanup(instance)
			end
		end
	end

	local function onInstanceAdded(instance: Instance)
		if not isAlive then
			return
		end

		if instances[instance] ~= nil then
			onStateChanged(instance)
			return
		end

		instances[instance] = "__dead__"

		ancestryConn[instance] = instance.AncestryChanged:Connect(function()
			onStateChanged(instance)
		end)

		onStateChanged(instance)
	end

	local function onInstanceRemoved(instance: Instance)
		onStateChanged(instance)

		local hasAnyTag = false
		for _, tag in tags do
			if instance:HasTag(tag) then
				hasAnyTag = true
				break
			end
		end

		-- If it has no tags left from the list, stop tracking it:
		if not hasAnyTag then
			attemptCleanup(instance)
			local ancestry = ancestryConn[instance]
			if ancestry then
				ancestry:Disconnect()
				ancestryConn[instance] = nil
			end
			instances[instance] = nil
		end
	end

	-- Hook up added/removed listeners for all tags:
	for _, tag in tags do
		tagConns[tag] = {
			Added = CollectionService:GetInstanceAddedSignal(tag):Connect(onInstanceAdded),
			Removed = CollectionService:GetInstanceRemovedSignal(tag):Connect(onInstanceRemoved),
		}
	end

	-- Attempt to mark already-existing tagged instances right away:
	task.defer(function()
		if not isAlive then
			return
		end

		for _, tag in tags do
			for _, instance in CollectionService:GetTagged(tag) do
				onInstanceAdded(instance)
			end
		end
	end)

	-- Full observer cleanup function:
	return function()
		isAlive = false

		for _, conns in tagConns do
			conns.Added:Disconnect()
			conns.Removed:Disconnect()
		end

		-- Clear all instances:
		local instance = next(instances)
		while instance do
			attemptCleanup(instance)
			local ancestry = ancestryConn[instance]
			if ancestry then
				ancestry:Disconnect()
			end
			instance = next(instances)
		end
		instances = {}
		ancestryConn = {}
	end
end

return observeTags
