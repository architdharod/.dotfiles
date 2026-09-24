---
name: together-or-apart
family: Design (books)
tags: [any]
evidence: 0
---
# Together or apart

## Index line
Related code split across modules, or unrelated code fused into one module because it was written together.

## What to look for
- Two functions or modules that cannot be understood or changed without reading each other: shared hidden state, a fixed call order, or parameters that exist only to carry values between them.
- Two modules that both encode the same assumption (a state layout, a step order, a data shape) and must change in lockstep.
- A split that complicates the interface: callers must call both halves in order, pass state between them, or coordinate them, where one call would do.
- A split whose pieces are not useful on their own; they only make sense called together in one sequence.
- A wrapper that calls fragments in order and nothing else, created by splitting a function for length alone.
- A new module or file that holds the MR's code because it is new, not because it is one concept: unrelated helpers grouped by time of writing.
- Unrelated code fused into one module with no shared knowledge and different reasons to change, so one part cannot be reused or tested without the other.
- One concern spread thinly across many files (an undo path, a permission rule, an audit trail), so a change touches all of them and no file owns the concept.
- A diff that touches many files to adjust one idea, which shows that the idea has no single home.

## Why it matters
- Knowledge split across modules makes every change a multi-file change, and one file always lags behind.
- Conjoined units double the reading cost and hide the invariant that ties them.
- Fused unrelated code cannot be reused, tested, or replaced separately, and grows toward the giant file.
- Splits whose pieces are not independently useful add interfaces without removing complexity.

## What not to flag
- A split along a real seam: each side is understandable alone, has its own reason to change, and the interface between them is small.
- Files that follow the project's established layout (route, service, repository) even when a feature crosses them.
- Long functions that do one thing completely. Length alone is oversized-units' concern, and splitting for length is not the goal.
- A generic helper separated from its special-purpose caller. That separation is the goal; mixing them is file-and-code-organization.
- A component kept next to its test, story, and styles by convention.
- The duplicate logic itself. That is duplicated-logic; here the finding is the boundary that produced it.
- Splits the diff did not create or worsen.

## Severity
- must fix: the diff creates a boundary that forces two modules to hold the same assumption with no single owner, in code many callers use.
- should fix: conjoined units; splits whose pieces are not independently useful; unrelated code fused into a new module by time of writing.
- nit: a small helper that could sit next to its only caller.

## Remedies
- merge the conjoined pieces into one unit
- move the shared knowledge into one owner and expose it through a small interface
- split along the concept, not along the MR
- inline the fragment that is not useful on its own
- separate the unrelated piece into its own module

## Related
- file-and-code-organization: generic mixed with specific in one file, entry points below helpers, scattered derivations.
- wrong-home: one piece in a layer it does not belong to.
- divergent-change: a module the history shows changing for unrelated reasons.
- information-leakage: a specific decision (a format, a protocol) known by more than one module.
- temporal-decomposition: a split that follows the order of events.
- duplicated-logic, single-source-of-truth, incomplete-propagation: symptoms of split knowledge; here the boundary itself.
- feature-envy: one function that lives on another module's data.
- strong-connascence: pieces that must agree on order or timing.

## Sources
- review threads: none (seed only)
- A Philosophy of Software Design, ch. 9: better together or better apart
