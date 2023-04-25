# Tags

The CollectionService allows developers to assign arbitrary tags to any instance in a game. The `observeTag` observer can be used to observe instances with specific tags. This can be used to designate specific behavior to an object when it has a given tag, and to clean up the behavior once the tag is removed.

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
