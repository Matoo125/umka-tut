# Exercise Dialogue Engine (`11_dialogue.um`)

### 🎯 Objective
Implement a multi-branching interactive narrative dialogue tree.

### 🧠 Core Concepts
- State machine node representation with choices.
- Directed graph traversal based on player selection.

### ⚖️ Umka vs Lua
- **Umka**: Nodes can be represented as structs with explicit choice arrays.
- **Lua**: Dynamic nested tables of nodes and options.

### ⚠️ Common Pitfalls
- Dead-end choices that don't correctly terminate the loop or transition to valid states.
