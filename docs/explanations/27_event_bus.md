# Exercise Event Bus & Pub-Sub Dispatcher (`27_event_bus.um`)

### 🎯 Objective
Implement a decoupled publish-subscribe event broker storing callback function pointers.

### 🧠 Core Concepts
- First-class function types: `type EventHandler = fn(event: str, data: str)`.
- Event registry: `map[str][]EventHandler`.
- Dynamic registration (`.on()`) and fan-out dispatch (`.emit()`).

### ⚖️ Umka vs Lua
- **Umka**: Strongly typed function pointers ensure callbacks conform to the exact parameter signature.
- **Lua**: Functions are first-class values stored directly in table lists.

### ⚠️ Common Pitfalls
- Emitting an event that has zero subscribers must safely do nothing rather than crashing on missing keys.
