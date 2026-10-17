-- =============================================================================
-- Exercise 35: Circular Ring Buffer (Bounded Queue)
-- Concepts: Fixed-capacity tables, modular arithmetic ((idx + 1) % cap),
--           FIFO queue semantics, overflow rejection, and circular indexing.
-- Run:      lua 35_ring_buffer.lua
-- =============================================================================

local RingBuffer = {}
RingBuffer.__index = RingBuffer

-- Initializes a pre-allocated fixed-capacity ring buffer
function RingBuffer.new(capacity)
    local data = {}
    for i = 1, capacity do data[i] = 0 end
    return setmetatable({
        data = data,
        capacity = capacity,
        head = 0,
        tail = 0,
        size = 0
    }, RingBuffer)
end

-- Appends an item to the buffer; returns false if buffer is full
function RingBuffer:push(val)
    if self.size >= self.capacity then
        return false
    end
    self.data[self.tail + 1] = val
    self.tail = (self.tail + 1) % self.capacity
    self.size = self.size + 1
    return true
end

-- Dequeues the oldest item; returns -1 if buffer is empty
function RingBuffer:pop()
    if self.size == 0 then
        return -1
    end
    local val = self.data[self.head + 1]
    self.head = (self.head + 1) % self.capacity
    self.size = self.size - 1
    return val
end

-- Prints the current buffer elements in chronological order from head to tail
function RingBuffer:printState()
    io.write(string.format("RingBuffer (size=%d/%d, head=%d, tail=%d): [ ", self.size, self.capacity, self.head, self.tail))
    for i = 0, self.size - 1 do
        local idx = (self.head + i) % self.capacity
        io.write(string.format("%d ", self.data[idx + 1]))
    end
    io.write("]\n")
end

local function main()
    local rb = RingBuffer.new(4)

    print("=== Circular Ring Buffer (Capacity = 4) ===")
    print("Enqueue 10, 20, 30:")
    rb:push(10)
    rb:push(20)
    rb:push(30)
    rb:printState()

    print(string.format("Dequeue one item: %d", rb:pop()))
    rb:printState()

    print("Enqueue 40, 50 (wraps around):")
    rb:push(40)
    rb:push(50)
    rb:printState()

    print(string.format("Attempt overflow enqueue 60: %s", rb:push(60) and "success" or "rejected (buffer full)"))
    rb:printState()

    print("Draining all items:")
    while rb.size > 0 do
        print(string.format("Popped: %d", rb:pop()))
    end
    rb:printState()
end

main()
