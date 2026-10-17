# Exercise File I/O and Content Processing (`20_file_io.um`)

### 🎯 Objective
Read, write, and process text and binary files using standard I/O streams.

### 🧠 Core Concepts
- File handles: `std::File`.
- Stream operations: `std::fopen(path, mode)`, `std::fwrite`, `std::freadall`, `std::fclose`.
- Resource cleanup and error handling.

### ⚖️ Umka vs Lua
- **Umka**: `freadall` reads the entire remaining stream into a string buffer.
- **Lua**: `file:read("*a")` reads all contents.

### ⚠️ Common Pitfalls
- Forgetting `std::fclose(f)` leads to leaked file descriptors and uncommitted disk buffers.
