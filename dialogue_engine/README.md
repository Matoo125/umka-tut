# Dialogue Engine

This folder contains a more advanced dialogue engine than the single-file prototype in `11_dialogue.um`.

It supports:

- named node IDs
- named integer and string variables
- conditional choices
- per-node and per-choice effects
- text interpolation with `{variable_name}`
- save and resume from `dialogue_engine/savegame.txt`
- story validation for broken targets and malformed records

Structure:

- `main.um`: entrypoint
- `engine.um`: runtime loop, choice rendering, input handling
- `story.um`: shared types, state changes, branching helpers, and story-file loading
- `city_gate.story`: external story data

Run it with:

```bash
umka dialogue_engine/main.um
```

Validate or run a different story file:

```bash
umka dialogue_engine/main.um dialogue_engine/invalid_story.story
```

Example playthrough:

```bash
printf '1\n1\n2\n1\n1\n' | umka dialogue_engine/main.um
```

Save and resume:

- enter `0` at a choice prompt to save and exit
- the next run will offer to resume from `dialogue_engine/savegame.txt`

Test it with:

```bash
bash dialogue_engine/test_dialogue_engine.sh
```

Story format:

- `var:` defines a named integer variable and its initial value
- `var_str:` defines a named string variable and its initial value
- `node:` starts a node block using a named ID like `intro` or `ending_jail`
- `speaker:` and `text:` define what is shown
- `node_effect:` uses `name|set|value`, `name|add|value`, or `name|sub|value`
- `node_effect_str:` uses `name|set|value`
- `choice:` uses `text|targetNodeId`
- `choice_when:` uses `name|op|value` where `op` can be `==`, `!=`, `>=`, `<=`, `>`, `<`
- `choice_when_str:` uses `name|==|value` or `name|!=|value`
- `choice_effect:` uses the same format as `node_effect:`
- `choice_effect_str:` uses the same format as `node_effect_str:`
- `ending_text:` defines the ending message for ending nodes
- `endnode` closes the current node

Interpolation:

- `text: Your trust is {trust}.`
- `text: Welcome back, {player_name}.`
- `choice: Show pass ({pass}).|gate`
- `ending_text: Final trust: {trust}`

Tutorial:

- `TUTORIAL.md` explains how the engine was built step by step
