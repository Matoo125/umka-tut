# Exercise 46: LR Shift-Reduce Parser State Machine

## Objective

Build a deterministic **LR(0) / SLR(1) Shift-Reduce Parser** table engine in Umka and Lua. The program models context-free grammar production rules, processes token streams against an explicit state machine action/goto table, maintains synchronized state and symbol stacks, and outputs a step-by-step trace of parser operations.

---

## Core Concepts

### 1. LR Parsing Mechanics
LR parsers read input from **L**eft to right, constructing a **R**ightmost derivation in reverse:
- **Bottom-Up Construction**: Unlike top-down predictive parsers (like LL(1) or recursive descent) which guess rules before seeing all tokens, bottom-up parsers shift terminals onto a stack until a valid right-hand side (handle) appears, then reduce it to a non-terminal.
- **State Machine Integration**: Each state in the parser represents a set of LR items (grammar rules with a marker `•` indicating what has been seen and what is expected).

### 2. The Grammar
```text
(1) E -> E + T
(2) E -> T
(3) T -> id
```
Augmented with start rule `(0) S' -> E`.

### 3. Action and GOTO Tables
- **ACTION Table**: Indexed by `(State, Terminal)`
  - `Shift S`: Push incoming token and destination state $S$; advance input stream.
  - `Reduce R`: Pop $|\text{RHS}|$ symbols and states for production rule $R$; consult GOTO table.
  - `Accept`: Successfully reached augmented goal state upon reading EOF marker `$`.
  - `Error`: Syntax error.
- **GOTO Table**: Indexed by `(State, NonTerminal)`
  - Directs the parser to the next state after reducing to a non-terminal symbol.

---

## Umka vs. Lua Implementation Nuances

| Feature | Umka | Lua |
| :--- | :--- | :--- |
| **Action Representation** | Strongly typed struct: `type Action = struct { actType: ActionType; val: int }` | Table `{ actType = ActionType.ACT_SHIFT, val = 2 }` |
| **Parser Stacks** | Separate dynamic slices `[]int` and `[]str` shrunk via `delete(slice, len-1)` | Lua tables shrunk via `table.remove(t)` |
| **Terminal Symbol `$``** | End-of-file marker literal string `"$"`` | End-of-file marker string `"$"` |
| **Token Stream Pointer** | 0-based integer offset `ip` | 1-based integer index `ip` |

---

## Sample Run & Step-by-Step Trace

```text
=== LR Shift-Reduce Parser State Machine ===
Grammar Rules:
  (1) E -> E + T
  (2) E -> T
  (3) T -> id

Parsing Input: id + id + id

Step  State Stack      Symbol Stack         Action
------------------------------------------------------------
 0    [ 0 ]            [ $ ]                Shift 2
 1    [ 0 2 ]          [ $ id ]             Reduce (3) T -> id
 2    [ 0 3 ]          [ $ T ]              Reduce (2) E -> T
 3    [ 0 1 ]          [ $ E ]              Shift 4
 4    [ 0 1 4 ]        [ $ E + ]            Shift 2
 5    [ 0 1 4 2 ]      [ $ E + id ]         Reduce (3) T -> id
 6    [ 0 1 4 5 ]      [ $ E + T ]          Reduce (1) E -> E + T
 7    [ 0 1 ]          [ $ E ]              Shift 4
 8    [ 0 1 4 ]        [ $ E + ]            Shift 2
 9    [ 0 1 4 2 ]      [ $ E + id ]         Reduce (3) T -> id
10    [ 0 1 4 5 ]      [ $ E + T ]          Reduce (1) E -> E + T
11    [ 0 1 ]          [ $ E ]              Accept

Parse Result: SUCCESS (Input fully accepted by grammar)
```

---

## Common Pitfalls

1. **Stack popping count**: When reducing by a rule of length $K$, exactly $K$ symbols and $K$ states must be popped from their respective stacks before querying the GOTO table on the exposed top state.
2. **Shift/Reduce and Reduce/Reduce Conflicts**: Ambiguous grammars can lead to multiple valid actions for a `(state, token)` pair. Using LR items and lookaheads (SLR/LALR) disambiguates operator precedence and associativity.
3. **Empty Stack Access**: Always seed the state stack with initial state `0` and bottom-of-stack sentinel `$` to prevent underflow during reduction.
