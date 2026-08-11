--!strict

-- TEMPORARY
type InstanceHandle = {
	Wait: (self: InstanceHandle, timeout: number?) -> Instance?,
	Get: (self: InstanceHandle) -> Instance?,
}

--[=[
	@within Observers

	Creates an observer that captures the existence of an InstanceHandle's instance
	and its existence within the game hierarchy.

	The observer function will execute once the instance exists _and_ is parented within
	the game hierarchy. If the instance is deparented then the cleanup function will be
	triggered.

	Since attributes use InstanceHandles, it is common to see `observeAttribute` paired
	with `observeInstanceHandle`.

	```lua
	observeAttribute(someInstance, "InstanceAttr", function(handle)
		return observeInstanceHandle(handle, function(instance)
			print("Observing instance", instance:GetFullName())
			return function()
				print("Stopped observing instance")
			end
		end)
	end)
	```
]=]
local function observeInstanceHandle(handle: InstanceHandle, observer: (instance: Instance) -> (() -> ())?)
	if handle == nil then
		return function() end
	end

	local ancestryChangedConn: RBXScriptConnection? = nil
	local cleanupFn: (() -> ())? = nil
	local cleanupId = 0

	const function onInstanceReady(instance: Instance)
		local parented = false

		const function onAncestryChanged(_, newParent: Instance?)
			cleanupId += 1
			if newParent then
				if not parented then
					parented = true
					const id = cleanupId
					const cleanup = observer(instance)
					if typeof(cleanup) == "function" then
						if id == cleanupId then
							cleanupFn = cleanup
						else
							cleanup()
						end
					end
				end
			else
				if parented then
					parented = false
					if cleanupFn then
						task.spawn(cleanupFn)
						cleanupFn = nil
					end
				end
			end
		end

		ancestryChangedConn = instance.AncestryChanged:Connect(onAncestryChanged)
		onAncestryChanged(instance, instance.Parent)
	end

	const waitThread = task.spawn(function()
		const instance = handle:Wait(math.huge) :: Instance?
		if instance then
			onInstanceReady(instance)
		end
	end)

	return function()
		cleanupId += 1
		if coroutine.status(waitThread) == "suspended" then
			task.cancel(waitThread)
		end
		if ancestryChangedConn then
			ancestryChangedConn:Disconnect()
		end
		if cleanupFn then
			task.spawn(cleanupFn)
			cleanupFn = nil
		end
	end
end

return observeInstanceHandle
