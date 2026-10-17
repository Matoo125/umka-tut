# Exercise Embedded Interfaces & Wrappers (`18_embedded_interfaces.um`)

### 🎯 Objective
Compose interfaces hierarchically by embedding sub-interfaces into composite contracts.

### 🧠 Core Concepts
- Interface embedding:
  ```um
  type Reader = interface { read(): str }
  type Writer = interface { write(s: str) }
  type ReadWriter = interface { Reader; Writer }
  ```
- Modular system boundaries and wrapper decorators.

### ⚖️ Umka vs Lua
- **Umka**: Compile-time verified interface composition.
- **Lua**: Manual table delegation or multi-inheritance metatables.

### ⚠️ Common Pitfalls
- Missing any method of an embedded interface prevents the struct from satisfying the parent interface.
