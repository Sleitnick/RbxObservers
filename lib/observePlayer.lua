--!strict

local Players = game:GetService("Players")

--[=[
	@within Observers

	Creates an observer that captures each player in the game.

	```lua
	observePlayer(function(player)
		print("Player entered game", player.Name)

		return function()
			-- Cleanup
			print("Player left game (or observer stopped)", player.Name)
		end
	end)
	```
]=]
local function observePlayer(callback: (player: Player) -> (() -> ())?): () -> ()
	local playerAddedConn: RBXScriptConnection
	local playerRemovingConn: RBXScriptConnection

	local cleanupsPerPlayer: { [Player]: () -> () } = {}

	local function OnPlayerAdded(player: Player)
		if not playerAddedConn.Connected then
			return
		end

		task.spawn(function()
			local cleanup = callback(player)
			if typeof(cleanup) == "function" then
				if playerAddedConn.Connected and player.Parent then
					cleanupsPerPlayer[player] = cleanup
				else
					task.spawn(cleanup)
				end
			end
		end)
	end

	local function OnPlayerRemoving(player: Player)
		local cleanup = cleanupsPerPlayer[player]
		cleanupsPerPlayer[player] = nil
		if typeof(cleanup) == "function" then
			task.spawn(cleanup)
		end
	end

	-- Listen for changes:
	playerAddedConn = Players.PlayerAdded:Connect(OnPlayerAdded)
	playerRemovingConn = Players.PlayerRemoving:Connect(OnPlayerRemoving)

	-- Initial:
	task.defer(function()
		if not playerAddedConn.Connected then
			return
		end

		for _, player in Players:GetPlayers() do
			task.spawn(OnPlayerAdded, player)
		end
	end)

	-- Cleanup:
	return function()
		playerAddedConn:Disconnect()
		playerRemovingConn:Disconnect()

		local player = next(cleanupsPerPlayer)
		while player do
			OnPlayerRemoving(player)
			player = next(cleanupsPerPlayer)
		end
	end
end

return observePlayer
