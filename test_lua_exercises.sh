#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$ROOT_DIR/lua"

if ! command -v lua >/dev/null 2>&1; then
    echo "lua is required to run the tests."
    exit 1
fi

pass_count=0

run_exact_test() {
    local name="$1"
    local file="$2"
    local input="$3"
    local expected="$4"
    shift 4 || true
    local actual

    actual="$(printf "%s" "$input" | lua "$file" "$@")"

    if [[ "$actual" != "$expected" ]]; then
        echo "FAIL: $name"
        echo "Expected:"
        printf '%s\n' "$expected"
        echo "Actual:"
        printf '%s\n' "$actual"
        exit 1
    fi

    echo "PASS: $name"
    pass_count=$((pass_count + 1))
}

run_regex_test() {
    local name="$1"
    local file="$2"
    local input="$3"
    local pattern="$4"
    local actual

    actual="$(printf "%s" "$input" | lua "$file")"

    if ! printf '%s\n' "$actual" | grep -Eq "$pattern"; then
        echo "FAIL: $name"
        echo "Expected pattern:"
        printf '%s\n' "$pattern"
        echo "Actual:"
        printf '%s\n' "$actual"
        exit 1
    fi

    echo "PASS: $name"
    pass_count=$((pass_count + 1))
}

run_timer_test() {
    local actual

    actual="$(printf 'L\nR\nL\nS\n' | lua 04_timer.lua)"

    if ! printf '%s\n' "$actual" | grep -Fq "Timer started!"; then
        echo "FAIL: 04 timer flow"
        printf '%s\n' "$actual"
        exit 1
    fi

    if ! printf '%s\n' "$actual" | grep -Fq "Press: L = lapse, R = reverse, S = stop"; then
        echo "FAIL: 04 timer flow"
        printf '%s\n' "$actual"
        exit 1
    fi

    if ! printf '%s\n' "$actual" | grep -Eq 'Command: Elapsed time: -?[0-9]+\.[0-9]{3} seconds'; then
        echo "FAIL: 04 timer flow"
        printf '%s\n' "$actual"
        exit 1
    fi

    if ! printf '%s\n' "$actual" | grep -Fq "Reverse mode: ON"; then
        echo "FAIL: 04 timer flow"
        printf '%s\n' "$actual"
        exit 1
    fi

    if ! printf '%s\n' "$actual" | grep -Eq 'Final time: -?[0-9]+\.[0-9]{3} seconds'; then
        echo "FAIL: 04 timer flow"
        printf '%s\n' "$actual"
        exit 1
    fi

    if ! printf '%s\n' "$actual" | grep -Fq "Timer stopped."; then
        echo "FAIL: 04 timer flow"
        printf '%s\n' "$actual"
        exit 1
    fi

    echo "PASS: 04 timer flow"
    pass_count=$((pass_count + 1))
}

run_exact_test \
    "01 hello world" \
    "01_hello_world.lua" \
    "" \
    "Hello Umka!"

run_exact_test \
    "02 fibonacci" \
    "02_fib.lua" \
    "" \
    $'0\n1\n1\n2\n3\n5\n8\n13\n21\n34\n55'

run_exact_test \
    "03 add two numbers" \
    "03_add_two_numbers.lua" \
    $'1\n2\n' \
    "Enter first number: Enter second number: Result: 3.000000"

run_timer_test

run_exact_test \
    "05 multiplication table" \
    "05_multiplication_table.lua" \
    $'4\n' \
    $'Enter table size:    1   2   3   4\n   2   4   6   8\n   3   6   9  12\n   4   8  12  16'

run_exact_test \
    "06 table art valid" \
    "06_table_art.lua" \
    $'5\n4\n' \
    $'Enter table width: Enter table height: +---+\n|   |\n|   |\n+---+'

run_exact_test \
    "06 table art invalid" \
    "06_table_art.lua" \
    $'1\n4\n' \
    "Enter table width: Enter table height: Width and height must be at least 2."

