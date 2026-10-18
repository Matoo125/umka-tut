# Exercise 40: Bloom Filter & BitSet

## Objective

Implement a space-efficient **Bloom Filter** backed by a contiguous **BitSet** in Umka and Lua. Utilize bitwise arithmetic (`|`, `&`, `~`, `<<`, `>>`) for packed bit storage alongside independent seeded polynomial hash functions to test probabilistic set membership with guaranteed zero false negatives.

---

## Core Concepts

### 1. BitSet (Bit Array)
Standard integer types allocate 32 or 64 bits. A `BitSet` packs boolean flags into an array of unsigned words (`[]uint` in Umka, standard 64-bit integers in Lua 5.4), reducing memory usage by $8\times$ compared to byte arrays and $32\times$ compared to full word integers:
- **Set bit $i$**:
  $$\text{wordIndex} = \lfloor i / 32 \rfloor, \quad \text{bitOffset} = i \pmod{32}$$
  $$\text{words}[\text{wordIndex}] \leftarrow \text{words}[\text{wordIndex}] \mid (1 \ll \text{bitOffset})$$
- **Test bit $i$**:
  $$(\text{words}[\text{wordIndex}] \ \& \ (1 \ll \text{bitOffset})) \ne 0$$

### 2. Bloom Filter Invariants
A Bloom Filter is a space-efficient probabilistic data structure invented by Burton Howard Bloom in 1970.
- **Insertion**: An element $x$ is hashed by $k$ independent hash functions $h_1, h_2, \dots, h_k$ to produce $k$ indices in $[0, m-1]$. All $k$ corresponding bits in the bit array are set to 1.
- **Membership Query**: To check if $y$ was inserted, compute $h_1(y), \dots, h_k(y)$.
  - If **any** of the $k$ bits is 0: $y$ is **definitely NOT** in the set (**True Negative**).
  - If **all** $k$ bits are 1: $y$ is **possibly** in the set (**True Positive** or **False Positive**).
- **Fundamental Invariant**: **No False Negatives**. A previously inserted element will never return `false`.

### 3. Hash Function Independence & Modulo Guarding
We compute $k$ independent hashes using seeded polynomial rolling hashes:
$$h_i(s) = \left(\sum_{j=0}^{|s|-1} s[j] \cdot 31^{|s|-1-j} + \text{seed}_i\right) \pmod M$$
Because Umka enforces runtime integer overflow checks on signed/unsigned 32-bit types, computing intermediate steps modulo a large prime ($M = 1{,}000{,}003$) ensures safe arithmetic without overflow exceptions while retaining uniform dispersion.

---

## Umka vs. Lua Implementation Nuances

| Feature | Umka | Lua |
| :--- | :--- | :--- |
| **Bitwise Operators** | `|` (OR), `&` (AND), `~` (XOR / NOT), `<<`, `>>` | `|` (OR), `&` (AND), `~` (XOR / NOT), `<<`, `>>` |
| **Bitwise Word Width** | `uint` (32-bit unsigned word) | 64-bit integer, but indexed here with 32-bit word chunks for parity |
| **Word Array Indexing** | 0-based slice `words[bit / 32]` | 1-based table `words[math.floor(bit / 32) + 1]` |
| **Byte Extraction** | Direct ASCII char indexing `s[i]` returns `char` | `string.byte(s, i)` returns numeric code |

---

## Verification & Output Walkthrough

```text
=== Bloom Filter & BitSet ===
Filter capacity: 64 bits, 3 hash functions
Adding elements:
  + "umka"
  + "lua"
  + "compiler"
  + "interpreter"

BitSet Visualization:
[00010011 00000010 00000000 01000010 00101000 00001000 10000000 10000000]
Bits set: 11 / 64 (17.2% fill rate)

Querying Membership:
  contains("umka"       ) -> true  (expected: true)
  contains("lua"        ) -> true  (expected: true)
  contains("compiler"   ) -> true  (expected: true)
  contains("interpreter") -> true  (expected: true)
  contains("python"     ) -> false (expected: false)
  contains("rust"       ) -> false (expected: false)
  contains("javascript" ) -> false (expected: false)

Bloom filter verification passed with zero false negatives.
```

---

## Common Pitfalls

1. **Umka XOR Operator**: Umka uses `~` for bitwise XOR (unlike C/Go which uses `^`), because `^` is reserved for pointer dereferencing and pointer type construction (e.g. `^Node`).
2. **Overflow Exceptions**: Umka's virtual machine runtime enforces overflow checks (`Overflow of int32` / `uint32`). Always clamp or modulo arithmetic when accumulating hash products.
3. **BitSet Word Allocation**: When sizing the words buffer for $N$ bits, always ceiling divide: `(N + 31) / 32`. Integer truncation `N / 32` misses the trailing word when $N$ is not an exact multiple of 32.
