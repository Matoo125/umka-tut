# Exercise LRU Cache (`33_lru_cache.um`)

### 🎯 Objective
Build a fixed-capacity Least Recently Used (LRU) Cache supporting O(1) lookups (`get`), O(1) insertions/updates (`put`), and automatic eviction of the oldest element when capacity is exceeded.

### 🧠 Core Concepts
- Hybrid data structure: `map[str]^Node` for O(1) lookup + doubly linked list (`head`, `tail`) for O(1) recency tracking.
- Memory safety: Using `weak ^Node` for `prev` back-pointers to break cyclic reference counts.
- Recency promotion: Detaching and moving accessed nodes to `head` (MRU).
- Eviction: Removing the tail node from both the linked list and hash map when `size >= capacity`.

### ⚖️ Umka vs Lua
- **Umka**: Explicit pointer dereferencing and heap allocations (`new(Node, ...)`), requiring `weak ^Node` to prevent cycle leaks.
- **Lua**: Tables act as references; table assignment and deletion (`items[k] = nil`) natively handled by tracing GC.

### ⚠️ Common Pitfalls
- Forgetting to delete the evicted node key from `cache.items` leaves dead entries in the hash map.
- Improperly updating `head` and `tail` pointers when removing the only remaining element in the list.
