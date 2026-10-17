-- =============================================================================
-- Exercise 23: Unicode and UTF-8 Decoding
-- Concepts: Standard library utf8, code points, byte length vs rune count, utf8.codes
-- Run:      lua 23_unicode_utf8.lua
-- =============================================================================

local function main()
    local text = "Hello, 世界! 🌍"
    local byteLen = #text
    local runeLen = utf8.len(text)

    print(string.format("Original Text: %s", text))
    print(string.format("Byte Length:   %d", byteLen))
    print(string.format("Rune Length:   %d", runeLen))
    print("\nDecoded Code Points:")

    local idx = 0
    for _, code in utf8.codes(text) do
        local ch = utf8.char(code)
        print(string.format("[%02d] U+%04X | %d bytes | Char: %s", idx, code, #ch, ch))
        idx = idx + 1
    end
end

main()
