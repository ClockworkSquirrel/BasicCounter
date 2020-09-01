local Replicated = game:GetService("ReplicatedStorage")
local TestEZ = require(Replicated.TestEZ)

local BasicCounterPath = Replicated.BasicCounter

TestEZ.TestBootstrap:run({
    BasicCounterPath
})
