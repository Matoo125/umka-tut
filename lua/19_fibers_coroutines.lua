-- =============================================================================
-- Exercise 19: Fibers and Coroutine Generators
-- Concepts: coroutine.create, coroutine.resume, coroutine.yield, coroutine.status
-- Run:      lua 19_fibers_coroutines.lua
-- =============================================================================

-- Notice how Lua's coroutine model natively supports passing values into
-- coroutine.yield(...) and returning them from coroutine.resume(...),
-- unlike Umka which currently requires shared variables!

local function fibonacciGenerator()
    local a = 0
    local b = 1
    while true do
        coroutine.yield(a)
        local nextVal = a + b
        a = b
        b = nextVal
    end
end

local function generateSquares()
    for i = 1, 5 do
        coroutine.yield(i * i)
    end
end

local function main()
    print("Fibonacci Sequence via Coroutine Fiber:")
    local fib = coroutine.create(fibonacciGenerator)

    for i = 0, 9 do
        local ok, val = coroutine.resume(fib)
        if ok then
            print(string.format("Fib[%d] = %d", i, val))
        end
    end

    print("\nSquares via Finite Coroutine Fiber:")
    local sqFib = coroutine.create(generateSquares)

    local idx = 1
    while coroutine.status(sqFib) ~= "dead" do
        local ok, val = coroutine.resume(sqFib)
        if ok and coroutine.status(sqFib) ~= "dead" or val ~= nil then
            print(string.format("Square #%d = %d", idx, val))
            idx = idx + 1
        end
    end
    print("Generator completed.")
end

main()
