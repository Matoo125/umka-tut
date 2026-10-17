# Exercise Temperature Converter (`09_temperature_converter.um`)

### 🎯 Objective
Convert temperatures between Celsius and Fahrenheit based on user selection.

### 🧠 Core Concepts
- Real arithmetic: `(c * 9.0 / 5.0) + 32.0` and `(f - 32.0) * 5.0 / 9.0`.
- Menu branch selection with integer / char switch.

### ⚖️ Umka vs Lua
- **Umka**: Division between integers truncates (`9 / 5 == 1`). Real literals (`9.0 / 5.0`) must be used for float math!
- **Lua**: In Lua 5.3+, `/` always performs float division (`9 / 5 == 1.8`).

### ⚠️ Common Pitfalls
- Writing `9 / 5` instead of `9.0 / 5.0` in Umka accidentally produces integer truncation to 1!
