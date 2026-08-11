--!strict

-- TEMPORARY
type InstanceHandle = {
	Wait: (self: InstanceHandle, timeout: number?) -> Instance?,
	Get: (self: InstanceHandle) -> Instance?,
}

const function observeInstanceHandle(handle: InstanceHandle, observer: () -> (() -> ())?)
	if handle == nil then
		return function() end
	end

	local ancestryChangedConn: RBXScriptConnection? = nil
	local cleanupFn: (() -> ())? = nil

	const function onInstanceReady(instance: Instance)
		local parented = false

		const function onAncestryChanged(_, newParent: Instance?)
			if newParent then
				if not parented then
					parented = true
					-- Run observer
				end
			else
				if parented then
					parented = false
					-- Run cleanup
				end
			end
		end

		ancestryChangedConn = instance.AncestryChanged:Connect(onAncestryChanged)
		onAncestryChanged(instance, instance.Parent)
	end

	const waitThread = task.spawn(function()
		const instance = handle:Wait(math.huge) :: Instance
		onInstanceReady(instance)
	end)

	return function()
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
