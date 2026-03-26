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
    local actual

    actual="$(printf "%s" "$input" | umka "$file")"

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

echo "All $pass_count tests passed."
