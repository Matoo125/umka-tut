-- =============================================================================
-- Exercise 34: Run-Length Encoding (RLE) Byte Stream Compressor
-- Concepts: Byte tables, run scanning, count-value chunking,
--           lossless decompression, and compression ratio calculation.
-- Run:      lua 34_rle_compressor.lua
-- =============================================================================

-- Compresses a byte sequence using Run-Length Encoding into pairs of [count, value]
local function compressRLE(input)
    local out = {}
    if #input == 0 then return out end

    local run = 1
    for i = 2, #input do
        if input[i] == input[i - 1] and run < 255 then
            run = run + 1
        else
            table.insert(out, run)
            table.insert(out, input[i - 1])
            run = 1
        end
    end

    table.insert(out, run)
    table.insert(out, input[#input])
    return out
end

-- Expands an RLE stream of [count, value] pairs back into the raw byte table
local function decompressRLE(comp)
    local out = {}
    for i = 1, #comp, 2 do
        local count = comp[i]
        local val = comp[i + 1]
        for _ = 1, count do
            table.insert(out, val)
        end
    end
    return out
end

local function main()
    -- 17-byte raw input buffer with runs of identical bytes
    local raw = {}
    for _ = 1, 5 do table.insert(raw, 0xAA) end  -- 5x 0xAA
    for _ = 1, 3 do table.insert(raw, 0xBB) end  -- 3x 0xBB
    for _ = 1, 8 do table.insert(raw, 0xCC) end  -- 8x 0xCC
    table.insert(raw, 0xDD)                      -- 1x 0xDD

    local compressed = compressRLE(raw)
    local decompressed = decompressRLE(compressed)

    print("=== Run-Length Encoding (RLE) Stream Compressor ===")
    print(string.format("Original size:     %d bytes", #raw))
    print(string.format("Compressed size:   %d bytes", #compressed))

    local reduction = (1.0 - (#compressed / #raw)) * 100.0
    print(string.format("Space saved:       %.1f%%", reduction))

    io.write("Compressed stream: [ ")
    for i = 1, #compressed, 2 do
        io.write(string.format("(%d x 0x%02X) ", compressed[i], compressed[i + 1]))
    end
    io.write("]\n")

    local matches = (#decompressed == #raw)
    if matches then
        for i = 1, #raw do
            if decompressed[i] ~= raw[i] then
                matches = false
                break
            end
        end
    end

    print(string.format("Verification:      %s", matches and "PASS (Exact byte match)" or "FAIL"))
end

main()
