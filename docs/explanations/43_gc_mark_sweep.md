# Exercise 43: Mark-and-Sweep Garbage Collector Simulation

## Objective

Simulate a classic **Mark-and-Sweep Garbage Collector (GC)** in Umka and Lua. The program models managed heap allocations, directed object pointer graphs with isolated reference cycles, active root sets, recursive reachability tracing (mark phase), and dead object memory reclamation (sweep phase).

---

## Core Concepts

### 1. The Cyclic Reference Problem
Naive reference counting (where each object tracks its inbound reference count) reclaims memory immediately when an object's reference counter hits zero. However, when two or more objects hold circular references to each other (e.g., $A \to B$ and $B \to A$) and become disconnected from all application roots:
- The reference counts of $A$ and $B$ remain at $\ge 1$.
- A pure reference counting collector will **leak** these objects indefinitely.
- Umka avoids this in user code via **weak pointers** (`weak ^Node`), while general tracing collectors (such as JVM, Go, and Lua) resolve it with tracing mark-and-sweep cycles.

### 2. The Mark Phase (Reachability Tracing)
- Begins from the **Root Set**: references directly residing in execution frames (call stacks) or global registries.
- Resets all object `marked` flags to `false`.
- For each root identifier, performs a graph traversal (DFS or BFS):
  - If node is already `marked`, return (breaks cycles).
  - Mark node as `marked = true`.
  - Recurse through all outbound child references in `refs`.

### 3. The Sweep Phase (Reclamation)
- Scans the entire heap linearly.
- For each object:
  - If `marked == false`: the object is completely unreachable from all active roots. Reclaim its memory and remove it from the active heap pool.
  - If `marked == true`: the object survived. Reset `marked = false` in preparation for future GC passes.

---

## Umka vs. Lua Implementation Nuances

| Feature | Umka | Lua |
| :--- | :--- | :--- |
| **Object Representation** | Concrete struct `type GCObject = struct { id: int; marked: bool; refs: []int }` | Dynamic table `{ id = 1, marked = false, refs = { 2 } }` |
| **Heap Storage** | Slice `[]GCObject` filtered into new active slice `alive` | Table array `self.objects` filtered into new table `alive` |
| **Object Search** | Linear scan method `findIndex(id: int): int` | Linear scan method `findIndex(id)` |
| **Cycle Handling** | Recursion guard checks `h.objects[idx].marked` to prevent infinite loops | Recursion guard checks `self.objects[idx].marked` |

---

## Sample Run & Output

```text
=== Mark-and-Sweep Garbage Collector Simulation ===
Allocating 6 heap objects:
  + Object 1 (Root A) -> refs [2]
  + Object 2          -> refs [3]
  + Object 3          -> refs []
  + Object 4 (Root B) -> refs []
  + Object 5 (Cycle)  -> refs [6]
  + Object 6 (Cycle)  -> refs [5]

Active Root Set: [ 1 4 ]
Heap state before GC: 6 objects allocated

--- Triggering Garbage Collection ---
[Mark Phase]
  Marked live root 1 and transitively: 2, 3
  Marked live root 4
[Sweep Phase]
  Reclaiming dead object 5 (Cycle garbage)
  Reclaiming dead object 6 (Cycle garbage)

Heap state after GC: 4 objects active, 2 reclaimed
Live objects: [ 1 2 3 4 ]
Garbage collection cycle completed successfully.
```

---

## Common Pitfalls

1. **Infinite Recursion on Cycles**: When traversing object reference graphs, if you fail to check whether an object is already `marked` before recursing into its children, circular references ($A \to B \to A$) will trigger stack overflow crashes.
2. **Post-GC Mark Cleanup**: For surviving objects, clearing the `marked` flag at the conclusion of the sweep phase is required so subsequent GC runs start with a clean state.
3. **In-Place Array Shrinking**: Removing items while iterating through a slice can skip elements due to index shifting. Allocating a clean `alive` collection during the sweep avoids index corruption.
