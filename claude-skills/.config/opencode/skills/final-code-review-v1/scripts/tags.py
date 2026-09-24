#!/usr/bin/env python3
"""Print the stack tags a diff touches, one per line. Input: a `git diff --numstat` file.
Tags: api, web, db, schemas, shared-ui, tests, e2e, docs, ci, config, any."""
import re
import sys

RULES = [
    ("e2e", r"(^|/)e2e/|playwright|\.e2e\.|/deployed/"),
    ("tests", r"(^|/)__tests__/|\.test\.|\.spec\.|(^|/)tests?/|/harness/|/fixtures?/"),
    ("db", r"(^|/)migrations?/|(^|/)drizzle/|\.sql$|/seed"),
    ("schemas", r"(^|/)packages/schemas/|/schemas?/|/zod/"),
    ("shared-ui", r"(^|/)packages/ui/|/components/ui/"),
    ("docs", r"\.md$|(^|/)docs/|(^|/)adr/"),
    ("ci", r"\.gitlab-ci|(^|/)\.github/|Dockerfile|(^|/)docker/|(^|/)scripts/"),
    ("config", r"package\.json$|pnpm-(lock|workspace)|tsconfig|\.env|\.config\.[cm]?[jt]s$|turbo\.json|eslint|prettier"),
    ("web", r"(^|/)apps/web/|\.tsx$|/routes/|/components/|/hooks/"),
    ("api", r"(^|/)apps/api/|/routes\.ts$|/service\.ts$|/modules/|fastify|/plugins/"),
]

tags = {"any"}
for line in open(sys.argv[1]):
    parts = line.rstrip("\n").split("\t")
    if len(parts) < 3:
        continue
    path = parts[2]
    for tag, pattern in RULES:
        if re.search(pattern, path):
            tags.add(tag)
for tag in ["any"] + sorted(tags - {"any"}):
    print(tag)
