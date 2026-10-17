-- =============================================================================
-- Exercise 20: File I/O and Content Processing
-- Concepts: io.open, file:write, file:read, file:close, os.remove, error handling
-- Run:      lua 20_file_io.lua
-- =============================================================================

local function writeFile(filename, content)
    local f, err = io.open(filename, "wb")
    if not f then
        print(string.format("Error opening file for write: %s", tostring(err)))
        return false
    end

    local ok, writeErr = f:write(content)
    f:close()

    if not ok then
        print(string.format("Error writing to file: %s", tostring(writeErr)))
        return false
    end
    return true
end

local function readFile(filename)
    local f, err = io.open(filename, "rb")
    if not f then
        print(string.format("Error opening file for read: %s", tostring(err)))
        return nil, false
    end

    local data = f:read("*a")
    f:close()

    return data, true
end

local function countLines(text)
    if not text or #text == 0 then
        return 0
    end
    local lines = 0
    for _ in string.gmatch(text, "\n") do
        lines = lines + 1
    end
    return lines
end

local function main()
    local filename = "notes.txt"
    local payload = "Umka Scripting Language\nFast, statically typed, embeddable\nEnjoying exercises!\n"

    print(string.format("Writing %d bytes to %s...", #payload, filename))
    local ok = writeFile(filename, payload)
    if not ok then
        return
    end

    print(string.format("Reading back from %s...", filename))
    local content, readOk = readFile(filename)
    if not readOk then
        return
    end

    io.write(string.format("--- File Content ---\n%s", content))
    print(string.format("Line count: %d", countLines(content)))

    -- Cleanup
    os.remove(filename)
    print("Temporary file cleaned up.")
end

main()
