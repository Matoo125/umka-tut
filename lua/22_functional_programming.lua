-- =============================================================================
-- Exercise 22: Functional Programming with Closures
-- Concepts: First-class functions, closures, lexical scoping, map/filter/reduce
-- Run:      lua 22_functional_programming.lua
-- =============================================================================

local function filter(list, predicate)
    local result = {}
    for _, item in ipairs(list) do
        if predicate(item) then
            table.insert(result, item)
        end
    end
    return result
end

local function map(list, transform)
    local result = {}
    for _, item in ipairs(list) do
        table.insert(result, transform(item))
    end
    return result
end

local function reduce(list, accumulator, initial)
    local current = initial
    local startIdx = 1
    if current == nil then
        current = list[1]
        startIdx = 2
    end
    for i = startIdx, #list do
        current = accumulator(current, list[i])
    end
    return current
end

local function formatList(list)
    local parts = {}
    for _, x in ipairs(list) do
        table.insert(parts, tostring(x))
    end
    return "[" .. table.concat(parts, " ") .. "]"
end

local function main()
    local numbers = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 }
    local threshold = 5

    -- Closures with automatic lexical capture in Lua
    local isGreaterThanThreshold = function(x)
        return x > threshold
    end

    local square = function(x)
        return x * x
    end

    local sum = function(acc, x)
        return acc + x
    end

    -- Pipeline: Filter (> 5) -> Transform (square) -> Reduce (sum)
    local filtered = filter(numbers, isGreaterThanThreshold)
    local squared = map(filtered, square)
    local totalSum = reduce(squared, sum)

    print("Input: " .. formatList(numbers))
    print("Threshold: > " .. tostring(threshold))
    print("Filtered: " .. formatList(filtered))
    print("Squared: " .. formatList(squared))
    print("Total Sum of Squares: " .. tostring(totalSum))
end

main()
