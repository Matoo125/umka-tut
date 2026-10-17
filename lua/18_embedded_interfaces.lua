-- =============================================================================
-- Exercise 18: Stream Readers, Writers, and Embedded Interfaces
-- Concepts: Stream abstraction, decorator pattern, composition in Lua
-- Run:      lua 18_embedded_interfaces.lua
-- =============================================================================

-- --- MemoryBuffer ---
local MemoryBuffer = {}
MemoryBuffer.__index = MemoryBuffer

function MemoryBuffer.new()
    return setmetatable({ data = "" }, MemoryBuffer)
end

function MemoryBuffer:read()
    return self.data
end

function MemoryBuffer:write(msg)
    self.data = self.data .. msg
end

-- --- PrefixedWriter Wrapper ---
local PrefixedWriter = {}
PrefixedWriter.__index = PrefixedWriter

function PrefixedWriter.new(prefix, target)
    return setmetatable({ prefix = prefix, target = target }, PrefixedWriter)
end

function PrefixedWriter:write(msg)
    self.target:write(self.prefix .. msg)
end

-- --- High-level Operations ---
local function writeLog(w, msg)
    w:write(msg .. "\n")
end

local function printBuffer(r)
    io.write(string.format("--- Buffer Output ---\n%s---------------------\n", r:read()))
end

local function main()
    local buf = MemoryBuffer.new()

    writeLog(buf, "INFO: System started")
    writeLog(buf, "INFO: Loading modules...")

    local logger = PrefixedWriter.new("[APP] ", buf)
    writeLog(logger, "Ready for user requests.")

    printBuffer(buf)
end

main()
