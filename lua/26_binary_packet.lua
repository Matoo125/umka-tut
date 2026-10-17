-- =============================================================================
-- Exercise 26: Binary Packet Header Packer & Parser
-- Concepts: Byte buffers, bitwise operations (&, |, >>, <<),
--           endianness serialization, and checksum verification.
-- Run:      lua 26_binary_packet.lua
-- =============================================================================

-- Computes a 32-bit polynomial hash checksum across a sequence of bytes
local function computeChecksum(bytes)
    local sum = 0
    for i = 1, #bytes do
        sum = (sum * 31 + bytes[i]) & 0xFFFFFFFF
    end
    return sum
end

-- Read big-endian 16-bit integer (0-indexed offset)
local function readUint16BE(b, offset)
    return ((b[offset + 1] << 8) | b[offset + 2]) & 0xFFFF
end

-- Read big-endian 32-bit integer (0-indexed offset)
local function readUint32BE(b, offset)
    return ((b[offset + 1] << 24) |
            (b[offset + 2] << 16) |
            (b[offset + 3] << 8) |
            b[offset + 4]) & 0xFFFFFFFF
end

-- Write big-endian 16-bit integer (0-indexed offset)
local function writeUint16BE(b, offset, val)
    b[offset + 1] = (val >> 8) & 0xFF
    b[offset + 2] = val & 0xFF
end

-- Write big-endian 32-bit integer (0-indexed offset)
local function writeUint32BE(b, offset, val)
    b[offset + 1] = (val >> 24) & 0xFF
    b[offset + 2] = (val >> 16) & 0xFF
    b[offset + 3] = (val >> 8) & 0xFF
    b[offset + 4] = val & 0xFF
end

local function main()
    -- 16-byte fixed header buffer
    local buf = {}
    for i = 1, 16 do buf[i] = 0 end

    -- Pack header: Magic "UMKA" (0x554D4B41), Ver 1, Flags 0x0003, Payload 4 bytes
    writeUint32BE(buf, 0, 0x554D4B41)
    writeUint16BE(buf, 4, 1)
    writeUint16BE(buf, 6, 0x0003)
    writeUint32BE(buf, 8, 4)

    -- Calculate checksum of the first 12 bytes and store in the last 4 bytes
    local headerBytes = {}
    for i = 1, 12 do headerBytes[i] = buf[i] end
    local cs = computeChecksum(headerBytes)
    writeUint32BE(buf, 12, cs)

    -- Unpack header from byte buffer into table
    local hdr = {
        magic = readUint32BE(buf, 0),
        version = readUint16BE(buf, 4),
        flags = readUint16BE(buf, 6),
        payloadLen = readUint32BE(buf, 8),
        checksum = readUint32BE(buf, 12)
    }

    -- Verify integrity
    local verifyBytes = {}
    for i = 1, 12 do verifyBytes[i] = buf[i] end
    local expectedCs = computeChecksum(verifyBytes)
    local isValid = (expectedCs == hdr.checksum)

    print("Header Unpacked:")
    print(string.format("  Magic:      0x%08X", hdr.magic))
    print(string.format("  Version:    %d", hdr.version))
    print(string.format("  Flags:      0x%04X", hdr.flags))
    print(string.format("  PayloadLen: %d bytes", hdr.payloadLen))
    print(string.format("  Checksum:   0x%08X", hdr.checksum))
    print(string.format("  Valid:      %s", isValid and "true" or "false"))
end

main()
