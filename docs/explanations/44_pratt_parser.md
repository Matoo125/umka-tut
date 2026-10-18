# Exercise 44: Pratt Parser (Top-Down Operator Precedence)

## Objective

Build a **Top-Down Operator Precedence (Pratt) Parser** and AST evaluator in Umka and Lua. Pratt parsing elegantly replaces complex grammar stratification with token-associated **binding powers** (`lbp`), handling prefix unary operators (`-`), left-associative binary operators (`+`, `-`, `*`, `/`), right-associative operators (exponentiation `^`), and parenthesized sub-expressions.

---

## Core Concepts

### 1. Why Pratt Parsing?
Traditional recursive-descent parsers for arithmetic require a separate parsing function for every precedence tier (`parse_expr` $\to$ `parse_term` $\to$ `parse_factor` $\to$ `parse_primary`), leading to call stack overhead and rigid code repetition. 

Vaughan Pratt's 1973 algorithm associates semantic rules directly with tokens:
- **Null Denotation (`nud`)**: How a token behaves when it appears at the start of an expression with no left-hand context (literals, unary operators, opening parentheses).
- **Left Denotation (`led`)**: How a token behaves when an expression already exists to its left (infix binary operators, postfix operators).

### 2. Binding Power & Precedence Levels

| Operator | Syntax | Precedence (`lbp`) | Associativity |
| :--- | :--- | :--- | :--- |
| Literals / Parens | `123`, `(...)` | 0 | Prefix |
| `+`, `-` | Binary Infix | 10 | Left-associative |
| `*`, `/` | Binary Infix | 20 | Left-associative |
| `^` | Exponentiation | 30 | Right-associative |
| `-` | Unary Prefix | 40 | Prefix |

### 3. Associativity Mechanics in Pratt Parsing
The core loop compares the current Right Binding Power (`rbp`) against the lookahead token's Left Binding Power (`lbp`):
```text
while rbp < lbp(peek()):
    op = next()
    left = led(op, left)
```
- **Left-Associativity**: To parse `a + b + c` as `(a + b) + c`, the right operand is parsed with `nextRbp = lbp(op)`. When the second `+` is inspected, `rbp == lbp` breaks the loop, closing the left node first.
- **Right-Associativity**: To parse `a ^ b ^ c` as `a ^ (b ^ c)`, the right operand is parsed with `nextRbp = lbp(op) - 1`. The second `^` has `lbp > nextRbp`, so it is swallowed into the right subtree.

---

## Umka vs. Lua Implementation Nuances

| Feature | Umka | Lua |
| :--- | :--- | :--- |
| **Tokens & Node Kinds** | Strongly typed `enum` values (`TokenType`, `NodeKind`) | Integer dictionary constants |
| **AST Tree Nodes** | Heap-allocated pointers `^Node` via `new(Node)` | Dynamic tables `{ kind, op, left, right, val }` |
| **Char Arithmetic in Lexer** | Explicit type casting: `(int(s[i]) - int('0'))` | ASCII byte extraction: `string.byte(s, i) - string.byte("0")` |
| **Exhaustive Returns** | Functions with non-void returns require terminal return paths outside `switch` blocks | Standard fallthrough `return nil` |

---

## Sample Run & Output

```text
=== Pratt Parser (Top-Down Operator Precedence) ===
Expression: 3 + 4 * 2
  AST:    (3 + (4 * 2))
  Result: 11

Expression: 2 ^ 3 ^ 2
  AST:    (2 ^ (3 ^ 2))
  Result: 512

Expression: -5 + (10 - 2) * 3
  AST:    ((-5) + ((10 - 2) * 3))
  Result: 19

Pratt parsing and evaluation completed successfully.
```

---

## Common Pitfalls

1. **Right-Associativity Power Adjustment**: Passing `lbp + 1` for right-associative operators produces left-associative trees. Right-associative operators must reduce the right recursive binding power (`lbp - 1`) under strict inequality (`<`).
2. **Missing Token Advancement in Groups**: In parenthesized expressions `(expr)`, remember to consume both the opening `(` in `nud` and verify/consume the matching `)` before returning.
3. **Integer Exponentiation**: Avoid floating-point `pow()` rounding issues for integer domains by computing integer exponents with repeated multiplication.
