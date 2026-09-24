#!/usr/bin/env bash
# Usage: prepare-review.sh <base-branch> <out-dir>
# Writes diff.patch, files.txt, tags.txt, rules.txt and summary.txt into <out-dir>.
# The diff is <base>...HEAD: everything committed on this branch since it left the base.
set -euo pipefail
base="${1:?usage: prepare-review.sh <base-branch> <out-dir>}"
out="${2:?usage: prepare-review.sh <base-branch> <out-dir>}"
here="$(cd "$(dirname "$0")" && pwd)"
root="$(git rev-parse --show-toplevel)"
cd "$root"
mkdir -p "$out/findings" "$out/verdicts"

if ! git rev-parse --verify -q "$base" >/dev/null; then
  echo "base branch '$base' not found. Try origin/$base or fetch first." >&2
  exit 2
fi

git diff "$base...HEAD" > "$out/diff.patch"
git diff --numstat "$base...HEAD" > "$out/files.txt"
python3 "$here/tags.py" "$out/files.txt" > "$out/tags.txt"

: > "$out/rules.txt"
for f in .cursor/rules/*.mdc CLAUDE.md AGENTS.md CONTEXT.md .cursorrules; do
  [ -e "$f" ] && echo "$f" >> "$out/rules.txt"
done

branch="$(git branch --show-current)"
[ -n "$branch" ] || branch="detached-$(git rev-parse --short HEAD)"

{
  echo "repo: $root"
  echo "branch: $branch"
  echo "base: $base"
  echo "files changed: $(wc -l < "$out/files.txt" | tr -d ' ')"
  echo "lines: +$(awk '{a+=$1} END{print a+0}' "$out/files.txt") -$(awk '{d+=$2} END{print d+0}' "$out/files.txt")"
  echo "tags: $(tr '\n' ' ' < "$out/tags.txt")"
  echo "rule files: $(tr '\n' ' ' < "$out/rules.txt")"
  echo "diff: $out/diff.patch"
  echo "files: $out/files.txt"
} > "$out/summary.txt"
cat "$out/summary.txt"

if [ ! -s "$out/diff.patch" ]; then
  echo "EMPTY DIFF: nothing to review between $base and HEAD" >&2
  exit 3
fi
