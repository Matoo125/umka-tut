-- =============================================================================
-- Exercise 02: Fibonacci
-- Concepts: Recursion, loops, integer formatting
-- Run:      lua 02_fib.lua
-- =============================================================================

local function fib(n)
    if n <= 1 then
        return n
    end
    return fib(n - 1) + fib(n - 2)
end

local function main()
    for i = 0, 10 do
        print(fib(i))
    end
end

main()
