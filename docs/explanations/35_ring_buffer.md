# Exercise Circular Ring Buffer (`35_ring_buffer.um`)

### 🎯 Objective
Implement a high-performance, fixed-capacity Circular Ring Buffer (bounded FIFO queue) using modular arithmetic. Demonstrate enqueueing, dequeueing, overflow rejection, and chronological iteration.

### 🧠 Core Concepts
- Fixed-capacity memory: Pre-allocating continuous storage with `make([]int, cap)`.
- Modular indexing: Advancing write and read indices circularly with `(idx + 1) % capacity`.
- State disambiguation: Using an explicit `size` counter to differentiate between an empty buffer (`size == 0`) and a full buffer (`size == capacity`) when `head == tail`.
- FIFO queue semantics: Guaranteeing first-in, first-out order without shifting array elements on dequeue.

### ⚖️ Umka vs Lua
- **Umka**: 0-based array indexing fits `(idx + 1) % capacity` naturally.
- **Lua**: 1-based table indexing requires offset conversion (`self.data[self.tail + 1]`).

### ⚠️ Common Pitfalls
- Advancing `head` or `tail` with simple `++` without wrapping modulo leads to out-of-bounds panics.
- Relying solely on `head == tail` to detect emptiness makes it impossible to distinguish an empty buffer from a full one.
