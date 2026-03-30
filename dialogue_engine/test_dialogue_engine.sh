#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

if ! command -v umka >/dev/null 2>&1; then
    echo "umka is required to run the dialogue engine tests."
    exit 1
fi

assert_contains() {
    local haystack="$1"
    local needle="$2"
    local name="$3"

    if ! printf '%s\n' "$haystack" | grep -Fq "$needle"; then
        echo "FAIL: $name"
        echo "Missing text: $needle"
        echo "Actual output:"
        printf '%s\n' "$haystack"
        exit 1
    fi
}

run_path_test() {
    local name="$1"
    local input="$2"
    shift 2
    local output

    output="$(printf '%s' "$input" | umka dialogue_engine/main.um)"
    for expected in "$@"; do
        assert_contains "$output" "$expected" "$name"
    done

    echo "PASS: $name"
}

run_path_test \
    "merchant pass ending" \
    $'1\n1\n2\n1\n1\n' \
    "Lena? I know that name. Your current trust is 2." \
    "Show the merchant pass." \
    "Steps into market: 1" \
    "player_name=Lena" \
    "Ending: You earned a warm welcome, Lena, with trust 3."

run_path_test \
    "rude jail ending" \
    $'2\n2\n1\n' \
    "Take a night in the cell." \
    "Ending: Your journey stops at the city jail, Unknown."

run_path_test \
    "peaceful exit ending" \
    $'1\n2\n1\n' \
    "No name, no entry." \
    "Ending: You leave the gate behind and try elsewhere, Stranger."

rm -f dialogue_engine/savegame.txt

save_output="$(printf '1\n0\n' | umka dialogue_engine/main.um)"
assert_contains "$save_output" "Game saved to dialogue_engine/savegame.txt" "save flow"

resume_output="$(printf '1\n1\n2\n1\n1\n' | umka dialogue_engine/main.um)"
assert_contains "$resume_output" "Saved game found." "resume flow"
assert_contains "$resume_output" "Then state your name." "resume flow"
assert_contains "$resume_output" "Ending: You earned a warm welcome, Lena, with trust 3." "resume flow"

if [[ -f dialogue_engine/savegame.txt ]]; then
    echo "FAIL: resume flow"
    echo "Save file should be cleared after reaching an ending."
    exit 1
fi

echo "PASS: save and resume flow"

invalid_output="$(umka dialogue_engine/main.um dialogue_engine/invalid_story.story)"
assert_contains "$invalid_output" "Story validation failed: Choice on node intro targets missing node: missing_node" "invalid story validation"

echo "PASS: invalid story validation"

echo "All dialogue engine tests passed."
