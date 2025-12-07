--!strict

type Callback = (player: Player) -> ((Enum.PlayerExitReason) -> ())?

local Players = game:GetService("Players")

--[=[
	@within Observers

	Creates an observer that captures each player in the game.

	```lua
	observePlayer(function(player)
		print("Player entered game", player.Name)

		return function(exitReason)
			-- Cleanup
			print("Player left game", player.Name, "reason", exitReason.Name)
		end
	end)
	```
]=]
local function observePlayer(callback: Callback): () -> ()
	local playerAddedConn: RBXScriptConnection
	local playerRemovingConn: RBXScriptConnection

	local cleanupsPerPlayer: { [Player]: (exitReason: Enum.PlayerExitReason) -> () } = {}
	local inflight: { [Player]: Enum.PlayerExitReason } = {}

	local function OnPlayerAdded(player: Player)
		if not playerAddedConn.Connected then
			return
		end

		task.spawn(function()
			inflight[player] = Enum.PlayerExitReason.Unknown
			local cleanup = (callback :: any)(player)
			if typeof(cleanup) == "function" then
				if playerAddedConn.Connected and player.Parent then
					cleanupsPerPlayer[player] = cleanup
				else
					task.spawn(cleanup, inflight[player])
				end
			end
		end)
	end

	local function OnPlayerRemoving(player: Player, exitReason: Enum.PlayerExitReason)
		if inflight[player] then
			inflight[player] = exitReason
		end

		local cleanup = cleanupsPerPlayer[player]
		cleanupsPerPlayer[player] = nil
		if typeof(cleanup) == "function" then
			task.spawn(cleanup, exitReason)
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
			OnPlayerRemoving(player, inflight[player])
			player = next(cleanupsPerPlayer)
		end
	end
end

return observePlayer
