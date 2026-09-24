---
name: shallow-abstractions
family: Structure
tags: [any]
evidence: 13
---
# Shallow abstractions

## Index line
Wrappers, pass-through functions, extra files, and machinery that add parts without adding clarity.

## What to look for
- A function, class, file, or endpoint whose whole body is one call to something else, with no translation, validation, or error handling of its own.
- A backend route that only forwards a client call to an adapter or a third party. It adds a hop and a failure mode and centralizes nothing.
- One small unit split across several files where one file would hold it and the repo's siblings use one file.
- A class with one method plus a separate wrapper function around it, or a method made public for a single internal caller.
- A markup wrapper element with no structural or styling job: a container around a single child, or a layout element that only holds another layout element.
- A wrapper component rendered even when it has nothing to wrap or nothing to show.
- Lazy loading, a suspense boundary, or code splitting around a small, cheap part.
- A conditional written in a roundabout form where a simpler operator gives the same result. Check that the simpler form has the same null and false behavior.
- A generic helper whose type parameter resolves to the whole union at the call site, so the link it claims to enforce is never checked. A plain map would be clearer.
- An optional view or adapter layer that narrows a union again after the parse edge already did, or carries fields no consumer reads.
- A type or schema derived piece by piece from another one that it does not match. The derivation adds indirection and still needs hand edits.

## Why it matters
- Each extra unit is one more place to read, name, test, and keep in sync. It costs attention on every visit.
- Pass-through endpoints and wrappers add latency, failure modes, and a second copy of the same interface.
- Thin layers hide where the real logic lives. Readers chase calls through files that do nothing.

## What not to flag
- A wrapper that adds real work: error mapping, retries, validation, caching, auth, or a narrower interface than the thing it wraps.
- A wrapper element that carries a style, a layout role, an accessibility role, or a ref.
- A seam the repo's established pattern requires, when every sibling has it.
- A wrapper that hides a third-party API on purpose so the rest of the code does not depend on it.
- A small helper that gives a name to a non-obvious expression. Naming is a valid reason to exist.
- A lazy boundary around a part that is large or rarely shown.

## Severity
- must fix: a pass-through endpoint or layer that adds a network hop or a failure mode for nothing.
- should fix: wrapper files, classes, or helpers that only forward, and generic machinery that does not check what it promises.
- nit: a wrapper element or a roundabout expression that reads worse but works.

## Remedies
- inline the wrapper and call the underlying module directly
- fold the wrapper into the class and make the inner call private
- replace the generic helper with a plain map
- delete the wrapper element
- use the simpler operator

## Related
- layer-abstraction-mismatch: a stack of layers repeating one interface, or a variable threaded through layers, goes there. A single thin unit is here.
- missed-simplification: a reframing that deletes whole branches or modes goes there. Here a unit is removed and the logic stays.
- precedent-divergence: when the extra parts also break the sibling pattern, report the pattern break there.
- dead-code-and-export-surface: unused wrappers go there. Wrappers with a caller are here.
- speculative-generality: machinery built for a future need goes there. Machinery that fails the current need is here.
- convoluted-control-flow: long compound conditionals go there. A roundabout single expression is here.
- layout-robustness: a wrapper element that breaks alignment or wrapping is reported there.

## Sources
- review threads: 13 accepted change requests from real code reviews
- A Philosophy of Software Design: deep vs shallow modules, pass-through methods
- thermo-nuclear-code-quality-review skill: thin wrappers
