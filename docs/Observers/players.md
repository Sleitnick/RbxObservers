# Players

The `observePlayer` observer can be used to observe when players enter and leave a game.

```lua
Observers.observePlayer(function(player)
	print(player.Name .. " entered game")
	
	return function()
		print(player.Name .. " left game")
	end
end)
```
