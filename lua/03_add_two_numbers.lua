-- =============================================================================
-- Exercise 03: Add Two Numbers
-- Concepts: Console input (io.read), number parsing, formatted float printing
-- Run:      printf '1\n2\n' | lua 03_add_two_numbers.lua
-- =============================================================================

local function main()
    io.write("Enter first number: ")
    local a = io.read("*n")

    io.write("Enter second number: ")
    local b = io.read("*n")

    io.write(string.format("Result: %f\n", a + b))
end

main()
