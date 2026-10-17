# Exercise Trie (Prefix Tree) & Autocomplete (`32_trie_prefix_tree.um`)

### 🎯 Objective
Build a prefix tree (Trie) for fast O(L) string membership tests, prefix searches, and autocomplete.

### 🧠 Core Concepts
- 26-way multi-child tree nodes: `children: [26]^TrieNode`.
- Character index arithmetic: `idx := int(ch) - int('a')`.
- Autocomplete: Navigating to the prefix node followed by Depth-First Search (DFS) word collection.

### ⚖️ Umka vs Lua
- **Umka**: Fixed-size child array `[26]^TrieNode` for compact memory and O(1) letter lookup.
- **Lua**: Hash table child map `children[ch]`.

### ⚠️ Common Pitfalls
- Forgetting to mark `isEndOfWord = true` at the final node of inserted words.
