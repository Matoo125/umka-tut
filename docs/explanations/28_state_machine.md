# Exercise Finite State Machine (FSM) (`28_state_machine.um`)

### 🎯 Objective
Model an event-driven system with strict state transition validation using enums.

### 🧠 Core Concepts
- Enumerations: `State = enum { Idle, Connecting, Connected, Disconnected }`.
- Deterministic transition tables / switch-case validation.
- Guarding against illegal transitions in the current state.

### ⚖️ Umka vs Lua
- **Umka**: Type-safe `enum` values checked at compile time.
- **Lua**: Table lookup or integer constants representing states and events.

### ⚠️ Common Pitfalls
- Omitting default handling or failing to detect invalid transition attempts.
