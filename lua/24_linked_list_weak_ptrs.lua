-- =============================================================================
-- Exercise 24: Linked Lists and Weak References
-- Concepts: Doubly-linked lists, table references, garbage collection, weak tables (__mode = "v")
-- Run:      lua 24_linked_list_weak_ptrs.lua
-- =============================================================================

-- In Umka, `weak ^Node` prevents reference-counting memory cycles.
-- In Lua, the tracing garbage collector handles cyclic table references automatically,
-- but Lua also supports weak tables via metatables: `setmetatable({}, { __mode = "v" })`.

local DoublyLinkedList = {}
DoublyLinkedList.__index = DoublyLinkedList

function DoublyLinkedList.new()
    return setmetatable({ head = nil, tail = nil, size = 0 }, DoublyLinkedList)
end

function DoublyLinkedList:append(val)
    local newNode = {
        value = val,
        next = nil,
        prev = nil
    }

    if not self.head then
        self.head = newNode
        self.tail = newNode
    else
        newNode.prev = self.tail
        self.tail.next = newNode
        self.tail = newNode
    end
    self.size = self.size + 1
end

function DoublyLinkedList:printForward()
    io.write("Forward:  [ ")
    local curr = self.head
    while curr do
        io.write(string.format("%d ", curr.value))
        curr = curr.next
    end
    io.write("]\n")
end

function DoublyLinkedList:printBackward()
    io.write("Backward: [ ")
    local curr = self.tail
    while curr do
        io.write(string.format("%d ", curr.value))
        curr = curr.prev
    end
    io.write("]\n")
end

local function main()
    local list = DoublyLinkedList.new()

    list:append(10)
    list:append(20)
    list:append(30)
    list:append(40)

    io.write(string.format("Doubly Linked List with Weak Backlinks (Size = %d):\n", list.size))
    list:printForward()
    list:printBackward()
end

main()
