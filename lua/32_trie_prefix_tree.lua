-- =============================================================================
-- Exercise 32: Trie (Prefix Tree) & Autocomplete
-- Concepts: Multi-way tree node tables, character indexing, prefix matching,
--           and recursive depth-first word collection for autocomplete.
-- Run:      lua 32_trie_prefix_tree.lua
-- =============================================================================

local TrieNode = {}
TrieNode.__index = TrieNode

function TrieNode.new()
    return setmetatable({ isEndOfWord = false, children = {} }, TrieNode)
end

local Trie = {}
Trie.__index = Trie

function Trie.new()
    return setmetatable({ root = TrieNode.new() }, Trie)
end

-- Inserts a lowercase word into the Trie
function Trie:insert(word)
    local curr = self.root
    for i = 1, #word do
        local ch = word:sub(i, i)
        if not curr.children[ch] then
            curr.children[ch] = TrieNode.new()
        end
        curr = curr.children[ch]
    end
    curr.isEndOfWord = true
end

-- Checks if the exact word exists in the Trie
function Trie:contains(word)
    local curr = self.root
    for i = 1, #word do
        local ch = word:sub(i, i)
        if not curr.children[ch] then
            return false
        end
        curr = curr.children[ch]
    end
    return curr.isEndOfWord == true
end

-- Checks if any word starts with the given prefix
function Trie:startsWith(prefix)
    local curr = self.root
    for i = 1, #prefix do
        local ch = word or prefix:sub(i, i)
        if not curr.children[ch] then
            return false
        end
        curr = curr.children[ch]
    end
    return true
end

-- Recursively collects all words descending from a given prefix node
local function collectWords(node, prefix, results)
    if not node then return end
    if node.isEndOfWord then
        table.insert(results, prefix)
    end

    for i = 0, 25 do
        local ch = string.char(string.byte('a') + i)
        if node.children[ch] then
            collectWords(node.children[ch], prefix .. ch, results)
        end
    end
end

-- Returns a list of all words sharing the given prefix
function Trie:autocomplete(prefix)
    local results = {}
    local curr = self.root
    for i = 1, #prefix do
        local ch = prefix:sub(i, i)
        if not curr.children[ch] then
            return results
        end
        curr = curr.children[ch]
    end
    collectWords(curr, prefix, results)
    return results
end

local function main()
    local t = Trie.new()

    local words = {"apple", "app", "application", "apt", "banana", "bat"}
    print("Inserting words into Trie:")
    for _, w in ipairs(words) do
        print(string.format("  + %s", w))
        t:insert(w)
    end

    print("\nMembership Queries:")
    local queries = {"app", "apple", "appl"}
    for _, q in ipairs(queries) do
        print(string.format("  contains(\"%s\") = %s", q, t:contains(q) and "true" or "false"))
    end

    print("\nPrefix Search:")
    print(string.format("  startsWith(\"ap\") = %s", t:startsWith("ap") and "true" or "false"))
    print(string.format("  startsWith(\"cat\") = %s", t:startsWith("cat") and "true" or "false"))

    print("\nAutocomplete for 'app':")
    local completions = t:autocomplete("app")
    for _, c in ipairs(completions) do
        print(string.format("  -> %s", c))
    end
end

main()
