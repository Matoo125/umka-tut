-- =============================================================================
-- Exercise 06: Table Art
-- Concepts: String repetition, modular drawing functions, input validation
-- Run:      printf '5\n4\n' | lua 06_table_art.lua
-- =============================================================================

local function drawTable(width, height)
    -- Top border
    io.write("+" .. string.rep("-", width - 2) .. "+\n")

    -- Middle rows
    local row = "|" .. string.rep(" ", width - 2) .. "|\n"
    for _ = 1, height - 2 do
        io.write(row)
    end

    -- Bottom border
    io.write("+" .. string.rep("-", width - 2) .. "+\n")
end

local function main()
    io.write("Enter table width: ")
    local w = io.read("*n")

    io.write("Enter table height: ")
    local h = io.read("*n")

    if not w or not h or w < 2 or h < 2 then
        print("Width and height must be at least 2.")
        return
    end

    drawTable(w, h)
end

main()
