# Exercise Linked Lists & Weak Pointers (`24_linked_list_weak_ptrs.um`)

### 🎯 Objective
Construct a doubly linked list and prevent reference-counting memory leaks using weak pointers.

### 🧠 Core Concepts
- Heap allocation: `new(Node, ...)`.
- Pointer types: Strong pointer `^Node` vs weak pointer `weak ^Node`.
- Cycle breaking: Back-references (`prev`) should be `weak ^Node` to avoid cyclic reference leaks.

### ⚖️ Umka vs Lua
- **Umka**: Reference counting GC with explicit `weak` pointer modifier for cycles.
- **Lua**: Tracing garbage collector handles cycles automatically, but supports weak tables `__mode = "v"`.

### ⚠️ Common Pitfalls
- Creating cyclic strong pointers (`A -> B -> A`) prevents memory from being freed upon leaving scope.
