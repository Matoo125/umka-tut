# Exercise Multiplication Table (`05_multiplication_table.um`)

### 🎯 Objective
Print an aligned N x N multiplication grid.

### 🧠 Core Concepts
- Nested C-style loops: `for i := 1; i <= n; i++`
- Column width alignment via format specifiers: `printf("%4d", i * j)`

### ⚖️ Umka vs Lua
- **Umka**: C-style loops `for init; cond; post { ... }`.
- **Lua**: Numerical `for i = 1, n do ... end`.

### ⚠️ Common Pitfalls
- Using `%d` instead of `%4d` results in jagged, misaligned columns as numbers grow from 1 to 2 digits.