run_exact_test \
    "07 factorial valid" \
    "07_factorial.lua" \
    $'5\n' \
    "Enter a non-negative integer: 5! = 120"

run_exact_test \
    "07 factorial invalid" \
    "07_factorial.lua" \
    $'-1\n' \
    "Enter a non-negative integer: Factorial is only defined for non-negative integers."

run_exact_test \
    "08 sum to n valid" \
    "08_sum_to_n.lua" \
    $'10\n' \
    "Enter a positive integer: Sum from 1 to 10 = 55"

run_exact_test \
    "08 sum to n invalid" \
    "08_sum_to_n.lua" \
    $'0\n' \
    "Enter a positive integer: The number must be positive."

run_exact_test \
    "09 temperature C to F" \
    "09_temperature_converter.lua" \
    $'CtoF\n25\n' \
    "Choose conversion (CtoF or FtoC): Enter temperature value: Result: 77.00"

run_exact_test \
    "09 temperature F to C" \
    "09_temperature_converter.lua" \
    $'FtoC\n32\n' \
    "Choose conversion (CtoF or FtoC): Enter temperature value: Result: 0.00"

run_exact_test \
    "09 temperature invalid" \
    "09_temperature_converter.lua" \
    $'bad\n25\n' \
    "Choose conversion (CtoF or FtoC): Enter temperature value: Unknown conversion type."

run_exact_test \
    "10 countdown valid" \
    "10_countdown.lua" \
    $'5\n' \
    $'Enter countdown start: 5\n4\n3\n2\n1\n0\nLift off!'

run_exact_test \
    "10 countdown invalid" \
    "10_countdown.lua" \
    $'-1\n' \
    "Enter countdown start: Countdown start must be zero or greater."

run_regex_test \
    "11 dialogue warm welcome" \
    "11_dialogue.lua" \
    $'1\n1\n1\n1\n1\n' \
    "Ending: You earned a warm welcome."

run_regex_test \
    "11 dialogue jail ending" \
    "11_dialogue.lua" \
    $'2\n2\n1\n' \
    "Ending: Your journey stops at the city jail."

run_exact_test \
    "12 guessing game fixed target" \
    "12_guessing_game.lua" \
    $'10\n60\n42\n' \
    $'Welcome to the Guessing Game!\nI\'m thinking of a number between 1 and 100.\nCan you guess it?\n\nEnter your guess: Too low! Try again.\nEnter your guess: Too high! Try again.\nEnter your guess: Correct! You guessed the number in 3 attempts.' \
    "42"

run_exact_test \
    "13 todo list add and list" \
    "13_todo_list.lua" \
    $'1\nBuyMilk\n4\n0\n' \
    $'To-Do List Manager\nCommands: 1 = Add, 2 = Complete, 3 = Delete, 4 = List, 0 = Exit\nCommand: Task title: Added task 1: BuyMilk\nCommand: Tasks:\n1. [ ] BuyMilk\nCommand: Goodbye!'

run_regex_test \
    "14 word frequency counter" \
    "14_word_frequency.lua" \
    "" \
    "Word counts \(9 unique words, 15 total\):"

run_exact_test \
    "15 rpn calculator valid" \
    "15_rpn_calculator.lua" \
    $'5\n3\n4\n+\n2\n*\n' \
    "RPN Calculator
Enter number of tokens: Enter 5 tokens separated by whitespace:
Result: 14.0000"

run_exact_test \
    "15 rpn calculator div zero" \
    "15_rpn_calculator.lua" \
    $'3\n4\n0\n/\n' \
    "RPN Calculator
Enter number of tokens: Enter 3 tokens separated by whitespace:
Evaluation error: invalid RPN expression."

run_exact_test \
    "16 interfaces shapes" \
    "16_interfaces_shapes.lua" \
    "" \
    $'Shape Measurements:\nRectangle  -> Area:  20.00, Perimeter:  18.00\nCircle     -> Area:  28.27, Perimeter:  18.85'

