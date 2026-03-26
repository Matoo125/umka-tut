# Dialogue Engine Tutorial

This tutorial explains how the dialogue engine in this repository was built, step by step, so the same result can be recreated from scratch.

The current engine lives in:

- `dialogue_engine/main.um`
- `dialogue_engine/engine.um`
- `dialogue_engine/story.um`
- `dialogue_engine/city_gate.story`
- `dialogue_engine/test_dialogue_engine.sh`

It is a terminal-based branching dialogue engine with:

- story nodes
- numbered choices
- named integer variables
- conditional choices
- per-node effects
- per-choice effects
- ending nodes loaded from a story file

## 1. Start With a Single-File Prototype

The first version was a single Umka file with:

- hardcoded node IDs
- hardcoded dialogue text
- direct `if` / `else if` branching
- two built-in state fields: `trust` and `hasPass`

That version still exists as:

- `11_dialogue.um`

This stage is useful because it proves the core loop:

1. show current dialogue
2. display choices
3. read player input
4. update state
5. jump to the next node

Without that prototype, it is too easy to overdesign the engine before the basic interaction works.

## 2. Split Runtime From Story Logic

The next step was to stop keeping everything in one file.

We introduced a dedicated engine folder and separated:

- runtime behavior in `engine.um`
- story structures and helpers in `story.um`
- entrypoint in `main.um`

This separation matters because the runtime loop should not care about specific story text.

At this point, the engine still had story data defined inside Umka code, but the responsibilities were cleaner:

- the engine handled display and input
- the story layer handled nodes, choices, and state transitions

## 3. Move Story Content Into a Data File

Hardcoded dialogue becomes painful quickly. The next real improvement was moving story content out of Umka code into:

- `dialogue_engine/city_gate.story`

That required adding a parser.

Because Umka in this environment does not provide high-level helpers like `split()` or substring slicing, the parser was written manually using:

- file reads via `std::fopen()` and `std::freadall()`
- manual line splitting
- manual field splitting on `|`
- `std::atoi()` for numeric parsing

The first story file format was intentionally simple and line-oriented:

```text
title: City Gate
node: 1
speaker: Guard
text: Halt. Why are you here?
choice: I'm a traveler.|2|1|0|-99|99|false|false
endnode
```

This was enough to prove that:

- the engine could load external content
- branching no longer needed to be compiled into the program
- story iteration could happen by editing data instead of code

## 4. Replace Fixed State With Named Variables

The early engine used fixed fields:

- `trust`
- `hasPass`

That works for one scenario, but it does not scale.

To make the engine reusable, state was generalized into named variables:

```um
type Variable = struct {
    name: str
    value: int32
}

type State = struct {
    varCount: int32
    vars: [maxVars]Variable
}
```

This allowed story logic to operate on arbitrary variables instead of a built-in schema.

In the current story, the variables are:

```text
var: trust|0
var: pass|0
var: market_seen|0
```

The runtime now prints all variables as debug state:

```text
[trust=3, pass=1, market_seen=1]
```

That is useful while authoring stories because it makes transitions visible.

## 5. Add Effects

Once state became generic, hardcoded updates like:

- `trust += 1`
- `hasPass = true`

had to be replaced with a data-driven effect system.

The engine now supports:

- `set`
- `add`
- `sub`

represented by:

```um
type Effect = struct {
    name: str
    op: str
    value: int32
}
```

Effects can be attached to:

- nodes via `node_effect:`
- choices via `choice_effect:`

Examples:

```text
node_effect: market_seen|set|1
choice_effect: trust|add|1
choice_effect: pass|set|1
```

This is a major step because the story file now controls state transitions directly.

## 6. Add Conditions

Showing every choice all the time is not enough for a dialogue engine. We added conditional choices using named variables and comparison operators.

Conditions are represented by:

```um
type Condition = struct {
    name: str
    op: str
    value: int32
}
```

Supported operators are:

- `==`
- `!=`
- `>=`
- `<=`
- `>`
- `<`

Story format example:

```text
choice: Show the merchant pass.|6
choice_when: pass|==|1
choice_effect: trust|add|1
```

Another example:

```text
choice: Ask for entry without papers.|6
choice_when: trust|>=|2
choice_when: pass|==|0
```

The engine evaluates all `choice_when:` lines attached to a choice. If any condition fails, the choice is hidden.

## 7. Add Explicit Ending Nodes

Earlier versions derived endings from hardcoded state rules in code. That made the engine less reusable.

The current version models endings directly in the story file:

```text
node: 9
ending
ending_text: You earned a warm welcome.
endnode
```

This is cleaner because:

- the story file owns its own endings
- different stories can define completely different conclusions
- the engine no longer needs special case ending logic beyond “if this node is an ending, print its text”

## 8. Keep The Runtime Loop Small

The core loop in `engine.um` is intentionally compact:

1. load the story
2. start at `nodeIntro`
3. apply node effects
4. print state
5. render visible choices
6. read input
7. apply choice effects
8. jump to the next node

The goal is for `engine.um` to stay generic while `story.um` and `.story` files carry the authoring complexity.

That is the right direction for maintainability.

## 9. Add Tests Early

Once story content moved to a file, regressions became easier to introduce. A small shell test harness was added:

- `dialogue_engine/test_dialogue_engine.sh`

It runs scripted playthroughs and verifies expected output snippets.

Current test coverage includes:

- positive merchant-pass path
- rude jail path
- peaceful exit path

This is intentionally lightweight, but it is enough to keep refactors safe.

Run it with:

```bash
bash dialogue_engine/test_dialogue_engine.sh
```

## 10. Current Story File Format

The current format supports:

- `title:`
- `underline:`
- `var: name|value`
- `node: id`
- `speaker:`
- `text:`
- `node_effect: name|op|value`
- `choice: text|target`
- `choice_when: name|op|value`
- `choice_effect: name|op|value`
- `ending`
- `ending_text:`
- `endnode`

Example:

```text
node: 4
speaker: Guard
text: Lena? I know that name. What is your business in the city?
choice: Trade.|6
choice: Ask for entry without papers.|6
choice_when: trust|>=|2
choice_when: pass|==|0
choice: Show the merchant pass.|6
choice_when: pass|==|1
choice_effect: trust|add|1
choice: Admit you have no papers.|5
choice_when: pass|==|0
choice_when: trust|<=|1
choice_effect: trust|sub|1
endnode
```

`choice_when:` and `choice_effect:` apply to the most recently declared `choice:`.

## 11. How To Run The Engine

Run the story:

```bash
umka dialogue_engine/main.um
```

Run a scripted path:

```bash
printf '1\n1\n2\n1\n1\n' | umka dialogue_engine/main.um
```

Run tests:

```bash
bash dialogue_engine/test_dialogue_engine.sh
```

## 12. What To Improve Next

The strongest next improvements are:

1. named node IDs instead of numeric IDs
2. save/load support for current node and variable state
3. text interpolation like `Hello, {player_name}`
4. story validation for bad targets and malformed records
5. reusable macros or shared effects

If you want to continue from this point, named node IDs are the best next step because they improve story authoring immediately without changing the engine’s overall shape.
