---
sidebar_position: 2
---

# Observer Pattern

The observer pattern centers around _observing_ the lifetime of a given state.

The "state" in question can be anything. It could be a color value, a position, a table, or anything else. Typically, current state can be grabbed immediately (e.g. `part.Color`), and further changes can be detected via some sort of signal (e.g. `part:GetPropertyChangedSignal("Color")`).

The observer pattern should provide two crucial elements:

1. Detect the current and all future changes to some state.
2. For a given observation, detect when that state changes to something else, thus to provide a way to clean up.

The general layout of an observer should look like such:

```lua
observeSomething(...params, function(state)
	-- Do something with "state". This runs every time state changes, including the initial state.

	return function()
		-- Cleanup. Called once "state" changes to something else.
	end
end)
```

## Why Lifetime is Important

The lifetime of a state is defined by the time in which is begins to the time in which it ends. This is why the observer function requires developers to return a function for cleanup. By doing so, the lifetime of a given state can be captured. For game programming, this allows developers to kick off tasks for a given task, and then easily clean up those tasks once the state has changed.

For example:

```lua
observeTag("Disco", function(part)
	-- Start flashing the part random colors every frame:
	local heartbeat = RunService.Heartbeat:Connect(function()
		part.Color = Color3.new(math.random(), math.random(), math.random())
	end)

	-- Stop flashing on cleanup:
	return function()
		heartbeat:Disconnect()
	end
end)
```

In the above example, the "Disco" tag is being observed. When the observer triggers the function, we enter the beginning of the lifecycle for `part`, where we know that `part` has the "Disco" tag. At this point, we can hook up our disco part by flashing it different colors every frame. Then we return a cleanup function, which will be called at the end of the lifecycle (i.e. when the Disco tag is removed or the part is destroyed). This function disconnects the heartbeat connection, thus cleaning up the operation.

## Differences from Event-Driven Programming

Event-driven programming is quite similar, as we are able to observe changes to state. The key differences though is that event-driven programming does not necessarily encapsulate detecting the _lifetime_ of a given state, nor does it necessarily capture the _current_ state.

For instance:

```lua
part:GetPropertyChangedSignal("Color"):Connect(function() ... end)
```

The code above will fire any time the `Color` property changes for `part`. However, the triggered function has no understanding of when the given color changes again. Also, the given function will _not_ be triggered for the current state; only future changes will trigger the function.

## Differences from Reactive (RX) Programming

Reactive programming cares about reacting, transforming, and consuming state. While the observer pattern is quite similar, reactive programming doesn't define the lifetime of a given state.
