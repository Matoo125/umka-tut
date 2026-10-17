# Exercise Table Art (`06_table_art.um`)

### 🎯 Objective
Render a rectangular ASCII border with corners `+`, horizontal bars `-`, and vertical pipes `|`.

### 🧠 Core Concepts
- Input validation: Ensuring width and height are >= 2.
- Conditional edge rendering inside nested 2D loops.

### ⚖️ Umka vs Lua
- **Umka**: Logical operators are C-style `&&`, `||`, `!`.
- **Lua**: Word operators `and`, `or`, `not`.

### ⚠️ Common Pitfalls
- Forgetting to validate dimensions before attempting to print the interior rows.
