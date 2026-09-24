---
name: duplicated-logic
family: Structure
tags: [any]
evidence: 23
---
# The same logic lives in two places

## Index line
The same non-trivial logic exists in two places, or a new helper re-implements one the repo already has.

## What to look for
- A block copied verbatim or near verbatim between two files, two branches, or two handlers in the diff.
- A new helper (validator, formatter, comparator, parser, padding, lookup) that repeats one in a shared package or another module. Search the repo by purpose and by the shape of the input, not by name.
- A schema, response contract, or list defined locally in two packages when a shared schemas package exists for it.
- Endpoint paths, timeouts, or a multi-step sequence copied into a second module instead of imported from the module that owns them.
- Two places derive the same key, id, or predicate with separate code, so they can drift or already differ.
- The same fallback or type narrowing repeated at several call sites instead of resolved once where the data enters.
- The same expression or wrapper element repeated several times in one component instead of one named value or one wrapper.
- A conditional that renders the same inner element in both branches; the element should appear once with the difference inside.
- A service or data-layer method that repeats an existing one under a new name or in a second layer.
- The same check written twice within one module for two inputs of the same shape.

## Why it matters
- Copies drift. The first bug fix lands in one copy and the other keeps the bug.
- Two derivations of one key or predicate that disagree fail silently: cache misses, filters that never match, validation that differs by path.
- Each copy is one more place a reader must check to know what the system does.

## What not to flag
- Two short pieces that look alike but encode different rules and will change for different reasons. Merging them couples what should stay apart.
- Similar shape, different domain, where one helper would need flags to serve both. That is a worse abstraction, not a fix.
- Short setup repeated in tests for readability, where a helper would hide what the test checks.
- A copy that exists to keep an architecture boundary and says so; judge it under dependency-direction.
- Repetition of two or three trivial tokens where extraction costs more than it saves.
- Duplication the diff neither adds nor touches.

## Severity
- must fix: the two copies already disagree, or a key, id, or validation can differ by path.
- should fix: a shared helper, schema, or primitive exists and the copy will drift from it.
- nit: a local repeat inside one component or one function.

## Remedies
- extract function or component
- import the shared helper
- move the schema to the shared package
- resolve once at the boundary and pass the result down
- hoist the expression to a named value

## Related
- single-source-of-truth: parallel hand-maintained maps, lists, copy, or fixtures that must stay in sync. Here it is logic or a schema declared twice.
- reinvented-library-feature: a raw element or hand-built primitive where the design system provides one.
- precedent-divergence: the case is wired in a different shape from its siblings without copying logic.
- wrong-home: the helper is not duplicated but sits in the wrong layer.
- magic-values: a lone literal without a name; here it is a copied set of them.

## Sources
- review threads: 23 accepted change requests from real code reviews
- code-reviewer skill: DRY; Fowler, Refactoring: duplicated code; A Philosophy of Software Design ch. 9 (repetition)
