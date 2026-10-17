# Exercise Priority Queue / Binary Min-Heap (`29_min_heap.um`)

### 🎯 Objective
Implement a priority queue backed by an array-based binary min-heap with O(log N) operations.

### 🧠 Core Concepts
- Binary heap indexing:
  - Parent: `(i - 1) / 2`
  - Left child: `2 * i + 1`
  - Right child: `2 * i + 2`
- Sift-up: Restoring heap order after appending to tail.
- Sift-down: Restoring heap order after replacing root with tail element.

### ⚖️ Umka vs Lua
- **Umka**: Zero-indexed math `(i - 1) / 2` on dynamic arrays `[]int`.
- **Lua**: One-indexed math `idx // 2` on tables.

### ⚠️ Common Pitfalls
- Comparing against child index out of bounds (`left < len(data)`).
