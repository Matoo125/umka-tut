# Exercise RPN Calculator (`15_rpn_calculator.um`)

### 🎯 Objective
Evaluate arithmetic expressions in Reverse Polish Notation (Postfix) using a custom stack.

### 🧠 Core Concepts
- Stack data structure with receiver methods: `fn (s: ^Stack) push(...)`, `fn (s: ^Stack) pop(...)`.
- String parsing and conversion with `sscanf`.
- Operand stack tracking and error handling (underflow, division by zero).

### ⚖️ Umka vs Lua
- **Umka**: Receiver methods attached to pointer targets `^Stack`.
- **Lua**: Metatable `:` method syntax (`Stack:push()`).

### ⚠️ Common Pitfalls
- Popping operands in reverse order: For `a b -`, `b` is popped first, so `result = a - b`.
