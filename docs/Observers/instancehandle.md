# Instance Handle

The Instance Handle observer creates an observer that captures the existence of an
InstanceHandle's instance and its existence within the game hierarchy.

The observer function will execute once the instance exists _and_ is parented within
the game hierarchy. If the instance is deparented, then the cleanup function is triggered.

Since attributes use InstanceHandles, it is common to see `observeAttribute` paired
with `observeInstanceHandle`.

```lua
observeAttribute(someInstance, "InstanceAttr", function(handle)
	return observeInstanceHandle(handle, function(instance)
		-- This observer is called once:
		-- 1. The handle's instance exists (is not nil).
		-- 2. AND the instance's parent is not nil.

		print("Observing instance", instance:GetFullName())

		return function()
			-- This function is called if:
			-- 1. The observer cleanup was explicitly called.
			-- 2. OR the instance's parent was set to `nil`.
			-- 3. OR the attribute changed (similar to 1. but triggered by the observeAttribute).
			print("Stopped observing instance")
		end
	end)
end)
