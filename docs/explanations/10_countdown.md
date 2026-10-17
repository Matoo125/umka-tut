# Exercise Countdown (`10_countdown.um`)

### 🎯 Objective
Print a countdown sequence down to 0 and terminate with a completion message.

### 🧠 Core Concepts
- Decrementing loop: `for i := start; i >= 0; i--`.
- Terminal condition validation.

### ⚖️ Umka vs Lua
- **Umka**: `i--` decrement statement in loop header.
- **Lua**: `for i = start, 0, -1 do`.

### ⚠️ Common Pitfalls
- Unsigned vs signed integers: If using unsigned types, decrementing past zero wraps around to `MAX_INT`.
