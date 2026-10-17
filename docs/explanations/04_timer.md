# Exercise Interactive Timer (`04_timer.um`)

### 🎯 Objective
Create an interactive stopwatch/timer measuring elapsed time in seconds.

### 🧠 Core Concepts
- Standard library time module: `import "std.um"`
- Clock querying: `std::time()` / `std::clock()`
- Loop polling with conditional exit.

### ⚖️ Umka vs Lua
- **Umka**: Access standard library functions via namespace `std::time()`.
- **Lua**: Uses `os.clock()` or `os.time()`.

### ⚠️ Common Pitfalls
- Busy-wait loops consume 100% CPU unless cooperative sleeps or delays are utilized.
