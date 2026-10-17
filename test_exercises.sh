#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$ROOT_DIR"

if ! command -v umka >/dev/null 2>&1; then
    echo "umka is required to run the tests."
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

    actual="$(printf "%s" "$input" | umka "$file" "$@")"

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

    actual="$(printf "%s" "$input" | umka "$file")"

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

    actual="$(printf 'L\nR\nL\nS\n' | umka 04_timer.um)"

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

    if ! printf '%s\n' "$actual" | grep -Fq "Command: Reverse mode: ON"; then
        echo "FAIL: 04 timer flow"
        printf '%s\n' "$actual"
        exit 1
    fi

    if ! printf '%s\n' "$actual" | grep -Eq 'Command: Final time: -?[0-9]+\.[0-9]{3} seconds'; then
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
    "01_hello_world.um" \
    "" \
    "Hello Umka!"

run_exact_test \
    "02 fibonacci" \
    "02_fib.um" \
    "" \
    $'0\n1\n1\n2\n3\n5\n8\n13\n21\n34\n55'

run_exact_test \
    "03 add two numbers" \
    "03_add_two_numbers.um" \
    $'1\n2\n' \
    "Enter first number: Enter second number: Result: 3.000000"

run_timer_test

run_exact_test \
    "05 multiplication table" \
    "05_multiplication_table.um" \
    $'4\n' \
    $'Enter table size:    1   2   3   4\n   2   4   6   8\n   3   6   9  12\n   4   8  12  16'

run_exact_test \
    "06 table art valid" \
    "06_table_art.um" \
    $'5\n4\n' \
    $'Enter table width: Enter table height: +---+\n|   |\n|   |\n+---+'

run_exact_test \
    "06 table art invalid" \
    "06_table_art.um" \
    $'1\n4\n' \
    "Enter table width: Enter table height: Width and height must be at least 2."

run_exact_test \
    "07 factorial valid" \
    "07_factorial.um" \
    $'5\n' \
    "Enter a non-negative integer: 5! = 120"

run_exact_test \
    "07 factorial invalid" \
    "07_factorial.um" \
    $'-1\n' \
    "Enter a non-negative integer: Factorial is only defined for non-negative integers."

run_exact_test \
    "08 sum to n valid" \
    "08_sum_to_n.um" \
    $'10\n' \
    "Enter a positive integer: Sum from 1 to 10 = 55"

run_exact_test \
    "08 sum to n invalid" \
    "08_sum_to_n.um" \
    $'0\n' \
    "Enter a positive integer: The number must be positive."

run_exact_test \
    "09 temperature C to F" \
    "09_temperature_converter.um" \
    $'CtoF\n25\n' \
    "Choose conversion (CtoF or FtoC): Enter temperature value: Result: 77.00"

run_exact_test \
    "09 temperature F to C" \
    "09_temperature_converter.um" \
    $'FtoC\n32\n' \
    "Choose conversion (CtoF or FtoC): Enter temperature value: Result: 0.00"

run_exact_test \
    "09 temperature invalid" \
    "09_temperature_converter.um" \
    $'bad\n25\n' \
    "Choose conversion (CtoF or FtoC): Enter temperature value: Unknown conversion type."

run_exact_test \
    "10 countdown valid" \
    "10_countdown.um" \
    $'5\n' \
    $'Enter countdown start: 5\n4\n3\n2\n1\n0\nLift off!'

run_exact_test \
    "10 countdown invalid" \
    "10_countdown.um" \
    $'-1\n' \
    "Enter countdown start: Countdown start must be zero or greater."

run_regex_test \
    "11 dialogue warm welcome" \
    "11_dialogue.um" \
    $'1\n1\n1\n1\n1\n' \
    "Ending: You earned a warm welcome."

run_regex_test \
    "11 dialogue jail ending" \
    "11_dialogue.um" \
    $'2\n2\n1\n' \
    "Ending: Your journey stops at the city jail."

