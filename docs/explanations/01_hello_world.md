# Exercise Hello World (`01_hello_world.um`)

### 🎯 Objective
Print a simple greeting to standard output using Umka.

### 🧠 Core Concepts
- Program entry point: `fn main()`
- Formatted printing: `printf("Hello, World!\n")`
- Umka requires double quotes for strings and standard C-style escape characters (`\n`, `\t`).

### ⚖️ Umka vs Lua
- **Umka**: Statically typed, requires entry function `fn main()`, uses `printf` with format specifiers.
- **Lua**: Dynamic script execution, top-level `print("Hello, World!")` runs immediately.

### ⚠️ Common Pitfalls
- Forgetting `\n` in `printf` leaves output buffered without a trailing newline.
