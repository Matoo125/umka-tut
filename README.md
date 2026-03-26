# Umka Exercises

This repository contains 10 small [Umka](https://github.com/vtereshkov/umka-lang) exercises focused on basic language features such as output, input, loops, conditionals, recursion, and formatted printing.

## Requirements

- `umka` installed and available on `PATH`
- `bash` for running the test script

## Run an Exercise

Run any exercise directly with:

```bash
umka 01_hello_world.um
```

For exercises that expect input, pipe values into the program:

```bash
printf '5\n' | umka 07_factorial.um
printf '4\n' | umka 05_multiplication_table.um
```

## Run the Tests

The repository includes an automated test script for all exercises:

```bash
./test_exercises.sh
```

If the script is not executable in your environment, run:

```bash
bash test_exercises.sh
```

The test script checks exact output for deterministic exercises and uses pattern-based checks for the timer exercise, since elapsed time depends on runtime timing.

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

## Umka Documentation

- Main project: <https://github.com/vtereshkov/umka-lang>
- Language documentation: <https://github.com/vtereshkov/umka-lang/blob/master/doc/lang.md>
- Standard library documentation: <https://github.com/vtereshkov/umka-lang/blob/master/doc/lib.md>
- Playground: <https://vtereshkov.github.io/umka-lang>
