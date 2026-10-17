-- =============================================================================
-- Exercise 29: Priority Queue / Binary Min-Heap
-- Concepts: Binary heap table representation, parent/child index arithmetic
--           (`idx // 2`, `2*idx`, `2*idx+1`), sift-up insertion, sift-down deletion,
--           and logarithmic O(log N) priority order retrieval.
-- Run:      lua 29_min_heap.lua
-- =============================================================================

local MinHeap = {}
MinHeap.__index = MinHeap

function MinHeap.new()
    return setmetatable({ data = {} }, MinHeap)
end

-- Insert value and restore heap property by sifting up
function MinHeap:push(val)
    table.insert(self.data, val)
    local idx = #self.data

    while idx > 1 do
        local parent = idx // 2
        if self.data[idx] < self.data[parent] then
            self.data[idx], self.data[parent] = self.data[parent], self.data[idx]
            idx = parent
        else
            break
        end
    end
end

-- Extract minimum element and restore heap property by sifting down
function MinHeap:pop()
    if #self.data == 0 then return nil end
    local minVal = self.data[1]
    local lastVal = table.remove(self.data)

    if #self.data > 0 then
        self.data[1] = lastVal
        local idx = 1
        local n = #self.data

        while true do
            local smallest = idx
            local left = 2 * idx
            local right = 2 * idx + 1

            if left <= n and self.data[left] < self.data[smallest] then
                smallest = left
            end
            if right <= n and self.data[right] < self.data[smallest] then
                smallest = right
            end

            if smallest ~= idx then
                self.data[idx], self.data[smallest] = self.data[smallest], self.data[idx]
                idx = smallest
            else
                break
            end
        end
    end

    return minVal
end

local function main()
    local h = MinHeap.new()
    local values = {45, 12, 89, 3, 27, 18, 5}

    print("Pushing values into Min-Heap:")
    for _, v in ipairs(values) do
        print(string.format("Push %d", v))
        h:push(v)
    end

    print("\nPopping in sorted priority order:")
    while #h.data > 0 do
        print(string.format("Pop %d", h:pop()))
    end
end

main()