run_exact_test \
    "17 type switch" \
    "17_type_switch.lua" \
    "" \
    $'Inspecting Items via Type Switch:\nInteger: 100 (doubled = 200)\nReal: 45.50 (half = 22.75)\nString: "Umka Scripting" (length = 14)\nBoolean: true (negated = false)\nBoolean: false (negated = true)'

run_exact_test \
    "18 embedded interfaces" \
    "18_embedded_interfaces.lua" \
    "" \
    $'--- Buffer Output ---\nINFO: System started\nINFO: Loading modules...\n[APP] Ready for user requests.\n---------------------'

run_exact_test \
    "19 fibers coroutines" \
    "19_fibers_coroutines.lua" \
    "" \
    $'Fibonacci Sequence via Coroutine Fiber:\nFib[0] = 0\nFib[1] = 1\nFib[2] = 1\nFib[3] = 2\nFib[4] = 3\nFib[5] = 5\nFib[6] = 8\nFib[7] = 13\nFib[8] = 21\nFib[9] = 34\n\nSquares via Finite Coroutine Fiber:\nSquare #1 = 1\nSquare #2 = 4\nSquare #3 = 9\nSquare #4 = 16\nSquare #5 = 25\nGenerator completed.'

run_exact_test \
    "20 file io" \
    "20_file_io.lua" \
    "" \
    $'Writing 79 bytes to notes.txt...\nReading back from notes.txt...\n--- File Content ---\nUmka Scripting Language\nFast, statically typed, embeddable\nEnjoying exercises!\nLine count: 3\nTemporary file cleaned up.'

run_exact_test \
    "21 vector matrix" \
    "21_vector_matrix.lua" \
    "" \
    $'Vector Math:\nu: [1.00, 2.00, 3.00]\nv: [4.00, 5.00, 6.00]\nu + v: [5.00, 7.00, 9.00]\nu - v: [-3.00, -3.00, -3.00]\nu . v: 32.00\nu x v: [-3.00, 6.00, -3.00]\n|u|: 3.7417\n|v|: 8.7750\n\nMatrix Transformation:\nI * u: [1.00, 2.00, 3.00]'

run_exact_test \
    "22 functional programming" \
    "22_functional_programming.lua" \
    "" \
    $'Input: [1 2 3 4 5 6 7 8 9 10]\nThreshold: > 5\nFiltered: [6 7 8 9 10]\nSquared: [36 49 64 81 100]\nTotal Sum of Squares: 330'

run_exact_test \
    "23 unicode utf8" \
    "23_unicode_utf8.lua" \
    "" \
    $'Original Text: Hello, 世界! 🌍\nByte Length:   19\nRune Length:   12\n\nDecoded Code Points:\n[00] U+0048 | 1 bytes | Char: H\n[01] U+0065 | 1 bytes | Char: e\n[02] U+006C | 1 bytes | Char: l\n[03] U+006C | 1 bytes | Char: l\n[04] U+006F | 1 bytes | Char: o\n[05] U+002C | 1 bytes | Char: ,\n[06] U+0020 | 1 bytes | Char:  \n[07] U+4E16 | 3 bytes | Char: 世\n[08] U+754C | 3 bytes | Char: 界\n[09] U+0021 | 1 bytes | Char: !\n[10] U+0020 | 1 bytes | Char:  \n[11] U+1F30D | 4 bytes | Char: 🌍'

run_exact_test \
    "24 linked list weak ptrs" \
    "24_linked_list_weak_ptrs.lua" \
    "" \
    $'Doubly Linked List with Weak Backlinks (Size = 4):\nForward:  [ 10 20 30 40 ]\nBackward: [ 40 30 20 10 ]'

run_exact_test \
    "25 json parser" \
    "25_json_parser.lua" \
    "" \
    $'Parsed 4 JSON properties:\n  author     : "Vasiliy"\n  embedded   : true\n  lang       : "Umka"\n  version    : 1.60'

echo "All $pass_count Lua tests passed."

