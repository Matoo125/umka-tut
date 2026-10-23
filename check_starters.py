#!/usr/bin/env python3
"""
check_starters: a starter is a real exercise only if it is not already solved.

For every exercise in exercises.json that has a "starter":
  - the starter says it is not done ("// I AM NOT DONE") and states a "Task:";
  - with that line removed it still compiles (the learner's first run is a
    wrong answer, not a syntax error they cannot yet read);
  - it FAILS the exercise's check (output mismatch or runtime error);
  - the exercise's solution (its "path") PASSES the same check.

Usage: ./check_starters.py            (umka must be on PATH)
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
    starter = ROOT / ex["starter"]
    if not starter.exists():
        return [f"{ex['starter']} does not exist"]
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
    solution = (ROOT / ex["path"]).read_text(encoding="utf-8").splitlines()
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
        trial = dict(ex, path=str(copy))
        ok, reason = umkalings.test_exercise(trial)
        if ok:
            problems.append("already passes: the starter must not be a solution")
        elif reason.startswith("Compilation failed"):
            problems.append("does not compile once the marker is removed:\n" + reason)

    ok, reason = umkalings.test_exercise(ex)
    if not ok:
        problems.append("the solution does not pass: " + reason.splitlines()[0])
    return problems


def main():
    umkalings.check_umka()
    exercises = [e for e in umkalings.load_exercises() if "starter" in e]
    bad = 0
    for ex in exercises:
        problems = check(ex)
        mark = "ok  " if not problems else "FAIL"
        print(f"{mark} {ex['id']}")
        for p in problems:
            print("       - " + p.replace("\n", "\n         "))
        bad += bool(problems)
    total = len(umkalings.load_exercises())
    print(f"\n{len(exercises) - bad}/{len(exercises)} starters ok ({len(exercises)} of {total} exercises have one)")
    return 1 if bad else 0


if __name__ == "__main__":
    sys.exit(main())
