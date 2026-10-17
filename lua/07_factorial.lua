-- =============================================================================
-- Exercise 07: Factorial
-- Concepts: Iterative loops, non-negative integer validation
-- Run:      printf '5\n' | lua 07_factorial.lua
-- =============================================================================

local function main()
    io.write("Enter a non-negative integer: ")
    local n = io.read("*n")

    if not n or n < 0 then
        print("Factorial is only defined for non-negative integers.")
        return
    end

    local result = 1
    for i = 2, n do
        result = result * i
    end

    print(string.format("%d! = %d", n, result))
end

main()
