# Exercise Fibonacci (`02_fib.um`)

### 🎯 Objective
Calculate and display the first N Fibonacci numbers using recursive function calls.

### 🧠 Core Concepts
- Function definition with typed arguments and return types: `fn fib(n: int): int`
- Base cases: `n <= 0 -> 0`, `n == 1 -> 1`
- Recursive step: `fib(n - 1) + fib(n - 2)`

### ⚖️ Umka vs Lua
- **Umka**: Strict static return types. Omitting a return branch produces a compile error.
- **Lua**: Dynamic typing with `local function fib(n) ... end`.

### ⚠️ Common Pitfalls
- Deep recursion can hit stack limits; for production code, iterative tabulation or memoization is preferred.
