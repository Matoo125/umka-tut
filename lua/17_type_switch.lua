-- =============================================================================
-- Exercise 17: Type Switch and Any
-- Concepts: type() inspection, math.type (integer vs float in Lua 5.3+), dynamic typing
-- Run:      lua 17_type_switch.lua
-- =============================================================================

local function describe(item)
    local t = type(item)
    if t == "number" then
        if math.type and math.type(item) == "integer" then
            print(string.format("Integer: %d (doubled = %d)", item, item * 2))
        else
            print(string.format("Real: %.2f (half = %.2f)", item, item / 2.0))
        end
    elseif t == "string" then
        print(string.format('String: "%s" (length = %d)', item, #item))
    elseif t == "boolean" then
        print(string.format("Boolean: %s (negated = %s)", tostring(item), tostring(not item)))
    else
        print("Unknown type")
    end
end

local function main()
    local items = {
        100,
        45.5,
        "Umka Scripting",
        true,
        false
    }

    print("Inspecting Items via Type Switch:")
    for _, it in ipairs(items) do
        describe(it)
    end
end

main()
