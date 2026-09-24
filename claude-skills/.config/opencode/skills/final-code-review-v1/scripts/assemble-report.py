#!/usr/bin/env python3
"""Build the report skeleton from confirmed verdicts.
Usage: assemble-report.py <verdicts-dir> <branch> <base> <candidates-run> <candidates-total> "<skipped ids or none>" <out.md>
The orchestrator then rewrites the wording with the humanizer skill, keeping every fact."""
import glob
import json
import os
import sys

vdir, branch, base, run, total, skipped, out = sys.argv[1:8]
ORDER = ["must-fix", "should-fix", "nit"]
TITLE = {"must-fix": "Must fix", "should-fix": "Should fix", "nit": "Nits"}

confirmed = []
unreadable = 0
for f in sorted(glob.glob(os.path.join(vdir, "*.json"))):
    try:
        v = json.load(open(f))
    except Exception as e:
        print(f"skip {f}: {e}", file=sys.stderr)
        unreadable += 1
        continue
    if not isinstance(v, dict):
        print(f"skip {f}: not a JSON object", file=sys.stderr)
        unreadable += 1
        continue
    if v.get("verdict") == "confirmed":
        if v.get("severity") not in ORDER:
            v["severity"] = "should-fix"
        confirmed.append(v)

counts = {s: sum(1 for v in confirmed if v["severity"] == s) for s in ORDER}
lines = [f"# Review: {branch} vs {base}", ""]
if not confirmed:
    lines.append(f"No issues found. Candidates run: {run} of {total}.")
else:
    lines.append(f"{counts['must-fix']} must fix, {counts['should-fix']} should fix, {counts['nit']} nits. Candidates run: {run} of {total}. Skipped: {skipped}.")
if unreadable:
    lines.append(f"Warning: {unreadable} verdict file(s) could not be read. Rerun those verifiers before trusting this report.")
    print(f"WARNING: {unreadable} unreadable verdict file(s)", file=sys.stderr)
for s in ORDER:
    group = sorted((v for v in confirmed if v["severity"] == s), key=lambda v: (v.get("file", ""), int(v.get("start_line") or 0)))
    if not group:
        continue
    lines += ["", f"## {TITLE[s]}"]
    for v in group:
        a, b = int(v.get("start_line") or 0), int(v.get("end_line") or 0)
        loc = f"{v.get('file','')}:{a}" + (f"-{b}" if b and b != a else "")
        lines += ["", f"### `{loc}`", "", f"**Problem:** {v.get('what_is_wrong', '').strip()}"]
        why = (v.get("why_it_matters") or v.get("reason") or "").strip()
        if why:
            lines += ["", f"**Why it matters:** {why}"]
        if (v.get("evidence") or "").strip():
            lines += ["", f"**Evidence:** {v['evidence'].strip()}"]
        if (v.get("snippet") or "").strip():
            ext = os.path.splitext(v.get("file", ""))[1].lstrip(".")
            lines += ["", f"```{ext}", v["snippet"].rstrip(), "```"]
        lines += ["", f"**Fix:** {v.get('what_to_do', '').strip()}", "", f"(candidate: {', '.join(v.get('candidates') or [])})"]
open(out, "w").write("\n".join(lines) + "\n")
print("\n".join(lines))
print(f"\nsaved: {out}", file=sys.stderr)
