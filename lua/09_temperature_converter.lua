-- =============================================================================
-- Exercise 09: Temperature Converter
-- Concepts: String branching, arithmetic conversion formulas
-- Run:      printf 'CtoF\n25\n' | lua 09_temperature_converter.lua
-- =============================================================================

local function main()
    io.write("Choose conversion (CtoF or FtoC): ")
    local choice = io.read()

    io.write("Enter temperature value: ")
    local value = io.read("*n")

    if choice == "CtoF" then
        print(string.format("Result: %.2f", value * 9 / 5 + 32))
    elseif choice == "FtoC" then
        print(string.format("Result: %.2f", (value - 32) * 5 / 9))
    else
        print("Unknown conversion type.")
    end
end

main()
