# Exercise Fibers & Coroutine Generators (`19_fibers_coroutines.um`)

### 🎯 Objective
Cooperative multitasking using lightweight fibers (coroutines) for generator pipelines.

### 🧠 Core Concepts
- Fiber creation: `fib := make(fiber, workerFunc)`.
- Cooperative yield: `resume()` inside the fiber transfers execution back to caller.
- Lifecycle validation: `valid(fib)` checks if the fiber has finished or is ready to resume.

### ⚖️ Umka vs Lua
- **Umka**: Fiber data exchange is typically handled via shared state / pointers; `resume()` yields.
- **Lua**: `coroutine.create()`, `coroutine.resume(co, val)`, and `coroutine.yield(val)` pass values directly.

### ⚠️ Common Pitfalls
- **Cannot destroy a busy fiber**: In Umka, fibers must run to completion or terminate cleanly before `main()` exits, or the runtime aborts.
