# Exercise Unicode & UTF-8 Decoding (`23_unicode_utf8.um`)

### 🎯 Objective
Decode multi-byte UTF-8 Unicode byte sequences into scalar code point runes.

### 🧠 Core Concepts
- `import "utf8.um"`.
- Distinguishing byte length (`len(str)`) from character rune count (`utf8::runeCount(str)`).
- Code points: `utf8::Rune`, `utf8::decode()`, and `r.encode()`.

### ⚖️ Umka vs Lua
- **Umka**: Standard library `utf8.um` handles 1-4 byte UTF-8 decoding into integer code points.
- **Lua**: Lua 5.3+ standard `utf8` library (`utf8.len`, `utf8.codes`).

### ⚠️ Common Pitfalls
- Substring slicing by byte index on multi-byte UTF-8 strings can split multi-byte runes in half.
