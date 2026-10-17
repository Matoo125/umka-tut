# Exercise 3D Vector & Matrix Math (`21_vector_matrix.um`)

### 🎯 Objective
3D vector mathematics and transformation matrices using the standard `mat.um` module.

### 🧠 Core Concepts
- `import "mat.um"`.
- Vector structures: `mat::Vec` and methods `.add()`, `.sub()`, `.dot()`, `.cross()`, `.norm()`.
- Matrix structures: `mat::Mat` for transformations and vector multiplication.

### ⚖️ Umka vs Lua
- **Umka**: Built-in standard module with optimized C-level speed.
- **Lua**: Requires custom Vector3 class or table library.

### ⚠️ Common Pitfalls
- Order of cross-product operands matters (u x v = -(v x u)).
