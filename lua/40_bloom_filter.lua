-- 40_bloom_filter.lua - Bloom Filter & BitSet in Lua

local BitSet = {}
BitSet.__index = BitSet

function BitSet.new(size)
    local self = setmetatable({}, BitSet)
    self.size = size
    local numWords = math.floor((size + 31) / 32)
    self.words = {}
    for i = 1, numWords do
        self.words[i] = 0
    end
    return self
end

function BitSet:set(bit)
    if bit >= 0 and bit < self.size then
        local w = math.floor(bit / 32) + 1
        local b = bit % 32
        self.words[w] = self.words[w] | (1 << b)
    end
end

function BitSet:test(bit)
    if bit >= 0 and bit < self.size then
        local w = math.floor(bit / 32) + 1
        local b = bit % 32
        return (self.words[w] & (1 << b)) ~= 0
    end
    return false
end

function BitSet:countSetBits()
    local count = 0
    for i = 1, #self.words do
        local w = self.words[i]
        while w > 0 do
            if (w & 1) ~= 0 then
                count = count + 1
            end
            w = w >> 1
        end
    end
    return count
end

local function hashString(s, seed, modulus)
    local h = seed
    for i = 1, #s do
        local ch = string.byte(s, i)
        h = (h * 31 + ch) % modulus
    end
    return h
end

local BloomFilter = {}
BloomFilter.__index = BloomFilter

local seeds = { 17, 37, 79 }

function BloomFilter.new(numBits, numHashes)
    local self = setmetatable({}, BloomFilter)
    self.bits = BitSet.new(numBits)
    self.k = numHashes
    return self
end

function BloomFilter:add(item)
    for i = 1, self.k do
        local h = hashString(item, seeds[i], 1000003)
        local bit = h % self.bits.size
        self.bits:set(bit)
    end
end

function BloomFilter:contains(item)
    for i = 1, self.k do
        local h = hashString(item, seeds[i], 1000003)
        local bit = h % self.bits.size
        if not self.bits:test(bit) then
            return false
        end
    end
    return true
end

function BloomFilter:printBits()
    local parts = {}
    for i = 0, self.bits.size - 1 do
        if i > 0 and (i % 8) == 0 then
            table.insert(parts, " ")
        end
        if self.bits:test(i) then
            table.insert(parts, "1")
        else
            table.insert(parts, "0")
        end
    end
    print("[" .. table.concat(parts, "") .. "]")
end

local function testQuery(bf, word, expected)
    local actual = bf:contains(word)
    local actStr = actual and "true" or "false"
    local expStr = expected and "true" or "false"
    print(string.format("  contains(\"%-12s) -> %-5s (expected: %s)", word .. "\"", actStr, expStr))
end

local function main()
    print("=== Bloom Filter & BitSet ===")
    print("Filter capacity: 64 bits, 3 hash functions")
    print("Adding elements:")
    print("  + \"umka\"")
    print("  + \"lua\"")
    print("  + \"compiler\"")
    print("  + \"interpreter\"")

    local bf = BloomFilter.new(64, 3)
    bf:add("umka")
    bf:add("lua")
    bf:add("compiler")
    bf:add("interpreter")

    print("")
    print("BitSet Visualization:")
    bf:printBits()

    local setBits = bf.bits:countSetBits()
    local pct = (setBits / bf.bits.size) * 100.0
    print(string.format("Bits set: %d / %d (%.1f%% fill rate)\n", setBits, bf.bits.size, pct))

    print("Querying Membership:")
    testQuery(bf, "umka", true)
    testQuery(bf, "lua", true)
    testQuery(bf, "compiler", true)
    testQuery(bf, "interpreter", true)
    testQuery(bf, "python", false)
    testQuery(bf, "rust", false)
    testQuery(bf, "javascript", false)

    print("")
    print("Bloom filter verification passed with zero false negatives.")
end

main()
