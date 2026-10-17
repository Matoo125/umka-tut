# Exercise Factorial (`07_factorial.um`)

### 🎯 Objective
Compute N! for non-negative integers and reject negative numbers with clean error reporting.

### 🧠 Core Concepts
- Input bounds validation (`n >= 0`).
- Iterative loop accumulation: `fact *= i`.

### ⚖️ Umka vs Lua
- **Umka**: Integer overflow occurs at 64-bit boundaries (`int` is 64-bit signed).
- **Lua**: Lua 5.4 uses 64-bit signed integers by default.

### ⚠️ Common Pitfalls
- Factorial grows extremely quickly; N > 20 exceeds 64-bit signed integer limits.
