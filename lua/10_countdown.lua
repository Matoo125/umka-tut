-- =============================================================================
-- Exercise 10: Countdown
-- Concepts: Reverse step loops (for i = start, 0, -1), validation
-- Run:      printf '5\n' | lua 10_countdown.lua
-- =============================================================================

local function main()
    io.write("Enter countdown start: ")
    local start = io.read("*n")

    if not start or start < 0 then
        print("Countdown start must be zero or greater.")
        return
    end

    for i = start, 0, -1 do
        print(i)
    end

    print("Lift off!")
end

main()
