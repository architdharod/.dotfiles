---
name: information-leakage
family: Design (books)
tags: [any]
evidence: 0
---
# Information leakage

## Index line
A format, layout, protocol, or ordering decision known by several modules, so one change touches all of them.

## What to look for
- The diff changes a format, encoding, key scheme, ordering, or wire shape and has to edit more than one module to do it. That spread is the leak. Report it even when the diff got every site.
- A module parses, splits, or reassembles a string, key, path, or id that another module built, so both know the layout.
- A writer and a reader of one storage layout, file format, message, or cache entry sit in different modules with no shared definition between them.
- A second module rebuilds a composite value (a key, a path, a header) from its parts instead of asking the owning module for it.
- A consumer depends on the order, grouping, or size of a collection another module produces, with no interface that promises it.
- An interface exposes an internal representation: a raw row, a storage key, an internal enum, a third party's status code. Every caller then has to know it.
- Two modules hold matching assumptions about a third party's protocol (paging, error shape, limits, auth) instead of one client module owning them.
- An interface is wider than its callers need, so callers must understand internals they never use.
- A test in another module asserts the internal format of a value it should treat as opaque.

## Why it matters
- Every change to the decision needs synchronized edits in each module that knows it. A missed one is a silent incompatibility.
- A reader must understand one module's internals to work on its neighbour, which raises the cost of every change nearby.
- Leaked details make modules shallow: more interface to learn, less hidden behind it.

## What not to flag
- Two modules that both import the decision from one owner: a shared schema, a key builder, a parser. The knowledge lives in one place even if it is used in two.
- The same values or literals copied: single-source-of-truth.
- The same logic copied: duplicated-logic.
- A split that follows the order of steps: temporal-decomposition.
- A contract meant to be known by many, defined once and versioned: an API schema, a published event shape.
- Knowledge shared between two files inside one module or folder. The cost lands when it crosses a module or package boundary.
- Knowledge shared through a stable, documented interface. Leakage is knowledge that bypasses the interface.

## Severity
- must fix: the diff changes the decision in one module and leaves another module that also knows it on the old version.
- should fix: the diff adds a second module that knows a format, layout, or protocol an existing module owns, or the diff had to edit several modules for one decision.
- nit: an interface exposes more than its callers need, and no second module depends on the exposed detail yet.

## Remedies
- move the knowledge into the owning module and expose an operation
- introduce one parser or builder both sides call
- make the value opaque outside its owner
- narrow the interface to what callers need
- merge the two modules when neither can hide the decision alone

## Related
- single-source-of-truth: copied values. Here: a copied design decision, encoded in different code on each side.
- duplicated-logic: the same code twice. Here: different code that shares one secret.
- temporal-decomposition: a cause of leakage, when the split follows the order of steps.
- strong-connascence: grades how two places must agree. Here: whether a second place should know at all.
- incomplete-propagation: the forgotten site when a leaked decision changes. Both can fire on one diff.

## Sources
- review threads: none (seed only)
- A Philosophy of Software Design, ch. 5 (information hiding and information leakage)
