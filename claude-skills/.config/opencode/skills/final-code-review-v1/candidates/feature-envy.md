---
name: feature-envy
family: Design (books)
tags: [any]
evidence: 0 accepted ePort threads
---
# Feature envy

## Index line
A function that works mostly on another module's data and belongs next to that data.

## What to look for
- A function that reads several fields of one object from another module and few or none of its own module's data.
- A function in one module that takes another module's entity as its only input and derives a fact, a status, or a rule from that entity's fields alone.
- Logic that reaches past another module's public surface into its internal structure, nested fields, or naming conventions to get what it needs.
- The same derivation from another module's data repeated by several consumers, each next to its own call site.
- A new function whose imports are all types from one other module.
- A test for the function that needs only the other module's fixtures.
- A change to one module's data shape that forces edits in a function of another module.
- A component or hook that computes a domain rule from an entity's fields instead of asking the entity's module.

## Why it matters
- Knowledge about a data shape spreads to every module that reads it. A shape change then touches all of them.
- The owning module cannot protect its invariants when other modules compute rules from its raw fields.
- The derivation is rewritten per consumer, and the copies drift.

## What not to flag
- Views, serializers, formatters, and mappers. Reading many fields of the thing they render or translate is their job. Flag only when they derive a domain rule from those fields.
- Strategy, visitor, or plugin patterns that separate behavior from data on purpose so the behavior can be swapped.
- A boundary adapter that must touch both sides' shapes.
- Data that lives in a plain type package with no functions. There is nothing to move the logic next to. Suggest a domain helper module instead.
- A one-off read through another module's public accessors.
- Test code that builds and inspects another module's fixtures.

## Severity
- must fix: rarely on its own. Raise to must fix when the envious function computes an invariant the owning module also enforces and the two can disagree.
- should fix: a function that derives a domain fact from another module's fields, or reaches into its internals.
- nit: a small helper that reads a few fields of another module's object once.

## Remedies
- move the function to the module that owns the data
- extract the envious part and move it, keep the rest
- add an accessor or method on the owning module and call it
- ask the owning module for the derived value

## Related
- wrong-home: placement judged by layer or module role goes there. Placement judged by which data the function body touches is here. When the layer is the problem, report there.
- complexity-pushed-to-callers: looks from the module's interface at what it makes callers do. This candidate looks from the caller's body.
- message-chains: the length of the path to reach a value goes there. Which module should own the logic is here.
- together-or-apart: module boundaries as a whole go there. One function's placement is here.
- duplicated-logic: the same derivation copied in several places is also reported there.
- information-leakage: a shape known by several modules is reported there when no single function stands out.

## Sources
- ePort: none
- Refactoring (Fowler): feature envy
