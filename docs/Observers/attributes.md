# Attributes

The Attribute observer is triggered when an attribute is set to a non-`nil` value.

```lua
Observers.observeAttribute(myInstance, "MyAttribute", function(value)
	print("Attribute is", value)

	return function()
		print("Attribute is no longer", value)
	end
end)
```

## Typing

Technically, the value of an attribute is not known (it's not necessarily `unknown`, as we know it's some sort of attribute value, of which there is a limited amount of types). However, to make the API easier to use, `observeAttribute` uses a generic value to allow developers to denote what type they expect. For instance, a string:

```lua
Observers.observeAttribute(myInstance, "MyAttribute", function(value: string) ... end)
```

However, be aware that this does not enforce the attribute to be a specific type. Especially in client-facing code, it is good to ensure that the type of the attribute matches what is expected. For instance, if a string is expected:

```lua
Observers.observeAttribute(myInstance, "MyAttribute", function(value: string)
	assert(typeof(value) == "string", "expected string for MyAttribute; got " .. typeof(value))
	...
end)
```

## Guards

A guard is an optional predicate function that can be used to control if the observer function should be triggered for a given value. For instance, this could be used to type-check the value at runtime.

```lua
Observers.observeAttribute(
	myInstance,
	"MyAttribute",
	function(value: string)
		print("value is a string", value)
	end,
	function(value: unknown)
		-- Guard function ensures the value is a string.
		-- The observer will only trigger if this returns a truthy value.
		return typeof(value) == "string"
	end
)
```
