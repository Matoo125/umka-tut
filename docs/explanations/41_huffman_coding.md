# Exercise 41: Huffman Coding & Compression

## Objective

Implement a lossless data compression and decompression pipeline using **Huffman Coding** in Umka and Lua. The program dynamically analyzes character frequency statistics, greedily constructs an optimal prefix binary tree on the heap, extracts prefix-free variable-length binary codes, compresses raw text into a bitstream, and decodes the bitstream back to its original form.

---

## Core Concepts

### 1. Entropy & Variable-Length Prefix Codes
Fixed-width encodings (such as standard ASCII or UTF-8 bytes) allocate equal space (8 bits) to every character regardless of its frequency of occurrence. In contrast, Huffman coding achieves near-optimal compression by assigning shorter codes to frequent symbols and longer codes to rare symbols:
- **Prefix-Free Property**: No assigned code word is a prefix of any other code word (e.g. if `'a'` is `0`, no other code starts with `0`).
- **Unambiguous Stream Parsing**: A receiver can stream individual bits from left to right and immediately emit a symbol upon arriving at a leaf node, requiring no delimiters or punctuation between tokens.

### 2. Greedy Tree Construction
Given symbol frequencies:
1. Initialize a forest where each unique character is an isolated leaf node.
2. Select the two trees $T_1, T_2$ with the lowest root frequencies.
3. Merge them under a new internal parent node $P$ with $\text{freq}(P) = \text{freq}(T_1) + \text{freq}(T_2)$.
4. Insert $P$ back into the forest.
5. Repeat steps 2–4 until exactly one root tree remains.

### 3. Bitstream Traversal & Decoding
- To decode, start at the tree `root`.
- Read bits sequentially:
  - If `'0'`, step to `curr.left`.
  - If `'1'`, step to `curr.right`.
- When `curr.isLeaf` is true, append `curr.ch` to the output string and reset `curr = root`.

---

## Umka vs. Lua Implementation Nuances

| Feature | Umka | Lua |
| :--- | :--- | :--- |
| **Node Representation** | Heap pointer to struct: `^HuffNode` allocated via `new(HuffNode)` | Table containing `{ ch, freq, isLeaf, left, right }` |
| **Forest Collection** | Slice `[]^HuffNode` modified via `delete(forest, idx)` and `append()` | Table array modified via `table.remove(forest, idx)` and `table.insert()` |
| **Character Storage** | Typed `char` scalar (`'a'`) converted to string via `str(node.ch)` | 1-character string (`"a"`) extracted via `text:sub(i, i)` |
| **Code Lookup Table** | Dynamic slice `[]CodeEntry` traversed linearly | Hash table `codeTable[ch] = code` |

---

## Sample Run & Output

```text
=== Huffman Coding & Compression ===
Input text: "abracadabra"
Original size: 11 characters (88 bits at 8 bits/char)

Character Frequencies:
  'a': 5
  'b': 2
  'r': 2
  'c': 1
  'd': 1

Huffman Prefix Codes:
  'a' -> 0
  'b' -> 110
  'r' -> 111
  'c' -> 100
  'd' -> 101

Encoded Bitstream:
01101110100010101101110
Encoded length: 23 bits (73.9% space saved)

Decoded String:
"abracadabra"

Verification: PASS (Decoded matches original exactly)
```

---

## Common Pitfalls

1. **Forest Index Invalidation**: When extracting the two lowest-frequency nodes from a slice, removing the first minimum shifts array elements. Always locate or calculate indices carefully, or extract the first, re-evaluate indices in the remaining slice, and extract the second.
2. **Single-Character Edge Case**: If the input string consists of repetitions of only one character (e.g. `"aaaa"`), the tree consists of a single root node with no branches. Guard `buildCodes` by assigning a fallback bit like `"0"`.
3. **Deterministic Output**: Huffman trees can vary if equal-frequency nodes are ordered nondeterministically. Preserving the first-appearance scan order ensures identical tree shapes across Umka and Lua.
