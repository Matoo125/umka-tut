# Exercise JSON Lexer & Parser (`25_json_parser.um`)

### 🎯 Objective
Tokenize and parse JSON objects into a structured AST and map dictionary.

### 🧠 Core Concepts
- Lexer: Scanning string tokens, identifiers, numeric literals, and delimiters.
- Tagged unions: Representing JSON values (`String`, `Number`, `Boolean`, `Object`).
- AST formatting: Recursive `.repr()` method.

### ⚖️ Umka vs Lua
- **Umka**: Requires tagged union struct (`Value = struct { kind, strVal, numVal, boolVal, objVal }`).
- **Lua**: Heterogeneous tables naturally hold strings, numbers, booleans, and nested tables without tagging.

### ⚠️ Common Pitfalls
- Handling escaped characters in JSON string literals (`\"`, `\\`).
