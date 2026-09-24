---
name: message-chains
family: Design (books)
tags: [any]
evidence: 0 accepted ePort threads (seed only)
---
# Code that walks a chain to reach a value

## Index line
Code walks a chain of objects or optional fields to reach a value, so it depends on the whole path.

## What to look for
- A read that reaches through three or more objects or optional fields to get one value, so the reader depends on every link's shape.
- The same long path repeated in several places in the diff or in the file. Count the repeats.
- Optional chaining stacked link after link to survive any missing part, where the owner of the data could expose a resolved value instead.
- A function or component that receives a large object and reads one deep field. It should receive the field, or ask the owner for it.
- A caller that navigates from an entity to its parent, then to a sibling collection, to find a value the entity's own module could provide.
- Deep destructuring in a signature that bakes the nesting into the function's contract.
- Test doubles that must build the whole nested path to satisfy one read.
- The same navigation written in a different order in two places, so a shape change breaks them differently.

## Why it matters
- Every link in the chain is a dependency. A change to any intermediate shape breaks every reader of the chain.
- Chains hide where a value belongs, so the logic that should sit next to the data ends up scattered across callers.
- Stacked optional chaining hides which links are legitimately absent and which are bugs.

## What not to flag
- Fluent builders and query builders whose chaining returns the same builder; that is the API's design.
- Paths of two links, or paths inside the module that owns the shape.
- A boundary layer whose job is to know the external shape: a parser or mapper that reads the nested response once and returns a flat value.
- Reading a nested config or schema value once in the module that defines it.
- Optional chaining whose only fault is that the type is wrongly nullable: imprecise-types or absence-conflation.

## Severity
- must fix: rarely; only when a chain crosses a module boundary and a shape change in the diff already broke a reader.
- should fix: the chain is repeated, or it reaches across a module boundary so distant code depends on an internal shape.
- nit: a single deep read in one place.

## Remedies
- hide delegate: add a selector or method on the nearest owner
- extract function for the navigation
- pass the resolved value as a prop or argument
- resolve once at the parse edge
- move the reader next to the data

## Related
- feature-envy: the reader belongs next to the data it reads.
- information-leakage: a shape known by several modules; a chain is one way it leaks.
- data-loading-wiring: children re-fetching what the parent holds, the runtime cousin of passing whole objects down.
- code-obviousness: generic containers and tuples that make the chain hard to read.
- absence-conflation: when the optional links hide real absences.

## Sources
- ePort: none
- refactoring.guru: message chains; Fowler, Refactoring: hide delegate