run_exact_test \
    "12 guessing game fixed target" \
    "12_guessing_game.um" \
    $'10\n60\n42\n' \
    $'Welcome to the Guessing Game!\nI\'m thinking of a number between 1 and 100.\nCan you guess it?\n\nEnter your guess: Too low! Try again.\nEnter your guess: Too high! Try again.\nEnter your guess: Correct! You guessed the number in 3 attempts.' \
    "42"

run_exact_test \
    "13 todo list add and list" \
    "13_todo_list.um" \
    $'1\nBuyMilk\n4\n0\n' \
    $'To-Do List Manager\nCommands: 1 = Add, 2 = Complete, 3 = Delete, 4 = List, 0 = Exit\nCommand: Task title: Added task 1: BuyMilk\nCommand: Tasks:\n1. [ ] BuyMilk\nCommand: Goodbye!'

run_regex_test \
    "14 word frequency counter" \
    "14_word_frequency.um" \
    "" \
    "Word counts \(9 unique words, 15 total\):"

run_exact_test \
    "15 rpn calculator valid" \
    "15_rpn_calculator.um" \
    $'5\n3\n4\n+\n2\n*\n' \
    "RPN Calculator
Enter number of tokens: Enter 5 tokens separated by whitespace:
Result: 14.0000"

run_exact_test \
    "15 rpn calculator div zero" \
    "15_rpn_calculator.um" \
    $'3\n4\n0\n/\n' \
    "RPN Calculator
Enter number of tokens: Enter 3 tokens separated by whitespace:
Evaluation error: invalid RPN expression."

run_exact_test \
    "16 interfaces shapes" \
    "16_interfaces_shapes.um" \
    "" \
    $'Shape Measurements:\nRectangle  -> Area:  20.00, Perimeter:  18.00\nCircle     -> Area:  28.27, Perimeter:  18.85'

run_exact_test \
    "17 type switch" \
    "17_type_switch.um" \
    "" \
    $'Inspecting Items via Type Switch:\nInteger: 100 (doubled = 200)\nReal: 45.50 (half = 22.75)\nString: "Umka Scripting" (length = 14)\nBoolean: true (negated = false)\nBoolean: false (negated = true)'

run_exact_test \
    "18 embedded interfaces" \
    "18_embedded_interfaces.um" \
    "" \
    $'--- Buffer Output ---\nINFO: System started\nINFO: Loading modules...\n[APP] Ready for user requests.\n---------------------'

run_exact_test \
    "19 fibers coroutines" \
    "19_fibers_coroutines.um" \
    "" \
    $'Fibonacci Sequence via Coroutine Fiber:\nFib[0] = 0\nFib[1] = 1\nFib[2] = 1\nFib[3] = 2\nFib[4] = 3\nFib[5] = 5\nFib[6] = 8\nFib[7] = 13\nFib[8] = 21\nFib[9] = 34\n\nSquares via Finite Coroutine Fiber:\nSquare #1 = 1\nSquare #2 = 4\nSquare #3 = 9\nSquare #4 = 16\nSquare #5 = 25\nGenerator completed.'

run_exact_test \
    "20 file io" \
    "20_file_io.um" \
    "" \
    $'Writing 79 bytes to notes.txt...\nReading back from notes.txt...\n--- File Content ---\nUmka Scripting Language\nFast, statically typed, embeddable\nEnjoying exercises!\nLine count: 3\nTemporary file cleaned up.'

run_exact_test \
    "21 vector matrix" \
    "21_vector_matrix.um" \
    "" \
    $'Vector Math:\nu: [1.00, 2.00, 3.00]\nv: [4.00, 5.00, 6.00]\nu + v: [5.00, 7.00, 9.00]\nu - v: [-3.00, -3.00, -3.00]\nu . v: 32.00\nu x v: [-3.00, 6.00, -3.00]\n|u|: 3.7417\n|v|: 8.7750\n\nMatrix Transformation:\nI * u: [1.00, 2.00, 3.00]'

