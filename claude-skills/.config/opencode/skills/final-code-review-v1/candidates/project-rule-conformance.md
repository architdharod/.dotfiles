---
name: project-rule-conformance
family: Process
tags: [any]
evidence: 13
---
# The diff breaks a rule the repo states in writing

## Index line
Read the repo's own rule files at run time and check the diff against every rule they state.

## What to look for
- Read every rule file before the diff: the cursor rules directory, CLAUDE.md, AGENTS.md, CONTEXT.md, CONTRIBUTING, and any lint or commit config that states a rule in words. Note each rule's scope (globs, layers, file types).
- For every rule, check each changed file it applies to. Quote the rule in the evidence of every finding.
- Language rules: comments, identifiers, file and component names, and user-facing text in the required language; abbreviations from another language used as domain vocabulary without a defined term.
- Lint suppression rules: a disable comment without the reason the rule requires; per-line disables where the rule wants file level, or the reverse.
- Declaration and layout rules: where helpers go in a file, function form, where hooks and contexts live, how components are structured.
- Casing and naming rules stated in writing: file names, columns, enum keys, route paths.
- MR title and commit message format when the rule states one and the MR text is part of the input.
- Rules about tools and commands: package manager, test runner, forbidden dependencies, migration workflow.
- Anything else the rule files say. This candidate has no fixed list; the rule files are the list.

## Why it matters
- Written rules are the team's agreed decisions. Breaking one silently reopens the decision for every reader.
- Mixed languages and ad hoc suppressions spread fast once one instance is merged.
- Some rules are merge gates (title format, lint), so a break blocks the pipeline later.

## What not to flag
- Conventions no rule file states and only precedent shows: precedent-divergence.
- Rules a linter or formatter enforces in CI, when the diff would fail CI anyway. Mention once, do not enumerate.
- Terms from an external system that the rule allows or the code defines at first use.
- Files outside the rule's own scope globs.
- Two rule files that contradict each other: report the contradiction once as a nit, do not enforce either side.
- Process rules outside the diff (branch naming, review steps) when the MR text is not part of the input.

## Severity
- must fix: the rule guards correctness or a merge gate, or user-facing text is in the wrong language.
- should fix: a stated code rule is broken in new code.
- nit: a rule about comment wording, ordering, or layout with no behavior cost.

## Remedies
- translate the text or rename the symbol
- add the reason to the suppression or remove it
- restructure to the stated layout
- rename to the stated casing
- retitle the MR

## Related
- precedent-divergence: the pattern is unwritten and shown by siblings.
- naming: names that mislead or collide, whatever the rules say.
- ci-config-and-dependencies: lint and typecheck exclusions in config, not suppressions in code.
- manual-memoization, data-model-and-migrations: they check the repo's rule on their own topic in depth; do not repeat their findings here.
- needless-or-transient-comments: the comment's content, not its language.

## Sources
- review threads: 13 accepted change requests from real code reviews
- code-reviewer skill: rule conformance
