-- 41_huffman_coding.lua - Huffman Coding & Data Compression in Lua

local function createLeaf(ch, freq)
    return {
        ch = ch,
        freq = freq,
        isLeaf = true,
        left = nil,
        right = nil
    }
end

local function createInternal(left, right)
    return {
        ch = nil,
        freq = left.freq + right.freq,
        isLeaf = false,
        left = left,
        right = right
    }
end

local codeTable = {}

local function buildCodes(node, prefix)
    if not node then return end
    if node.isLeaf then
        local c = prefix
        if #c == 0 then c = "0" end
        codeTable[node.ch] = c
        return
    end
    buildCodes(node.left, prefix .. "0")
    buildCodes(node.right, prefix .. "1")
end

local function main()
    print("=== Huffman Coding & Compression ===")

    local text = "abracadabra"
    print(string.format("Input text: \"%s\"", text))
    local origBits = #text * 8
    print(string.format("Original size: %d characters (%d bits at 8 bits/char)\n", #text, origBits))

    -- Step 1: Count character frequencies in order of first appearance
    local uniqueChars = {}
    local freqs = {}

    for i = 1, #text do
        local ch = text:sub(i, i)
        local found = false
        for j = 1, #uniqueChars do
            if uniqueChars[j] == ch then
                freqs[j] = freqs[j] + 1
                found = true
                break
            end
        end
        if not found then
            table.insert(uniqueChars, ch)
            table.insert(freqs, 1)
        end
    end

    print("Character Frequencies:")
    for i = 1, #uniqueChars do
        print(string.format("  '%s': %d", uniqueChars[i], freqs[i]))
    end
    print("")

    -- Step 2: Initialize forest with leaf nodes
    local forest = {}
    for i = 1, #uniqueChars do
        table.insert(forest, createLeaf(uniqueChars[i], freqs[i]))
    end

    -- Step 3: Repeatedly merge two nodes with smallest frequencies
    while #forest > 1 do
        -- Find first minimum
        local min1Idx = 1
        for i = 2, #forest do
            if forest[i].freq < forest[min1Idx].freq then
                min1Idx = i
            end
        end
        local node1 = table.remove(forest, min1Idx)

        -- Find second minimum
        local min2Idx = 1
        for i = 2, #forest do
            if forest[i].freq < forest[min2Idx].freq then
                min2Idx = i
            end
        end
        local node2 = table.remove(forest, min2Idx)

        -- Create merged parent node
        local parent = createInternal(node1, node2)
        table.insert(forest, parent)
    end

    local root = forest[1]

    -- Step 4: Build prefix codes
    codeTable = {}
    buildCodes(root, "")

    print("Huffman Prefix Codes:")
    for i = 1, #uniqueChars do
        local ch = uniqueChars[i]
        print(string.format("  '%s' -> %s", ch, codeTable[ch]))
    end
    print("")

    -- Step 5: Encode text
    local encoded = ""
    for i = 1, #text do
        local ch = text:sub(i, i)
        encoded = encoded .. codeTable[ch]
    end

    print("Encoded Bitstream:")
    print(encoded)
    local encBits = #encoded
    local ratio = (1.0 - (encBits / origBits)) * 100.0
    print(string.format("Encoded length: %d bits (%.1f%% space saved)\n", encBits, ratio))

    -- Step 6: Decode bitstream
    local decoded = ""
    local curr = root
    for i = 1, #encoded do
        local bit = encoded:sub(i, i)
        if bit == "0" then
            curr = curr.left
        else
            curr = curr.right
        end

        if curr.isLeaf then
            decoded = decoded .. curr.ch
            curr = root
        end
    end

    print("Decoded String:")
    print(string.format("\"%s\"\n", decoded))

    if decoded == text then
        print("Verification: PASS (Decoded matches original exactly)")
    else
        print("Verification: FAIL (Mismatch)")
    end
end

main()