run_exact_test \
    "22 functional programming" \
    "22_functional_programming.um" \
    "" \
    $'Input: [1 2 3 4 5 6 7 8 9 10]\nThreshold: > 5\nFiltered: [6 7 8 9 10]\nSquared: [36 49 64 81 100]\nTotal Sum of Squares: 330'

run_exact_test \
    "23 unicode utf8" \
    "23_unicode_utf8.um" \
    "" \
    $'Original Text: Hello, 世界! 🌍\nByte Length:   19\nRune Length:   12\n\nDecoded Code Points:\n[00] U+0048 | 1 bytes | Char: H\n[01] U+0065 | 1 bytes | Char: e\n[02] U+006C | 1 bytes | Char: l\n[03] U+006C | 1 bytes | Char: l\n[04] U+006F | 1 bytes | Char: o\n[05] U+002C | 1 bytes | Char: ,\n[06] U+0020 | 1 bytes | Char:  \n[07] U+4E16 | 3 bytes | Char: 世\n[08] U+754C | 3 bytes | Char: 界\n[09] U+0021 | 1 bytes | Char: !\n[10] U+0020 | 1 bytes | Char:  \n[11] U+1F30D | 4 bytes | Char: 🌍'

run_exact_test \
    "24 linked list weak ptrs" \
    "24_linked_list_weak_ptrs.um" \
    "" \
    $'Doubly Linked List with Weak Backlinks (Size = 4):\nForward:  [ 10 20 30 40 ]\nBackward: [ 40 30 20 10 ]'

run_exact_test \
    "25 json parser" \
    "25_json_parser.um" \
    "" \
    $'Parsed 4 JSON properties:\n  author     : "Vasiliy"\n  embedded   : true\n  lang       : "Umka"\n  version    : 1.60'

run_exact_test \
    "26 binary packet" \
    "26_binary_packet.um" \
    "" \
    $'Header Unpacked:\n  Magic:      0x554D4B41\n  Version:    1\n  Flags:      0x0003\n  PayloadLen: 4 bytes\n  Checksum:   0xC2BA81B6\n  Valid:      true'

run_exact_test \
    "27 event bus" \
    "27_event_bus.um" \
    "" \
    $'=== Dispatching Events ===\n[Auth Service] User logged in: alice\n[Audit Log] Event \'user:login\' triggered with payload: \'alice\'\n[Auth Service] User logged out: alice\n[Audit Log] Event \'user:logout\' triggered with payload: \'alice\''

run_exact_test \
    "28 state machine" \
    "28_state_machine.um" \
    "" \
    $'=== Finite State Machine Simulation ===\nInitial State: Idle\nTransition: Idle --(Connect)--> Connecting\nIgnored:    Connecting --(Connect)--> [Invalid in this state]\nTransition: Connecting --(Success)--> Connected\nTransition: Connected --(Disconnect)--> Disconnected\nTransition: Disconnected --(Reset)--> Idle'

run_exact_test \
    "29 min heap" \
    "29_min_heap.um" \
    "" \
    $'Pushing values into Min-Heap:\nPush 45\nPush 12\nPush 89\nPush 3\nPush 27\nPush 18\nPush 5\n\nPopping in sorted priority order:\nPop 3\nPop 5\nPop 12\nPop 18\nPop 27\nPop 45\nPop 89'

run_exact_test \
    "30 csv parser" \
    "30_csv_parser.um" \
    "" \
    $'CSV Table Loaded (3 columns, 4 rows)\n--- Engineering Staff ---\n- Alice (Salary: $95000)\n- Charlie (Salary: $105000)'

run_exact_test \
    "31 ast evaluator" \
    "31_ast_evaluator.um" \
    "" \
    $'Source Expression: 3 + 5 * ( 2 + 4 )\nAST Infix Tree:    (3 + (5 * (2 + 4)))\nEvaluated Result:  33.00'

