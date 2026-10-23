# Todo

Things found while writing the starters. None of them breaks an exercise today.

## Exercises whose check doesn't cover what they teach

- **13_todo_list**: the starter has a TODO for *delete*, but the exercise's input only
  adds and lists, so a learner can skip it and still pass. Add a delete to `input`, update
  `expected`, and the Lua port (`lua/13_todo_list.lua`) and its test to match.
- **25_json_parser**: the sample JSON has no negative number, so the sign handling is not
  checked (it was an endless loop until `main` was fixed here). Put a `-` number in the
  source text, update `expected`, the Lua port, and `docs/explanations/25_json_parser.md`.

## Output that is hardcoded or partial

- **43_gc_mark_sweep**: the sweep prints `(Cycle garbage)` for every dead object. That is
  true for 5 and 6 in this program, but not in general. Print something neutral
  (`(unreachable)`), or find out whether the object is on a cycle. Changes the expected
  output, the Lua port and the explanation.
- **49_register_vm**: `Final registers` prints only R0 to R3 of 16. Print all, or say "R0-R3".
  Changes the expected output and the Lua port.

## Behaviour that hides mistakes

- **47_bytecode_assembler**: `parseOpcode` maps an unknown mnemonic to `OP_HALT` silently.
  A misspelt instruction should be an error with its line number. The exercise's input is
  valid, so the output wouldn't change.

## Starters worth a second look

- **28_state_machine**: the TODO lists the five valid transitions, so the exercise is
  writing the `switch`, not finding the transitions. Fine for a first state machine; for a
  harder one, describe the behaviour and leave the table to the learner.
- **36_markdown_compiler**: the list-item TODO sits before the paragraph `else` branch and
  asks the learner to add an `else if` there. It works, but reads oddly. Restructure the
  solution so the branch has a natural place.

## The course itself

- **License**: there is none. Add one before the course is bundled or shared (the editor
  ships a copy; see `courses/` in the editor's repository).
- **Lua ports and `docs/explanations`** were not re-read after the starters were added:
  check that no explanation describes a function the starter now leaves empty.
- `umkalings` shows the task only through the file; `umkalings hint` shows `hint` from the
  manifest, which for a few exercises (01, 03) gives away the answer. Decide whether hints
  should be gentler.
