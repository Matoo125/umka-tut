-- =============================================================================
-- Exercise 04: Interactive Timer
-- Concepts: os.clock(), state toggle, interactive command loop
-- Run:      lua 04_timer.lua
-- =============================================================================

local function main()
    local startTime = os.clock()
    local reversed = false
    local input = ""

    print("Timer started!")
    print("Press: L = lapse, R = reverse, S = stop\n")

    while input ~= "S" do
        io.write("Command: ")
        input = io.read()
        if not input then
            break
        end

        local elapsed = os.clock() - startTime
        if reversed then
            elapsed = -elapsed
        end

        if input == "L" then
            print(string.format("Elapsed time: %.3f seconds", elapsed))
        elseif input == "R" then
            reversed = not reversed
            if reversed then
                print("Reverse mode: ON")
            else
                print("Reverse mode: OFF")
            end
        elseif input == "S" then
            print(string.format("Final time: %.3f seconds", elapsed))
            print("Timer stopped.")
        else
            print("Unknown command.")
        end
    end
end

main()
