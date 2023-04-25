--!strict

--[=[
	@within Observers

	Creates an observer around a property of a given instance.

	```lua
	observeProperty(workspace.Model, "Name", function(newName: string)
		print("New name:", name)

		return function()
			-- Cleanup
			print("Model's name is no longer:", name)
		end
	end)
	```
]=]
local function observeProperty(instance: Instance, property: string, callback: (value: unknown) -> () -> ()): () -> ()
	local cleanFn: (() -> ())? = nil

	local propChangedConn: RBXScriptConnection
	local changedId = 0

	local function OnPropertyChanged()
		if cleanFn ~= nil then
			task.spawn(cleanFn)
			cleanFn = nil
		end

		changedId += 1
		local id = changedId

		local value = (instance :: any)[property]

		task.spawn(function()
			local clean = callback(value)
			if id == changedId and propChangedConn.Connected then
				cleanFn = clean
			else
				task.spawn(clean)
			end
		end)
	end

	-- Get changed values:
	propChangedConn = instance:GetPropertyChangedSignal(property):Connect(OnPropertyChanged)

	-- Get initial value:
	task.defer(function()
		if not propChangedConn.Connected then
			return
		end
		OnPropertyChanged()
	end)

	-- Cleanup:
	return function()
		propChangedConn:Disconnect()
		if cleanFn ~= nil then
			task.spawn(cleanFn)
			cleanFn = nil
		end
	end
end

return observeProperty
