# Children

The `observeChildren` observer can be used to observe added and removed children of a given instance. The removed child is passed to the returned callback.

```lua
observeChildren(parent:Instance, function(child:Instance)
    print("Child added to parent", child.Name)

    return function(child: Instance)
        -- Cleanup
        print("Child is being removed",child.Name)
    end
end)
```
