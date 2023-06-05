---
sidebar_position: 1
---

# Getting Started

The Observers package can be acquired using [Wally](https://wally.run/), a package manager for Roblox. Alternatively, the `@rbxts/observers` package is available on npm for developers using roblox-ts.

## Wally Configuration
Once Wally is installed, run `wally init` on your project directory, and then add the various utility modules found here as dependencies. For example, the following could be a `wally.toml` file for a project that includes a few of these modules:
```toml
[package]
name = "your_name/your_project"
version = "0.1.0"
registry = "https://github.com/UpliftGames/wally-index"
realm = "shared"

[dependencies]
Observers = "sleitnick/observers@^0.3.3"
```

To install, run `wally install` within your project. Wally will create a Package folder in your directory with the installed dependency.

## Rojo Configuration
The Package folder created by Wally should be synced into Roblox Studio through your Rojo configuration. For instance, a Rojo configuration might have the following entry to sync the Packages folder into ReplicatedStorage:
```json
{
	"name": "rbx-util-example",
	"tree": {
		"$className": "DataModel",
		"ReplicatedStorage": {
			"$className": "ReplicatedStorage",
			"Packages": {
				"$path": "Packages"
			}
		}
	}
}
```

## Usage Example
The Observers module can now be used in scripts, such as the following:
```lua
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Observers = require(ReplicatedStorage.Packages.Observers)

Observers.observeTag("SomeTag", function(instance: Instance)
	print(`Observing {instance}`)
	return function()
		print(`Stopped observing {instance}`)
	end
end)
```

## roblox-ts

For developers using roblox-ts, install the `@rbxts/observers` package.

```sh
npm i --save @rbxts/observers
```
