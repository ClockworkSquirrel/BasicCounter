# BasicCounter
BasicCounter is a simple counter utility that allows for keeping track of a single numeric value. It comes with built in **"Strict Mode"**, allowing you to ensure the value stays within a given range, and **Events**, which fire when values are Incremented, Decremented, Changed, or when limits are hit.

This is a great utility for keeping track of stats, levels, and can even be used in UI and character controls.

# Getting Started
Adding BasicCounter to your project is really easy (like, seriously!). There's a few methods to get your hands on it:

> It's recommended that you keep the module in a place like [ReplicatedStorage](https://developer.roblox.com/en-us/api-reference/class/ReplicatedStorage). It can be used on both the client and server, but it's totally up to you where to install it.

## Method 1: Roblox Library
This is by far the easiest method to insert the module to your project.

1. Grab a copy from [the Library page](https://www.roblox.com/library/5639136925/BasicCounter).
2. Insert it into your game via the [Toolbox](https://developer.roblox.com/en-us/resources/studio/Toolbox) in Roblox Studio.

## Method 2: Model File
1. Download either the latest `rbxm` or `rbxmx` file from the [Releases page](https://github.com/ClockworkSquirrel/BasicCounter/releases).
2. Insert it into your game via Roblox Studio.

## Method 3: Rojo
1. Clone the `/src` directory into your project.
2. Rename the folder to `BasicCounter`.
3. Sync it into your game using [Rojo](https://github.com/rojo-rbx/rojo).

# Examples
Check out the [`/examples`](https://github.com/ClockworkSquirrel/BasicCounter/tree/default/examples) directory for ways you can use BasicCounter.

# Documentation
## `BasicCounter.new()`
```
BasicCounter.new([ InitialCount: number = 0 ]): Counter
```

Creates a new Counter object. Accepts an optional `InitialCount` parameter, which will set the current value before it's accessible.

---
## Methods
### `Counter:Increment()`
```
Counter:Increment([ Value: number = 1 ]): void
```

Increases the current value of the counter by the specified `Value` (or by `1` if no value is set).

---
### `Counter:Decrement()`
```
Counter:Decrement([ Value: number = 1 ]): void
```

Decreases the current value of the counter by the specified `Value` (or by `1` if no value is set).

---
### `Counter:Set()`
```
Counter:Set(Value: number): void
```

Sets the current value of the counter. Events will be fired accordingly, in addition to ensuring values are kept within any specified ranges (in **"Strict Mode"**).

---
### `Counter:RawSet()`
```
Counter:RawSet(Value: number): void
```

Sets the current value of the counter without firing off any Events. This will also allow Min and Max values to be disrespected.

---
### `Counter:Reset()`
```
Counter:Reset(): void
```

Resets the value of the counter back to it's `InitialCount`, as specified during `BasicCounter.new()`.

---
### `Counter:Get()`
```
Counter:Get(): number
```

Gets the current value of the counter. This is an unnecessary method, but is implemented for symmetry with the `:Set()` method. It is perfectly acceptable to retrieve the current value by `Counter.Count`.

---
### `Counter:Destroy()`
```
Counter:Destroy(): void
```

Destroys the BindableEvents created during `BasicCounter.new()`, which are proxied via `.Changed`, `.Incremented`, `.Decremented`, `.Filled` and `.Emptied`. Also prevents usage of any methods of the Counter by throwing an error when used after destruction.

---
## Events
### `Counter.Incremented`
```
Counter.Incremented: RBXScriptSignal
```

Triggered when the value of the counter increases. See `Counter.Changed` for a list of parameters passed to the callback.

---
### `Counter.Decremented`
```
Counter.Decremented: RBXScriptSignal
```

Triggered when the value of the counter decreases. See `Counter.Changed` for a list of parameters passed to the callback.

---
### `Counter.Filled`
```
Counter.Filled: RBXScriptSignal
```

Triggered when the value of the counter reaches `Counter.MaxCount`. See `Counter.Changed` for a list of parameters passed to the callback.

---
### `Counter.Emptied`
```
Counter.Emptied: RBXScriptSignal
```

Triggered when the value of the counter reaches `Counter.MinCount`. See `Counter.Changed` for a list of parameters passed to the callback.

---
### `Counter.Changed`
```
Counter.Changed: RBXScriptSignal
```

Triggered when the value of the counter changes. Parameters passed to the callback are as follows:

| Name | Type | Description |
|------|------|-------------|
| NewValue | number | The current (new) value of the counter |
| OldValue | number | The previous value of the counter (before changes) |
| Difference | number | The difference between the old and new value (always a positive number) |

---
## Properties
### `Counter.Count`
```
Counter.Count: number
```

The value currently stored by the counter. Do not edit this directly; use `:Set()`, `:Increment()`, `:Decrement()` or `:Reset()` to modify the value, or `:RawSet()` to modify the value without firing events, ignoring strict mode.

---
### `Counter.MinCount`
```
Counter.MinCount: number | nil = 0
```

The smallest value which the counter may decrease to (when **Strict Mode** is enabled).

---
### `Counter.MaxCount`
```
Counter.MaxCount: number | nil = nil
```

The highest value which the counter may increase to (when **Strict Mode** is enabled).

---
### `Counter.Strict`
```
Counter.Strict: boolean = true
```

Determines whether **Strict Mode** should be enabled. If disabled, Min and MaxCount values will be ignored.

---
### `Counter.InitialCount`
```
Counter.InitialCount: number = 0
```

Defined during `BasicCounter.new` to specify the number at which the counter will start from. Can be changed after initialisation, and will set Count back to this number when `:Reset()` is called.
