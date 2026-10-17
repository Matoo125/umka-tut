# Exercise Word Frequency Counter (`14_word_frequency.um`)

### 🎯 Objective
Count occurrences of unique words in text and output frequency counts.

### 🧠 Core Concepts
- Hash maps: `map[str]int`.
- Map initialization: `counts := make(map[str]int)`.
- Key existence test: `validkey(counts, word)`.
- Iteration: `keys := keys(counts)`.

### ⚖️ Umka vs Lua
- **Umka**: Checking membership requires `validkey(map, key)`. `for k in map` is not an if-check!
- **Lua**: Checking membership is simply `if counts[word] then`.

### ⚠️ Common Pitfalls
- Using `if word in counts` triggers a compile error in Umka; `validkey` must be used.
