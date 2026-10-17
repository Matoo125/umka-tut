-- =============================================================================
-- Exercise 05: Multiplication Table
-- Concepts: Nested loops, string.format alignment, input validation
-- Run:      printf '4\n' | lua 05_multiplication_table.lua
-- =============================================================================

local function main()
    io.write("Enter table size: ")
    local size = io.read("*n")
    if not size or size <= 0 then
        print("Table size must be positive.")
        return
    end

    for row = 1, size do
        for col = 1, size do
            io.write(string.format("%4d", row * col))
        end
        io.write("\n")
    end
end

main()
