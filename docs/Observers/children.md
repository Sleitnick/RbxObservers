# Children

The `observeChildren` observer can be used to observe children of a given instance. This is useful for tracking when children are added or removed from a parent instance.

```lua
Observers.observeChildren(workspace, function(child)
	print("Child added:", child.Name)

	return function()
		-- Cleanup
		print("Child removed:", child.Name)
	end
end)
```
