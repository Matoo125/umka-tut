#!/usr/bin/env python3
"""
check_starters: a starter is a real exercise only if it is not already solved.

For every exercise in exercises.json, its starter ("path", in exercises/):
  - says it is not done ("// I AM NOT DONE") and states a "Task:";
  - has a TODO, and differs from the solution ("solution", in solutions/)
    only at TODOs or in comments;
  - with the marker line removed still compiles (the learner's first run is a
    wrong answer, not a syntax error they cannot yet read);
  - FAILS the exercise's check (output mismatch or runtime error);
and the solution PASSES the same check.

Usage: ./check_starters.py [--strict] [ID_OR_NUMBER ...]   (umka must be on PATH)
  With ids (07, 14_word_frequency) only those are checked. A starter that does
  not exist yet is listed as "todo"; with --strict that is a failure too.
"""

import difflib
import importlib.machinery
import importlib.util
import json
import re
import sys
import tempfile
from pathlib import Path

sys.dont_write_bytecode = True  # importing umkalings must not leave a __pycache__ here
ROOT = Path(__file__).resolve().parent
loader = importlib.machinery.SourceFileLoader("umkalings", str(ROOT / "umkalings"))
spec = importlib.util.spec_from_loader("umkalings", loader)
umkalings = importlib.util.module_from_spec(spec)
loader.exec_module(umkalings)

MARKER = re.compile(r"^// I AM NOT DONE.*\n", re.M)


def check(ex):
    problems = []
    starter = ROOT / ex["path"]
    text = starter.read_text(encoding="utf-8")
    if not MARKER.search(text):
        problems.append("missing the '// I AM NOT DONE' line")
    if not re.search(r"^// Task:", text, re.M):
        problems.append("missing a '// Task:' line in the header")
    if "TODO" not in text:
        problems.append("no TODO to tell the learner where to work")

    # The starter is the solution with the work taken out: every difference
    # must be a TODO (with the stub that keeps it compiling), or comments (the
    # header's Task line and marker, notes for the learner). Changed code
    # anywhere else is drift between the two files.
    solution = (ROOT / ex["solution"]).read_text(encoding="utf-8").splitlines()
    starter_lines = text.splitlines()
    matcher = difflib.SequenceMatcher(None, solution, starter_lines, autojunk=False)
    for tag, i1, i2, j1, j2 in matcher.get_opcodes():
        if tag == "equal":
            continue
        mine = starter_lines[j1:j2]
        comments_only = all(not l.strip() or l.lstrip().startswith("//") for l in mine)
        if not comments_only and not any("TODO" in l for l in mine):
            problems.append(f"line {j1 + 1}: differs from the solution without a TODO:\n" + "\n".join("    " + l for l in mine[:4]))

    with tempfile.TemporaryDirectory() as tmp:
        copy = Path(tmp) / starter.name
        copy.write_text(MARKER.sub("", text, count=1), encoding="utf-8")
        ok, reason = umkalings.test_exercise(dict(ex, path=str(copy)))
        if ok:
            problems.append("already passes: the starter must not be a solution")
        elif reason.startswith("Compilation failed"):
            problems.append("does not compile once the marker is removed:\n" + reason)

    ok, reason = umkalings.test_exercise(dict(ex, path=ex["solution"]))
    if not ok:
        problems.append("the solution does not pass: " + reason.splitlines()[0])
    return problems


def main():
    umkalings.check_umka()
    args = sys.argv[1:]
    strict = "--strict" in args
    wanted = [a for a in args if not a.startswith("--")]
    everything = umkalings.load_exercises()
    exercises = [e for e in everything if not wanted or any(e["id"] == w or e["id"].startswith(w + "_") for w in wanted)]
    unknown = [w for w in wanted if not any(e["id"] == w or e["id"].startswith(w + "_") for e in everything)]
    for w in unknown:
        print(f"no exercise {w}")

    bad = missing = checked = 0
    for ex in exercises:
        if not (ROOT / ex["path"]).exists():
            missing += 1
            print(f"todo {ex['id']}")
            continue
        checked += 1
        problems = check(ex)
        print(f"{'ok  ' if not problems else 'FAIL'} {ex['id']}")
        for p in problems:
            print("       - " + p.replace("\n", "\n         "))
        bad += bool(problems)

    print(f"\n{checked - bad}/{checked} starters ok, {missing} still to write ({len(everything)} exercises)")
    return 1 if bad or unknown or (strict and missing) else 0


if __name__ == "__main__":
    sys.exit(main())
