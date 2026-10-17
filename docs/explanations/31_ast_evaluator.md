# Exercise Expression Parser & AST Evaluator (`31_ast_evaluator.um`)

### 🎯 Objective
Parse mathematical expressions into an Abstract Syntax Tree (AST) using recursive descent and evaluate it.

### 🧠 Core Concepts
- Operator precedence grammar:
  - `parsePrimary`: Numbers and parenthesized groups `(...)`
  - `parseTerm`: Multiplications and divisions (`*`, `/`)
  - `parseExpr`: Additions and subtractions (`+`, `-`)
- AST tree node representation with `^Node` heap pointers.
- Recursive tree evaluation and infix pretty-printing.

### ⚖️ Umka vs Lua
- **Umka**: Mutually recursive functions requiring forward declaration `fn parseExpr(p: ^Parser): ^Node`.
- **Lua**: Forward declaration with `local parseExpr`.

### ⚠️ Common Pitfalls
- Infinite recursion when parenthesized sub-expressions fail to consume closing `)`.
