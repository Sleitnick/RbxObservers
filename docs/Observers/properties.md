# Properties

Observing properties on instances can be done via the `observeProperty` observer.

```lua
Observers.observeProperty(workspace.Model, "Name", function(name)
	print("Name is now: " .. name)

	return function()
		print("Name is no longer: " .. name)
	end
end)
```
