-- =============================================================================
-- Exercise 16: Polymorphic Shapes Interface
-- Concepts: Duck typing, object-oriented tables with metatables, dynamic dispatch
-- Run:      lua 16_interfaces_shapes.lua
-- =============================================================================

-- In Lua, interfaces are implicit via "duck typing": any table providing
-- :name(), :area(), and :perimeter() satisfies the Shape interface.

-- --- Rectangle Class ---
local Rectangle = {}
Rectangle.__index = Rectangle

function Rectangle.new(w, h)
    return setmetatable({ width = w, height = h }, Rectangle)
end

function Rectangle:name()
    return "Rectangle"
end

function Rectangle:area()
    return self.width * self.height
end

function Rectangle:perimeter()
    return 2.0 * (self.width + self.height)
end

-- --- Circle Class ---
local Circle = {}
Circle.__index = Circle

function Circle.new(r)
    return setmetatable({ radius = r }, Circle)
end

function Circle:name()
    return "Circle"
end

function Circle:area()
    local pi = 3.14159
    return pi * self.radius * self.radius
end

function Circle:perimeter()
    local pi = 3.14159
    return 2.0 * pi * self.radius
end

-- --- Polymorphic Dispatch ---
local function printShapeSummary(s)
    io.write(string.format("%-10s -> Area: %6.2f, Perimeter: %6.2f\n", s:name(), s:area(), s:perimeter()))
end

local function main()
    local shapes = {
        Rectangle.new(4.0, 5.0),
        Circle.new(3.0),
    }

    io.write("Shape Measurements:\n")
    for _, s in ipairs(shapes) do
        printShapeSummary(s)
    end
end

main()
