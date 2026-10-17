# Exercise Guessing Game (`12_guessing_game.um`)

### 🎯 Objective
Interactive number guessing game with high/low hints, random generation, and CLI seed override.

### 🧠 Core Concepts
- Command-line arguments: `std::argc()`, `std::argv()`.
- Pseudo-random numbers: `std::rand()`.
- Deterministic seeding for automated testing.

### ⚖️ Umka vs Lua
- **Umka**: CLI arguments accessed via `std::argv(i)`.
- **Lua**: CLI arguments accessed via global `arg[i]`.

### ⚠️ Common Pitfalls
- Not seeding `std::srand()`, leading to identical random sequences every run.
