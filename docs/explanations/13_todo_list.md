# Exercise To-Do List (`13_todo_list.um`)

### 🎯 Objective
In-memory task manager supporting dynamic addition, completion toggling, deletion, and listing.

### 🧠 Core Concepts
- Structs: `type Task = struct { title: str, done: bool }`.
- Dynamic arrays: `tasks := make([]Task, 0)`.
- Built-ins: `append(tasks, newTask)` and `delete(tasks, index)`.

### ⚖️ Umka vs Lua
- **Umka**: Zero-indexed dynamic slices; `delete(arr, idx)` returns the updated slice.
- **Lua**: One-indexed tables; `table.remove(t, idx)` modifies in place.

### ⚠️ Common Pitfalls
- Reassigning the result of `append()` and `delete()` in Umka is mandatory (`tasks = append(tasks, t)`).
