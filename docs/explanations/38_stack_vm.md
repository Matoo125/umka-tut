# Exercise 38: Stack-Based Bytecode Virtual Machine

## Objective

Design and execute a deterministic, stack-based bytecode virtual machine (VM) in Umka and Lua. The VM reads an array of instructions comprising an opcode enum and an integer argument, manipulating an operand stack to evaluate arithmetic expressions, comparisons, stack shuffling primitives, and conditional loops.

---

## Core Concepts

### 1. Stack Machine Architecture
Unlike register-based virtual machines (like the Lua 5.x VM) where instructions reference explicit virtual register addresses (e.g. `ADD R1, R2, R3`), a stack-based virtual machine (like the JVM, Python VM, Forth, or Umka's own compiler internals) pushes and pops operands on an implicit operand stack:
- Zero-address or single-address instructions simplify code generation.
- Evaluation of binary operations consumes the top two elements:
  $$\text{top} \leftarrow a \text{ op } b \quad (\text{where } a \text{ was pushed before } b)$$

### 2. Instruction Set Architecture (ISA)
Our VM supports 15 core instructions:
- **Literals & Memory**: `OP_PUSH <val>` pushes immediate integers to the stack.
- **Arithmetic**: `OP_ADD`, `OP_SUB`, `OP_MUL`, `OP_DIV` (with divide-by-zero protection).
- **Comparison**: `OP_CMP_EQ`, `OP_CMP_LT` (pushes 1 if true, 0 if false).
- **Control Flow**:
  - `OP_JMP <target>`: Unconditional branch setting the instruction pointer `ip = target`.
  - `OP_JNZ <target>`: Pops top condition; if $\text{cond} \ne 0$, sets `ip = target`.
- **Stack Manipulation (Forth Primitives)**:
  - `OP_DUP`: Duplicates top item ($[a] \to [a, a]$).
  - `OP_OVER`: Duplicates second-to-top item ($[a, b] \to [a, b, a]$).
  - `OP_SWAP`: Swaps top two items ($[a, b] \to [b, a]$).
  - `OP_DROP`: Discards top item ($[a] \to []$).
- **I/O & Lifecycle**:
  - `OP_PRINT`: Pops and prints formatted integer output.
  - `OP_HALT`: Stops the fetch-decode-execute loop.

---

## Umka vs. Lua Implementation Nuances

| Concept | Umka | Lua |
| :--- | :--- | :--- |
| **Opcode Enumeration** | Strongly typed `enum`: `type Opcode = enum { OP_PUSH, ... }` | Integer constant table: `local Opcode = { OP_PUSH = 1, ... }` |
| **Instruction Record** | Concrete struct `type Instr = struct { op: Opcode; arg: int }` | Table `{ op = Opcode.OP_PUSH, arg = 7 }` |
| **Instruction Pointer Addressing** | 0-based bytecode index (`inst.arg` ranges from `0` to `len-1`) | 1-based indexing; VM runtime maps 0-based bytecode addresses via `inst.arg + 1` |
| **Integer Division** | Typed integer division `a / b` yields `int` | `math.floor(a / b)` ensures truncated integer quotient |
| **Stack Buffer** | Fixed-size array `[128]int` with bounds-checked stack pointer `sp` | Dynamic table `stack[sp]` with bounds checks |

---

## Program Walkthrough

### Program 1: Arithmetic Expression
Computes `(7 + 3) * 4 - 5`:
```text
0: PUSH 7    [7]
1: PUSH 3    [7, 3]
2: ADD       [10]
3: PUSH 4    [10, 4]
4: MUL       [40]
5: PUSH 5    [40, 5]
6: SUB       [35]
7: PRINT     [] (emits "Result: 35")
8: HALT
```

### Program 2: Loop / Accumulator (Triangular Sum of 5)
Computes $\sum_{i=1}^{5} i = 15$ maintaining state $[acc, n]$ on the stack:
```text
0:  PUSH 0     [0]
1:  PUSH 5     [0, 5]
-- Loop Head --
2:  DUP        [acc, n, n]
3:  JNZ 5      [acc, n] -> if n != 0 jump to body (5)
4:  JMP 12     [acc, n] -> if n == 0 jump to exit (12)
-- Loop Body --
5:  SWAP       [n, acc]
6:  OVER       [n, acc, n]
7:  ADD        [n, acc + n]
8:  SWAP       [acc + n, n]
9:  PUSH 1     [acc + n, n, 1]
10: SUB        [acc + n, n - 1]
11: JMP 2      loop back to check
-- Exit --
12: DROP       [acc] (drops remaining 0)
13: PRINT      [] (emits "Result: 15")
14: HALT
```

---

## Common Pitfalls

1. **Stack Underflow on Binary Ops**: Always verify that `sp >= 2` before binary operations, or encapsulate check in `pop()` with early VM termination.
2. **Jump Target Offsets**: Ensure that jump target offsets in control flow instructions correspond accurately to target instruction indices.
3. **Operand Evaluation Order**: In non-commutative operations like `SUB` and `DIV`, popping top element yields $b$ (the right-hand operand), and the second pop yields $a$ (the left-hand operand). Always compute $a - b$ and $a / b$, not $b - a$.
