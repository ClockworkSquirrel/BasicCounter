local RunService = game:GetService("RunService")
local Replicated = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local BasicCounter = require(Replicated.BasicCounter)
local Player = Players.LocalPlayer

local OPTIONS = {
    INITIAL_WALKSPEED = 16, -- The initial speed
    MAX_WALKSPEED = 52, -- The maximum speed to allow
    INCREMENT_AFTER = 2, -- Seconds to wait before incrementing
}

-- Create a new BasicCounter and set the maximum value
local Counter = BasicCounter.new(OPTIONS.INITIAL_WALKSPEED)
Counter.MaxCount = OPTIONS.MAX_WALKSPEED

-- Wait for the Player's character and humanoid
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")

local LastUpdate = os.time()
local RenderStepBinding

RenderStepBinding = RunService.RenderStepped:Connect(function()
    -- If it's been less than OPTIONS.INCREMENT_AFTER, then
    -- don't bother doing anything else.
    if os.time() - LastUpdate < OPTIONS.INCREMENT_AFTER then
        return
    end

    -- Set LastUpdate to the current time
    LastUpdate = os.time()

    -- Increment Counter by 1
    Counter:Increment()
end)

-- When Counter changes, set Humanoid.WalkSpeed to its new value
local ChangedBinding
ChangedBinding = Counter.Changed:Connect(function(NewValue)
    print("Setting WalkSpeed to", NewValue)
    Humanoid.WalkSpeed = NewValue
end)

-- When the Counter reaches MaxValue, disconnect all the Events
-- we previously setup (cleaning up what we don't need)
local FilledBinding
FilledBinding = Counter.Filled:Connect(function()
    RenderStepBinding:Disconnect()
    ChangedBinding:Disconnect()
    FilledBinding:Disconnect()
end)
