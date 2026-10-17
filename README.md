# Umka Exercises

This repository contains 36 small [Umka](https://github.com/vtereshkov/umka-lang) exercises covering core language constructs, structs, dynamic arrays, maps, interfaces, type switches, coroutine fibers, standard library file I/O, linear algebra (`mat.um`), functional programming (`fnc.um`), Unicode decoding (`utf8.um`), heap/weak pointers, recursive-descent lexers/parsers, binary packet serialization/checksums, publish/subscribe event dispatchers, finite state machines (FSM), binary min-heaps, CSV tabular parsers, AST evaluators, prefix tries, LRU caches, lossless RLE compressors, circular ring buffers, and Markdown-to-HTML compilers.

## Requirements

- `umka` installed and available on `PATH`
- `bash` for running the test script

## Interactive Mode (`umkalings`)

Inspired by `rustlings`, this repository includes an interactive runner with automatic watch mode, verification progress bars, and exercise hints:

```bash
# Continuous watch mode: tests exercises as you save edits
./umkalings watch

# Verify all exercises and see progress
./umkalings verify

# Run and test a single exercise
./umkalings run 13_todo_list

# Display a hint for an exercise
./umkalings hint 14_word_frequency

# Show complete deep-dive architectural explanation
./umkalings explain 32_trie_prefix_tree

# List all exercises with status
./umkalings list
```

## Run an Exercise Manually

Run any exercise directly with:

```bash
umka 01_hello_world.um
```

For exercises that expect input, pipe values into the program:

```bash
printf '5\n' | umka 07_factorial.um
printf '4\n' | umka 05_multiplication_table.um
printf '10\n60\n42\n' | umka 12_guessing_game.um 42
```

## Run the Test Scripts

You can also run the automated bash test scripts:

```bash
# Test Umka exercises (all 36 exercises)
./test_exercises.sh

# Test Lua reimplementations (all 36 exercises in lua/)
./test_lua_exercises.sh
```

If the scripts are not executable in your environment, run:

```bash
bash test_exercises.sh
bash test_lua_exercises.sh
```

The test script checks exact output for deterministic exercises and uses pattern-based checks for the timer and dialogue exercises.

## Exercises

| File | Exercise | What it practices |
| --- | --- | --- |
| `01_hello_world.um` | Hello World | Basic program structure and printing text |
| `02_fib.um` | Fibonacci | Recursion and integer output |
| `03_add_two_numbers.um` | Add Two Numbers | Reading user input and numeric addition |
| `04_timer.um` | Timer | Input loop, conditionals, and standard library clock usage |
| `05_multiplication_table.um` | Multiplication Table | Nested loops and formatted output |
| `06_table_art.um` | Table Art | Drawing text shapes and validating input |
| `07_factorial.um` | Factorial | Loops, multiplication, and error handling |
| `08_sum_to_n.um` | Sum to N | Accumulation with loops and input validation |
| `09_temperature_converter.um` | Temperature Converter | Branching and real-number calculations |
| `10_countdown.um` | Countdown | Reverse loops and simple control flow |
| `11_dialogue.um` | Dialogue Tree | Multi-node branching state machine and dialogue flow |
| `12_guessing_game.um` | Guessing Game | Random numbers (`std::rand`), loops, and command line arguments |
| `13_todo_list.um` | To-Do List | Dynamic arrays, structs, `append()`, `delete()`, and task management |
| `14_word_frequency.um` | Word Frequency Counter | Hash maps (`map[str]int`), `validkey()`, and `keys()` |
| `15_rpn_calculator.um` | RPN Calculator | Custom stack data structures, receiver methods, and token parsing |
| `16_interfaces_shapes.um` | Polymorphic Shapes Interface | Interfaces, method sets, dynamic dispatch, and interface polymorphism |
| `17_type_switch.um` | Type Switch and Any | `any` (`interface{}`), `switch v := type(x)`, and runtime type recovery |
| `18_embedded_interfaces.um` | Embedded Interfaces | Interface composition/embedding (`Reader`, `Writer`, `ReadWriter`) |
| `19_fibers_coroutines.um` | Fibers & Coroutines | Cooperative multitasking, `make(fiber, fn)`, `resume()`, and lifecycle |
| `20_file_io.um` | File I/O & Content Processing | `std::fopen`, `std::fwrite`, `std::freadall`, and error checking |
| `21_vector_matrix.um` | 3D Vector & Matrix Math | Standard module `mat.um`, dot/cross products, norms, and transforms |
| `22_functional_programming.um` | Functional Programming | Standard module `fnc.um`, closures, lambda capture, `transform`, `filter`, `reduce` |
| `23_unicode_utf8.um` | Unicode & UTF-8 Decoding | Standard module `utf8.um`, runes, byte vs character length, code points |
| `24_linked_list_weak_ptrs.um` | Linked Lists & Weak Pointers | Heap allocation (`new()`), pointers (`^Node`), and breaking cycles (`weak ^Node`) |
| `25_json_parser.um` | JSON Lexer & Parser | Recursive-descent parsing, tokenization, tagged unions, and JSON AST representation |
| `26_binary_packet.um` | Binary Packet Header | Byte arrays (`[]uint8`), bit shifts (`<<`, `>>`), endianness, and checksum integrity |
| `27_event_bus.um` | Event Bus & Pub-Sub | Function types (`fn(event, data)`), callback slices, event registries, and decoupled dispatching |
| `28_state_machine.um` | Finite State Machine (FSM) | Enums (`State`, `Event`), deterministic transitions, validation logic, and action handlers |
| `29_min_heap.um` | Priority Queue / Min-Heap | Binary heap indexing `(i-1)/2`, sift-up, sift-down, logarithmic priority queue operations |
| `30_csv_parser.um` | CSV Parser & Filter | Delimiter parsing, quote escapement, 2D tabular representation, and column filtering |
| `31_ast_evaluator.um` | Expression Parser & AST | Recursive-descent operator precedence, heap AST trees (`^Node`), and recursive evaluation |
| `32_trie_prefix_tree.um` | Trie & Autocomplete | Prefix trees, 26-way child pointers (`[26]^TrieNode`), and recursive word collection |
| `33_lru_cache.um` | LRU Cache | Dual-structure map + doubly linked list, weak back-pointers, O(1) eviction |
| `34_rle_compressor.um` | RLE Byte Compressor | Byte buffers (`[]uint8`), run scanning, chunk limits, lossless decompression |
| `35_ring_buffer.um` | Circular Ring Buffer | Fixed-capacity queue, modular arithmetic `(i+1)%cap`, overflow rejection |
| `36_markdown_compiler.um` | Markdown Compiler | Two-pass block/inline parsing, list grouping state machine, HTML emission |

## Umka Documentation













- Main project: <https://github.com/vtereshkov/umka-lang>
- Language documentation: <https://github.com/vtereshkov/umka-lang/blob/master/doc/lang.md>
- Standard library documentation: <https://github.com/vtereshkov/umka-lang/blob/master/doc/lib.md>
- Playground: <https://vtereshkov.github.io/umka-lang>