run_exact_test \
    "32 trie prefix tree" \
    "32_trie_prefix_tree.um" \
    "" \
    $'Inserting words into Trie:\n  + apple\n  + app\n  + application\n  + apt\n  + banana\n  + bat\n\nMembership Queries:\n  contains("app") = true\n  contains("apple") = true\n  contains("appl") = false\n\nPrefix Search:\n  startsWith("ap") = true\n  startsWith("cat") = false\n\nAutocomplete for \'app\':\n  -> app\n  -> apple\n  -> application'

run_exact_test \
    "33 lru cache" \
    "33_lru_cache.um" \
    "" \
    $'=== LRU Cache Simulation (Capacity = 3) ===\nCache (size=3, cap=3): [ c:300 b:200 a:100 ]\nAccessing \'a\': 100\nCache (size=3, cap=3): [ a:100 c:300 b:200 ]\nInserting \'d\': 400 (triggers eviction)\nCache (size=3, cap=3): [ d:400 a:100 c:300 ]\nQuerying evicted \'b\': -1\nQuerying present \'c\': 300'

run_exact_test \
    "34 rle compressor" \
    "34_rle_compressor.um" \
    "" \
    $'=== Run-Length Encoding (RLE) Stream Compressor ===\nOriginal size:     17 bytes\nCompressed size:   8 bytes\nSpace saved:       52.9%\nCompressed stream: [ (5 x 0xAA) (3 x 0xBB) (8 x 0xCC) (1 x 0xDD) ]\nVerification:      PASS (Exact byte match)'

run_exact_test \
    "35 ring buffer" \
    "35_ring_buffer.um" \
    "" \
    $'=== Circular Ring Buffer (Capacity = 4) ===\nEnqueue 10, 20, 30:\nRingBuffer (size=3/4, head=0, tail=3): [ 10 20 30 ]\nDequeue one item: 10\nRingBuffer (size=2/4, head=1, tail=3): [ 20 30 ]\nEnqueue 40, 50 (wraps around):\nRingBuffer (size=4/4, head=1, tail=1): [ 20 30 40 50 ]\nAttempt overflow enqueue 60: rejected (buffer full)\nRingBuffer (size=4/4, head=1, tail=1): [ 20 30 40 50 ]\nDraining all items:\nPopped: 20\nPopped: 30\nPopped: 40\nPopped: 50\nRingBuffer (size=0/4, head=1, tail=1): [ ]'

run_exact_test \
    "36 markdown compiler" \
    "36_markdown_compiler.um" \
    "" \
    $'=== Markdown Source ===\n# Umka Language\nUmka is a **statically typed** embeddable scripting language.\n## Features\n- Clean Go-like syntax\n- Fast execution with `bytecode` VM\n- Built-in array and hash map collections\n> Simplicity is prerequisite for reliability.\n\n=== Compiled HTML Output ===\n<h1>Umka Language</h1>\n<p>Umka is a <strong>statically typed</strong> embeddable scripting language.</p>\n<h2>Features</h2>\n<ul>\n  <li>Clean Go-like syntax</li>\n  <li>Fast execution with <code>bytecode</code> VM</li>\n  <li>Built-in array and hash map collections</li>\n</ul>\n<blockquote>Simplicity is prerequisite for reliability.</blockquote>'

run_exact_test \
    "37 dijkstra graph" \
    "37_dijkstra_graph.um" \
    "" \
    $'=== Dijkstra\'s Shortest Path Algorithm ===\nShortest Path from A to D:\n  Route: A -> C -> B -> E -> D\n  Total Cost: 6\nShortest Path from C to E:\n  Route: C -> B -> E\n  Total Cost: 3'

run_exact_test \
    "38 stack vm" \
    "38_stack_vm.um" \
    "" \
    $'=== Stack-Based Bytecode VM ===\nRunning Program 1: (7 + 3) * 4 - 5\nResult: 35\nRunning Program 2: Triangular sum of 5\nResult: 15\nVM execution completed successfully.'

echo "All $pass_count tests passed."













