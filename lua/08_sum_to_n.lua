-- =============================================================================
-- Exercise 08: Sum to N
-- Concepts: Arithmetic loop accumulation, validation
-- Run:      printf '10\n' | lua 08_sum_to_n.lua
-- =============================================================================

local function main()
    io.write("Enter a positive integer: ")
    local n = io.read("*n")

    if not n or n <= 0 then
        print("The number must be positive.")
        return
    end

    local sum = 0
    for i = 1, n do
        sum = sum + i
    end

    print(string.format("Sum from 1 to %d = %d", n, sum))
end

main()
