-- =============================================================================
-- Exercise 33: LRU Cache (Least Recently Used)
-- Concepts: Hash table lookup, doubly linked list references,
--           O(1) recency promotion, and oldest-entry eviction at capacity.
-- Run:      lua 33_lru_cache.lua
-- =============================================================================

local LRUCache = {}
LRUCache.__index = LRUCache

function LRUCache.new(capacity)
    return setmetatable({
        capacity = capacity,
        size = 0,
        head = nil,
        tail = nil,
        items = {}
    }, LRUCache)
end

-- Detaches node from doubly linked list
function LRUCache:removeNode(n)
    if not n then return end

    local prevNode = n.prev
    local nextNode = n.next

    if prevNode then
        prevNode.next = nextNode
    else
        self.head = nextNode
    end

    if nextNode then
        nextNode.prev = prevNode
    else
        self.tail = prevNode
    end

    n.prev = nil
    n.next = nil
end

-- Inserts node at head of doubly linked list (MRU)
function LRUCache:addToHead(n)
    n.next = self.head
    n.prev = nil

    if self.head then
        self.head.prev = n
    end
    self.head = n

    if not self.tail then
        self.tail = n
    end
end

-- Retrieves value from cache and moves node to MRU position (-1 if not found)
function LRUCache:get(key)
    local n = self.items[key]
    if not n then
        return -1
    end
    self:removeNode(n)
    self:addToHead(n)
    return n.val
end

-- Inserts or updates key/value pair, evicting the LRU item if at capacity
function LRUCache:put(key, val)
    local n = self.items[key]
    if n then
        n.val = val
        self:removeNode(n)
        self:addToHead(n)
        return
    end

    if self.size >= self.capacity and self.tail then
        local oldTail = self.tail
        self.items[oldTail.key] = nil
        self:removeNode(oldTail)
        self.size = self.size - 1
    end

    local newNode = { key = key, val = val, prev = nil, next = nil }
    self:addToHead(newNode)
    self.items[key] = newNode
    self.size = self.size + 1
end

-- Prints the current cache elements ordered from MRU (head) to LRU (tail)
function LRUCache:printState()
    io.write(string.format("Cache (size=%d, cap=%d): [ ", self.size, self.capacity))
    local curr = self.head
    while curr do
        io.write(string.format("%s:%d ", curr.key, curr.val))
        curr = curr.next
    end
    io.write("]\n")
end

local function main()
    local cache = LRUCache.new(3)

    print("=== LRU Cache Simulation (Capacity = 3) ===")
    cache:put("a", 100)
    cache:put("b", 200)
    cache:put("c", 300)
    cache:printState()

    print(string.format("Accessing 'a': %d", cache:get("a")))
    cache:printState()

    print("Inserting 'd': 400 (triggers eviction)")
    cache:put("d", 400)
    cache:printState()

    print(string.format("Querying evicted 'b': %d", cache:get("b")))
    print(string.format("Querying present 'c': %d", cache:get("c")))
end

main()
