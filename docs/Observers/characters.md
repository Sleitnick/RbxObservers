# Characters

Use the `observeCharacter` observer to observe the lifespan of characters in the game.

```lua
Observers.observeCharacter(function(player, character)
	-- Character was spawned
	print("Character spawned for " .. player.Name)

	-- Wait for humanoid:
	local humanoid = character:WaitForChild("Humanoid", 60)

	-- Listen to humanoid Died event:
	local onDiedConn: RBXScriptConnection? = nil
	if humanoid then
		onDiedConn = humanoid.Died:Connect(function()
			print("Character died for " .. player.Name)
		end)
	end

	return function()
		-- Character was removed
		print("Character removed for " .. player.Name)
		if onDiedConn then
			onDiedConn:Disconnect()
			onDiedConn = nil
		end
	end
end)
```
