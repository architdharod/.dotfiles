---
name: oversized-units
family: Structure
tags: [any]
evidence: 0 accepted ePort threads
---
# Functions and files that outgrow their shape

## Index line
A function or file grows past a healthy size while a clean split into smaller units is available.

## What to look for
- The diff pushes a file from under about 1000 lines to over. Count the whole file after the change, not the added lines.
- The diff adds a large block to a file already past that size instead of starting a new module.
- The diff adds a function longer than one screen, or extends an existing one past that.
- A function body with several sections set apart by blank lines or step comments. Each section is a unit waiting to be named.
- Comment headers inside one function that name the stages it runs through.
- A function with many local variables that live across the whole body.
- A component that renders several distinct regions, holds many pieces of state, and defines many handlers in one body.
- New code that could be its own module with a small interface, appended to an existing file because the caller lives there.
- A hook or helper that keeps growing because every new case looks small next to what is already there.

## Why it matters
- A reader must hold the whole unit in their head to change one part of it safely.
- Big units attract more code. Each addition looks small in context, and the unit never shrinks.
- Tests for a big unit must set up everything it touches, so they get slow, brittle, or skipped.
- Many changes landing in one file means more merge conflicts.

## What not to flag
- Generated files, snapshots, fixtures, lockfiles, migrations, and data tables. Size is not a design choice there.
- A long file that is a flat list of similar, independent entries, where a split would only scatter them.
- A long function that is one straight-line sequence with no branching and no reuse, when a split would produce helpers with one caller and long parameter lists.
- A file already over the threshold when the diff touches only a few lines in it. Do not block a small change on a refactor it did not cause.
- A test file whose length comes from many small, independent cases.
- One large function that implements one algorithm, where the pieces share many intermediate values and none has meaning on its own.
- A size limit the repo's own rule files state. That limit wins over the rough threshold here.

## Severity
- must fix: the diff pushes a file past about 1000 lines, or adds a large block to a file already past it, and a clear split exists.
- should fix: the diff adds a function longer than a screen with distinct stages that could each be named.
- nit: a unit is somewhat long but reads straight through, or the split would gain little.

## Remedies
- extract function
- extract module or file
- extract subcomponent
- extract hook
- move the new code to its own module behind a small interface

## Related
- file-and-code-organization: a file that mixes concerns, even a short one. Size alone is this candidate.
- convoluted-control-flow: deep branching inside a unit. Length is this candidate.
- shallow-abstractions: a split that produces thin pass-through helpers trades this problem for that one.
- divergent-change: a file that grows because it serves unrelated reasons. This candidate measures size, not reasons.
- data-clumps-and-long-parameter-lists: long parameter lists.
- project-rule-conformance: size limits the repo states itself.

## Sources
- ePort: none
- thermo-nuclear-code-quality-review skill (1k-line rule); Fowler, Refactoring (long function, large class)
