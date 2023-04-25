--!strict

--[=[
	@within Observers

	Creates an observer around an attribute of a given instance. The callback will fire for any non-nil
	attribute value.

	```lua
	observeAttribute(workspace.Model, "MyAttribute", function(value)
		print("MyAttribute is now:", value)

		return function()
			-- Cleanup
			print("MyAttribute is no longer:", value)
		end
	end)
	```

	The observer also returns a function that can be called to clean up the observer:
	```lua
	local stopObserving = observeAttribute(workspace.Model, "MyAttribute", function(value) ... end)

	task.wait(10)
	stopObserving()
	```
]=]
local function observeAttribute<T>(instance: Instance, name: string, callback: (value: T) -> () -> ()): () -> ()
	local cleanFn: (() -> ())? = nil

	local onAttrChangedConn: RBXScriptConnection
	local changedId = 0

	local function OnAttributeChanged()
		if cleanFn ~= nil then
			task.spawn(cleanFn)
			cleanFn = nil
		end

		changedId += 1
		local id = changedId

		local value = instance:GetAttribute(name)

		if value ~= nil then
			task.spawn(function()
				local clean = callback(value)
				if id == changedId and onAttrChangedConn.Connected then
					cleanFn = clean
				else
					task.spawn(clean)
				end
			end)
		end
	end

	-- Get changed values:
	onAttrChangedConn = instance:GetAttributeChangedSignal(name):Connect(OnAttributeChanged)

	-- Get initial value:
	task.defer(function()
		if not onAttrChangedConn.Connected then
			return
		end

		OnAttributeChanged()
	end)

	-- Cleanup:
	return function()
		onAttrChangedConn:Disconnect()
		if cleanFn ~= nil then
			task.spawn(cleanFn)
		end
	end
end

return observeAttribute
