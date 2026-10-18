# Exercise 49: Register-Based Virtual Machine

## Objective
Implement a 3-address register-based virtual machine (Register VM) and examine its dispatch loop, instruction encoding, and execution dynamics in contrast to stack-based architectures (like Exercise 38 and the Umka VM itself).

The VM executes a compact instruction set over 16 virtual registers (`R0`–`R15`), supporting:
- Register-register arithmetic: `ADD Rd, Rs1, Rs2`, `SUB Rd, Rs1, Rs2`, `MUL Rd, Rs1, Rs2`
- Immediate loading: `LOADI Rd, imm`
- Register moves: `MOV Rd, Rs`
- Conditional branching & comparison: `CMP Rs1, Rs2`, `JLT target`, `JEQ target`, `JMP target`
- System & control: `PRINT Rs`, `HALT`

The benchmark program computes the **nth Fibonacci number** (`Fib(10) = 55`) iteratively to showcase register assignment, conditional looping, and instruction dispatch.

## Core Concepts
- **Register VM vs. Stack VM**:
  - *Stack VM* (e.g. JVM, Python bytecode, Umka VM): Operands are pushed onto and popped from an evaluation stack (`push a`, `push b`, `add`, `pop c`). Instruction encoding is compact and code generation is straightforward, but it incurs high dispatch overhead and stack-memory traffic.
  - *Register VM* (e.g. Lua 5.0+, Dalvik VM, LLVM IR): Instructions specify explicit source and destination registers (`ADD R0, R1, R2`). This dramatically reduces the total instruction count and operand stack manipulation at the expense of wider instruction formats and register allocation complexity.
- **Instruction Format (3-Address Code)**:
  - Each instruction is a structured tuple:
    ```
    { op: Opcode, rd: int, rs1: int, rs2: int, imm: int }
    ```
- **Fetch-Decode-Execute Dispatch Loop**:
  - A central VM loop maintains a program counter (`pc`), a register file `[16]int`, and flags (`cmp_lt`, `cmp_eq`) updated by comparison operations.

## Umka vs. Lua Nuances
- **Struct Typing**:
  - Umka uses strongly typed structs:
    ```umka
    type Instruction = struct {
        op: int
        rd: int
        rs1: int
        rs2: int
        imm: int
    }
    ```
  - Lua uses tables to represent instructions, keyed by fields `{op = ..., rd = ..., rs1 = ..., rs2 = ..., imm = ...}`.
- **Register Addressing & 0-Indexing**:
  - Umka natively supports 0-indexed fixed arrays: `regs: [16]int`. Accessing `regs[rd]` directly maps register indices $0 \le \text{idx} < 16$.
  - Lua tables conventionally start at index 1. To avoid offset errors and keep VM register semantics clean, Lua's register table can be explicitly 0-indexed: `regs[0] = 0` through `regs[15] = 0`.
- **Control Flow**:
  - In Umka, the dispatch loop uses `for running { switch op { ... } }` with explicit bounds checking on the program counter.

## Sample Run
```text
=== Register-Based Virtual Machine ===
Registers: 16 (R0..R15)
Program: Iterative Fibonacci(10)

Disassembly:
  0: LOADI  R0, 0
  1: LOADI  R1, 1
  2: LOADI  R2, 10
  3: LOADI  R3, 0
  4: CMP    R3, R2
  5: JEQ    12
  6: ADD    R4, R0, R1
  7: MOV    R0, R1
  8: MOV    R1, R4
  9: LOADI  R5, 1
 10: ADD    R3, R3, R5
 11: JMP    4
 12: PRINT  R0
 13: HALT

Execution:
[OUTPUT] 55
Cycles executed: 88
Final registers:
  R0: 55
  R1: 89
  R2: 10
  R3: 10
```

## Common Pitfalls
1. **Branch Target Bounds**: Jump instructions (`JMP`, `JLT`, `JEQ`) set the `pc` directly. Targets must be validated to fall within $[0, \text{code.len})$ to prevent out-of-bounds execution.
2. **Comparison Flags**: A `CMP` instruction sets state flags (`cmp_lt`, `cmp_eq`). Conditional jumps inspect these flags without modifying general-purpose registers.
