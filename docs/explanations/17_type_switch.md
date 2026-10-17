# Exercise Type Switch and Any (`17_type_switch.um`)

### 🎯 Objective
Inspect runtime dynamic values and recover concrete types using type switches and `any`.

### 🧠 Core Concepts
- The `any` type (alias for empty interface `interface{}`).
- Type switch syntax: `switch val := type(item) { case int: ... case str: ... }`.

### ⚖️ Umka vs Lua
- **Umka**: `switch val := type(item)` automatically binds `val` to the downcasted concrete type inside each `case` block!
- **Lua**: Uses `type(item) == "string"` runtime string checks.

### ⚠️ Common Pitfalls
- Attempting Go-style `item.(type)` which is a syntax error in Umka. Always use `switch val := type(item)`.
