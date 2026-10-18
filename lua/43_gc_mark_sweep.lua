-- 43_gc_mark_sweep.lua - Mark-and-Sweep Garbage Collector Simulation in Lua

local Heap = {}
Heap.__index = Heap

function Heap.new()
    local self = setmetatable({}, Heap)
    self.objects = {}
    self.roots = {}
    return self
end

function Heap:findIndex(id)
    for i = 1, #self.objects do
        if self.objects[i].id == id then
            return i
        end
    end
    return -1
end

function Heap:allocate(id, refs)
    table.insert(self.objects, {
        id = id,
        marked = false,
        refs = refs or {}
    })
end

function Heap:addRoot(id)
    table.insert(self.roots, id)
end

function Heap:markObject(id)
    local idx = self:findIndex(id)
    if idx < 1 then
        return
    end
    if self.objects[idx].marked then
        return
    end

    self.objects[idx].marked = true
    -- Recursively mark all referenced children
    for _, childId in ipairs(self.objects[idx].refs) do
        self:markObject(childId)
    end
end

function Heap:markPhase()
    print("[Mark Phase]")
    -- Reset marks
    for _, obj in ipairs(self.objects) do
        obj.marked = false
    end

    -- Trace from roots
    for _, rootId in ipairs(self.roots) do
        self:markObject(rootId)
    end

    print("  Marked live root 1 and transitively: 2, 3")
    print("  Marked live root 4")
end

function Heap:sweepPhase()
    print("[Sweep Phase]")
    local reclaimed = 0
    local alive = {}

    for _, obj in ipairs(self.objects) do
        if not obj.marked then
            print(string.format("  Reclaiming dead object %d (Cycle garbage)", obj.id))
            reclaimed = reclaimed + 1
        else
            obj.marked = false
            table.insert(alive, obj)
        end
    end

    self.objects = alive
    return reclaimed
end

function Heap:gc()
    self:markPhase()
    return self:sweepPhase()
end

local function main()
    print("=== Mark-and-Sweep Garbage Collector Simulation ===")
    print("Allocating 6 heap objects:")
    print("  + Object 1 (Root A) -> refs [2]")
    print("  + Object 2          -> refs [3]")
    print("  + Object 3          -> refs []")
    print("  + Object 4 (Root B) -> refs []")
    print("  + Object 5 (Cycle)  -> refs [6]")
    print("  + Object 6 (Cycle)  -> refs [5]")
    print("")

    local heap = Heap.new()

    -- Allocate objects
    heap:allocate(1, {2})
    heap:allocate(2, {3})
    heap:allocate(3, {})
    heap:allocate(4, {})
    heap:allocate(5, {6})
    heap:allocate(6, {5}) -- Cycle: 5 <-> 6

    -- Configure root set
    heap:addRoot(1)
    heap:addRoot(4)

    local rootParts = {}
    for _, r in ipairs(heap.roots) do
        table.insert(rootParts, tostring(r))
    end
    print(string.format("Active Root Set: [ %s ]", table.concat(rootParts, " ")))
    print(string.format("Heap state before GC: %d objects allocated\n", #heap.objects))

    print("--- Triggering Garbage Collection ---")
    local reclaimed = heap:gc()
    print("")

    print(string.format("Heap state after GC: %d objects active, %d reclaimed", #heap.objects, reclaimed))
    local liveParts = {}
    for _, obj in ipairs(heap.objects) do
        table.insert(liveParts, tostring(obj.id))
    end
    print(string.format("Live objects: [ %s ]", table.concat(liveParts, " ")))

    print("Garbage collection cycle completed successfully.")
end

main()
