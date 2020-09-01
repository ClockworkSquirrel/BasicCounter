--[[
    BasicCounter by csqrl (ClockworkSquirrel)
    Version: 0.0.1

    Documentation is at:
    https://github.com/ClockworkSquirrel/BasicCounter

    Overview of Methods:
        BasicCounter.new([ InitialCount: number = 0 ]): Counter

        Methods:
        -------------------------------------------------------
        Counter:RawSet(Value: number): void
        Counter:Set(Value: number): void
        Counter:Increment([ Value: number = 1 ]): void
        Counter:Decrement([ Value: number = 1 ]): void
        Counter:Reset(): void
        Counter:Get(): number
        Counter:Destroy(): void

        Events:
        -------------------------------------------------------
        Counter.Changed: RBXScriptSignal
        Counter.Incremented: RBXScriptSignal
        Counter.Decremented: RBXScriptSignal
        Counter.Filled: RBXScriptSignal
        Counter.Emptied: RBXScriptSignal

        Properties:
        -------------------------------------------------------
        Counter.MinCount: number | nil = 0
        Counter.MaxCount: number | nil = nil
        Counter.Strict: boolean = true
        Counter.InitialCount: number = 0
        Counter.Count: number
--]]
local BasicCounter = {}
BasicCounter.__symbol = newproxy(true)

--[[
    Create and return a new BasicCounter instance
--]]
BasicCounter.__index = BasicCounter
function BasicCounter.new(InitialCount)
    --[[
        Assign BasicCounter as it's defined in this module to
        the metatable of an empty table
    --]]
    local self = setmetatable({}, BasicCounter)

    --[[
        Set the MinCount, MaxCount and Strict properties to their
        initial values. These can be directly assigned after creating
        a new instance
    --]]
    self.MinCount = 0
    self.MaxCount = nil
    self.Strict = true

    --[[
        Set the InitialCount property to the number specified by
        InitialCount (or 0 if left unspecified), and set the current
        Count to InitialCount
    --]]
    self.InitialCount = type(InitialCount) == "number" and InitialCount or 0
    self.Count = self.InitialCount

    --[[
        Store the BindableEvents to be triggered by various methods of
        BasicCounter
    --]]
    self.__events = {
        Changed = Instance.new("BindableEvent"),
        Incremented = Instance.new("BindableEvent"),
        Decremented = Instance.new("BindableEvent"),
        Full = Instance.new("BindableEvent"),
        Empty = Instance.new("BindableEvent")
    }

    --[[
        Assign the Event signals of the above BindableEvents to
        their own properties within BasicCounter instances
    --]]
    self.Changed = self.__events.Changed.Event
    self.Incremented = self.__events.Incremented.Event
    self.Decremented = self.__events.Decremented.Event
    self.Filled = self.__events.Full.Event
    self.Emptied = self.__events.Empty.Event

    --[[
        Return the new fully-formed BasicCounter instance
    --]]
    return self
end

--[[
    Sets the value of Count without triggering any events
--]]
function BasicCounter:RawSet(Value)
    assert(type(Value) == "number", string.format("Expected Value to be a number, got %s", typeof(Value)))
    rawset(self, "Count", Value)
end

--[[
    Main logic for the counter. Determines how to update the
    Count value by checking if strict mode is enabled and
    readjusting the new value to be contained within the
    set min and max values.

    If count changes, the Change event will be fired, in addition
    to the Increment or Decrement event when the new value is higher
    than the current count or lower than the current count respectively

    Additionally, if the new value is the same as the specified MaxCount
    (in strict mode), the Full event will fire. If the new value is equal
    to the MinCount, the Empty event will fire.
--]]
function BasicCounter:Set(Value)
    if self.__Destroyed then
        return error("This BasicCounter instance has been destroyed", 2)
    end

    assert(type(Value) == "number", string.format("Expected Value to be a number, got %s", typeof(Value)))

    local OldCount = self.Count
    local NewCount = Value
    local CountChange = math.abs(OldCount - NewCount)

    if self.Strict then
        if NewCount > OldCount and self.MaxCount then
            NewCount = math.min(self.MaxCount, NewCount)
        elseif NewCount < OldCount and self.MinCount then
            NewCount = math.max(self.MinCount, NewCount)
        end

        CountChange = math.abs(OldCount - NewCount)
    end

    if OldCount ~= NewCount then
        self:RawSet(NewCount)

        if NewCount > OldCount then
            self.__events.Incremented:Fire(NewCount, OldCount, CountChange)
        else
            self.__events.Decremented:Fire(NewCount, OldCount, CountChange)
        end

        if self.Strict then
            if NewCount == self.MaxCount then
                self.__events.Full:Fire(NewCount, OldCount, CountChange)
            elseif NewCount == self.MinCount then
                self.__events.Empty:Fire(NewCount, OldCount, CountChange)
            end
        end

        self.__events.Changed:Fire(NewCount, OldCount, CountChange)
    end
end

--[[
    Convenience method for incrementing the current count
--]]
function BasicCounter:Increment(Value)
    Value = type(Value) == "number" and Value or 1
    self:Set(self.Count + Value)
end

--[[
    Convenience method for incrementing the current count
--]]
function BasicCounter:Decrement(Value)
    Value = type(Value) == "number" and Value or 1
    self:Set(self.Count - Value)
end

--[[
    Reset Count back to the InitialCount
--]]
function BasicCounter:Reset()
    self:Set(self.InitialCount)
end

--[[
    Return the value of Count. Alternatively, BasicCounter.Count
    can be used to achieve the same result. This is here as a
    companion for the :Set() method, but not really necessary
--]]
function BasicCounter:Get()
    if self.__Destroyed then
        return
    end

    return self.Count
end

--[[
    Destroys the BindableEvents created during instantiation
    of a new BasicCounter and sets self.__Destroyed, which
    prevents setting the value of Count via :Set() (and any
    other methods which depend on :Set(); e.g. :Increment(),
    :Decrement(), :Reset().
--]]
function BasicCounter:Destroy()
    if self.__Destroyed then
        return
    end

    for _, Event in next, self.__events do
        Event:Destroy()
    end

    self.__Destroyed = true
    self = nil
end

return BasicCounter
