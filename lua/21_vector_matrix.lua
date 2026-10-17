-- =============================================================================
-- Exercise 21: 3D Vector and Matrix Math
-- Concepts: Vector and matrix math with operator overloading / metatables
-- Run:      lua 21_vector_matrix.lua
-- =============================================================================

local Vec = {}
Vec.__index = Vec

function Vec.new(x, y, z)
    return setmetatable({ x, y, z }, Vec)
end

function Vec:add(v)
    return Vec.new(self[1] + v[1], self[2] + v[2], self[3] + v[3])
end

function Vec:sub(v)
    return Vec.new(self[1] - v[1], self[2] - v[2], self[3] - v[3])
end

function Vec:dot(v)
    return self[1] * v[1] + self[2] * v[2] + self[3] * v[3]
end

function Vec:cross(v)
    return Vec.new(
        self[2] * v[3] - self[3] * v[2],
        self[3] * v[1] - self[1] * v[3],
        self[1] * v[2] - self[2] * v[1]
    )
end

function Vec:norm()
    return math.sqrt(self:dot(self))
end

-- --- 3x3 Matrix ---
local Mat = {}
Mat.__index = Mat

function Mat.identity()
    return setmetatable({
        Vec.new(1.0, 0.0, 0.0),
        Vec.new(0.0, 1.0, 0.0),
        Vec.new(0.0, 0.0, 1.0)
    }, Mat)
end

function Mat:mulv(v)
    return Vec.new(
        self[1]:dot(v),
        self[2]:dot(v),
        self[3]:dot(v)
    )
end

local function printVec(name, v)
    io.write(string.format("%s: [%.2f, %.2f, %.2f]\n", name, v[1], v[2], v[3]))
end

local function main()
    local u = Vec.new(1.0, 2.0, 3.0)
    local v = Vec.new(4.0, 5.0, 6.0)

    io.write("Vector Math:\n")
    printVec("u", u)
    printVec("v", v)

    local add = u:add(v)
    local sub = u:sub(v)
    local dot = u:dot(v)
    local cross = u:cross(v)
    local normU = u:norm()
    local normV = v:norm()

    printVec("u + v", add)
    printVec("u - v", sub)
    io.write(string.format("u . v: %.2f\n", dot))
    printVec("u x v", cross)
    io.write(string.format("|u|: %.4f\n", normU))
    io.write(string.format("|v|: %.4f\n", normV))

    io.write("\nMatrix Transformation:\n")
    local id = Mat.identity()
    local transformed = id:mulv(u)
    printVec("I * u", transformed)
end

main()
