# Exercise Add Two Numbers (`03_add_two_numbers.um`)

### 🎯 Objective
Prompt the user for two floating-point numbers, compute their sum, and format the result.

### 🧠 Core Concepts
- Standard library console input: `scanf("%lf", &a)`
- Pointer passing with `&`: `scanf` requires addresses of destination variables.
- Double-precision floats in Umka are type `real` (equivalent to C `double`).

### ⚖️ Umka vs Lua
- **Umka**: `scanf` requires address-of operator `&a` matching C scanf conventions.
- **Lua**: `io.read("*n")` returns parsed numbers directly without pointers.

### ⚠️ Common Pitfalls
- Passing values instead of pointers (`scanf("%lf", a)`) causes compilation errors in Umka.
