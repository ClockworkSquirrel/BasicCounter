return function()
    local BasicCounter = require(script.Parent)

    describe(".new()", function()
        it("should create a new BasicCounter instance", function()
            local Counter = BasicCounter.new()

            expect(Counter).to.be.ok()
            expect(Counter.__symbol).to.be.ok()
            expect(Counter.__symbol).to.equal(BasicCounter.__symbol)
        end)
    end)

    describe(":Set()", function()
        it("should allow Count to be set", function()
            local Counter = BasicCounter.new()

            Counter:Set(10)

            expect(Counter.Count).to.equal(10)
        end)

        it("should accept numbers only", function()
            local Counter = BasicCounter.new()

            expect(function()
                Counter:Set("hello world")
            end).to.throw()
        end)

        it("should respect MaxCount in strict mode", function()
            local Counter = BasicCounter.new()

            Counter.MaxCount = 10
            Counter:Set(100)

            expect(Counter.Count).to.equal(10)
        end)

        it("should respect MinCount in strict mode", function()
            local Counter = BasicCounter.new()

            Counter:Set(-100)

            expect(Counter.Count).to.equal(0)
        end)

        it("should disrespect MaxCount with strict mode off", function()
            local Counter = BasicCounter.new()

            Counter.Strict = false
            Counter.MaxCount = 10
            Counter:Set(100)

            expect(Counter.Count).to.equal(100)
        end)

        it("should disrespect MinCount with strict mode off", function()
            local Counter = BasicCounter.new()

            Counter.Strict = false
            Counter:Set(-100)

            expect(Counter.Count).to.equal(-100)
        end)
    end)

    describe(":Reset()", function()
        it("should set Count back to InitialValue", function()
            local Counter = BasicCounter.new(5)

            Counter:Set(100)
            Counter:Reset()

            expect(Counter.Count).to.equal(5)
        end)
    end)

    describe(".Changed", function()
        it("should fire when Count is changed", function()
            local Counter = BasicCounter.new()

            Counter.Changed:Connect(function(NewCount, OldCount, Difference)
                expect(NewCount).to.be.ok()
                expect(OldCount).to.be.ok()
                expect(Difference).to.be.ok()
            end)

            Counter:Increment()
        end)
    end)

    describe(":Destroy()", function()
        it("should error when interfacing after being destroyed", function()
            local Counter = BasicCounter.new()

            Counter:Destroy()

            expect(function()
                Counter:Increment()
            end).to.throw()
        end)
    end)

    describe(":RawSet()", function()
        it("should allow Count to be set without firing events", function()
            local Counter = BasicCounter.new()

            local Fired = 0

            Counter.Changed:Connect(function()
                Fired += 1
            end)

            Counter:RawSet(10)
            Counter:Increment()

            expect(Fired).to.equal(1)
        end)
    end)
end
