# Exercise Functional Closures & fnc.um (`22_functional_programming.um`)

### 🎯 Objective
High-order functional closures and pipeline data transformations using `fnc.um`.

### 🧠 Core Concepts
- `import "fnc.um"`.
- Anonymous closures with variable capture: `|x: int|: bool { return x > 5; }`.
- Functional pipelines: `fnc::Array(data).filter(...).transform(...).reduce(...)`.

### ⚖️ Umka vs Lua
- **Umka**: Closure syntax uses pipe delimiters `|args|: ReturnType { ... }`.
- **Lua**: Standard `function(x) return ... end`.

### ⚠️ Common Pitfalls
- Capturing outer variables by value vs reference in tight loops.
