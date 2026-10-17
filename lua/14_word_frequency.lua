-- =============================================================================
-- Exercise 14: Word Frequency Counter
-- Concepts: Tables as dictionaries/hash maps, string pattern matching (string.gmatch)
-- Run:      lua 14_word_frequency.lua
-- =============================================================================

local function tokenize(text)
    local words = {}
    for word in string.gmatch(text, "%a+") do
        table.insert(words, string.lower(word))
    end
    return words
end

local function countWords(words)
    local counts = {}
    for _, w in ipairs(words) do
        counts[w] = (counts[w] or 0) + 1
    end
    return counts
end

local function main()
    local sample = "To be, or not to be: that is the question. To be is to live!"
    print(string.format('Input text:\n"%s"\n', sample))

    local words = tokenize(sample)
    local counts = countWords(words)

    -- Extract and sort unique keys for deterministic output
    local wordKeys = {}
    for k in pairs(counts) do
        table.insert(wordKeys, k)
    end
    table.sort(wordKeys)

    print(string.format("Word counts (%d unique words, %d total):", #wordKeys, #words))
    for _, w in ipairs(wordKeys) do
        print(string.format("%-10s: %d", w, counts[w]))
    end
end

main()
