# Tags

The CollectionService allows developers to assign arbitrary tags to any instance in a game. The `observeTag` and `observeTags` observers can be used to monitor instances based on these tags. This is ideal for designating specific behavior to an object when it has a given set of tags and ensuring that behavior is cleaned up once any of the tags are removed.

```lua
-- Observe instances with the "Disco" tag:
Observers.observeTag("Disco", function(part: BasePart)
	-- Spawn a thread that changes the color randomly every 0.2 seconds:
	local discoThread = task.spawn(function()
		while true do
			task.wait(0.2)
			part.Color = Color3.new(math.random(), math.random(), math.random())
		end
	end)

	-- Close the disco thread once the tag or instance goes away:
	return function()
		task.cancel(discoThread)
	end
end)
```

```lua
-- Only turn on the disco if the part is "Disco" AND "Active":
Observers.observeTags({"Disco", "Active"}, function(part: BasePart)
    local discoThread = task.spawn(function()
        while true do
            task.wait(0.2)
            part.Color = Color3.new(math.random(), math.random(), math.random())
        end
    end)

    return function()
        task.cancel(discoThread)
        -- Optionally reset the color when deactivated
        part.Color = Color3.new(1, 1, 1)
    end
end)
```

## Type-Checking

Note that the instance class is unknown to the observer. The above example assumes it is a `Part`, but that is not guaranteed. It is best to check that the type you're expecting is correct:

```lua
Observers.observeTag("Disco", function(part: BasePart)
	assert(part:IsA("BasePart"), "expected part")
	...
end)
```

## Ancestry Inclusion List

By default, the tag observer will observe tagged instances in all ancestors within the game.

A common desire when observing tagged instances is to only observe instances within a specific ancestor. For instance, a developer might only want to observe instances within the workspace. This can be done by supplying a list of allowed ancestors in the `ancestors` array parameter:

```lua
local allowedAncestors = { workspace }

Observers.observeTag(
	"Disco",
	function(part: BasePart)
		...
	end,
	allowedAncestors
)
```

```lua
local allowedAncestors = { workspace }

-- Works for both observeTag and observeTags:
Observers.observeTags(
    {"Disco", "Active"}, 
    function(part: BasePart)
        ...
    end, 
    allowedAncestors
)
```