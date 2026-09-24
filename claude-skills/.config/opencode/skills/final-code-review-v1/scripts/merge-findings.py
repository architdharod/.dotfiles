#!/usr/bin/env python3
"""Merge the helpers' findings. Usage: merge-findings.py <findings-dir> <out.json>
Findings on the same file with overlapping or adjacent lines (within 3) become one entry.
Prints one line per merged finding and a total."""
import glob
import json
import os
import sys

src, out = sys.argv[1], sys.argv[2]
SEV = {"must-fix": 0, "should-fix": 1, "nit": 2}
CONF = {"high": 0, "medium": 1, "low": 2}

items = []
for f in sorted(glob.glob(os.path.join(src, "*.json"))):
    try:
        data = json.load(open(f))
    except Exception as e:
        print(f"skip {f}: {e}", file=sys.stderr)
        continue
    if not isinstance(data, list):
        print(f"skip {f}: not a JSON array (a helper wrote the wrong shape); rerun that candidate", file=sys.stderr)
        continue
    for d in data:
        if not d.get("file"):
            continue
        d.setdefault("candidate", os.path.basename(f)[:-5])
        d["start_line"] = int(d.get("start_line") or 0)
        d["end_line"] = int(d.get("end_line") or d["start_line"])
        items.append(d)

items.sort(key=lambda d: (d["file"], d["start_line"]))
merged = []
for d in items:
    m = merged[-1] if merged else None
    if m and m["file"] == d["file"] and d["start_line"] <= m["end_line"] + 3:
        m["end_line"] = max(m["end_line"], d["end_line"])
        if d["candidate"] not in m["candidates"]:
            m["candidates"].append(d["candidate"])
        m["claims"].append({"candidate": d["candidate"], "claim": d.get("claim", ""), "evidence": d.get("evidence", ""), "fix": d.get("fix", "")})
        if SEV.get(d.get("severity_hint"), 3) < SEV.get(m["severity_hint"], 3):
            m["severity_hint"] = d["severity_hint"]
        if CONF.get(d.get("confidence"), 3) < CONF.get(m["confidence"], 3):
            m["confidence"] = d["confidence"]
    else:
        merged.append({
            "id": f"F{len(merged) + 1}",
            "file": d["file"],
            "start_line": d["start_line"],
            "end_line": d["end_line"],
            "candidates": [d["candidate"]],
            "severity_hint": d.get("severity_hint", "should-fix"),
            "confidence": d.get("confidence", "medium"),
            "claims": [{"candidate": d["candidate"], "claim": d.get("claim", ""), "evidence": d.get("evidence", ""), "fix": d.get("fix", "")}],
        })

json.dump(merged, open(out, "w"), indent=1)
for m in merged:
    print(f"{m['id']} {m['file']}:{m['start_line']}-{m['end_line']} [{m['severity_hint']}, {m['confidence']}] {', '.join(m['candidates'])}")
print(f"{len(items)} raw findings -> {len(merged)} merged -> {out}")
