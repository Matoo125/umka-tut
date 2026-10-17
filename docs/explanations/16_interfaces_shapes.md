# Exercise Polymorphic Shapes Interface (`16_interfaces_shapes.um`)

### 🎯 Objective
Demonstrate runtime polymorphism through Go-style duck-typed interfaces.

### 🧠 Core Concepts
- Interface declaration: `type Shape = interface { area(): real; perimeter(): real }`.
- Implicit implementation: Any struct that defines the required method set satisfies the interface without explicit `implements` keyword.
- Dynamic dispatch across heterogeneous collections `[]Shape`.

### ⚖️ Umka vs Lua
- **Umka**: Type-safe dynamic dispatch verified at compile time and runtime.
- **Lua**: Duck typing via method tables without compile-time interface contracts.

### ⚠️ Common Pitfalls
- Method receiver pointer mismatch: If an interface specifies `area(): real`, a method with `(s: ^Struct) area()` requires pointer assignment.
