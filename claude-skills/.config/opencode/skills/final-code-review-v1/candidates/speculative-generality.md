---
name: speculative-generality
family: Design (books)
tags: [any]
evidence: 0 accepted ePort threads
---
# Speculative generality

## Index line
Parameters, options, abstractions, or extension points added for a future need that no present caller has.

## What to look for
- A parameter, prop, or option that every caller in the repo passes with the same value or leaves unset.
- A function or component made generic, configurable, or pluggable while the repo has one concrete use. A type parameter with one instantiation.
- A base class, interface, or abstract layer with a single implementation and no second one in this MR.
- A registry, plugin point, strategy map, or event hook with one entry.
- A comment, name, or MR text that justifies a piece by a future need rather than a present caller.
- A feature flag, mode, or branch for a variant nothing selects yet.
- A dependency or helper layer pulled in for capabilities the one call site does not use.
- Getter and setter pairs or wrapper types that only forward to a field, added so the field can change later.
- Configuration surface (environment variables, settings, schema fields) nothing reads.
- An optional field or nullable mode added to a type for a shape no producer emits yet.

## Why it matters
- Every unused option is code that must be read, typed, tested, and kept working for nobody.
- The guess about the future is usually wrong. The real need arrives in a different shape, and the general code is then in the way.
- Generic names and layers hide the one concrete thing the code does, so readers look for uses that do not exist.

## What not to flag
- Generality with a second caller in this MR or elsewhere in the repo.
- Extension points a written architecture rule requires: a plugin system, a public SDK surface.
- A parameter with one value today whose second value this MR introduces or its description commits to.
- An unused export, function, or prop with no consumer at all: dead-code-and-export-surface.
- A wrapper or pass-through that exists now and adds nothing now: shallow-abstractions.
- A test helper parameter nobody passes: test-fixtures-and-setup.
- A shape a library or framework requires (a required prop, an interface it calls), even when the repo uses one variant.
- A shared package API with consumers outside this repo. Check before flagging.

## Severity
- must fix: never on its own.
- should fix: an abstraction, layer, or option set with one use that makes the present code harder to follow or to type.
- nit: a single unused parameter or option that is cheap to remove.

## Remedies
- remove the parameter
- inline the single implementation and drop the interface
- collapse the hierarchy
- replace the registry with a direct call
- delete the unused mode and its branch

## Related
- shallow-abstractions: an abstraction that buys nothing now. Here: capability nobody needs now.
- dead-code-and-export-surface: no consumer at all. Here: one consumer, using one of several modes.
- missed-simplification: a needed behavior built in a roundabout way. Here: behavior that is not needed.
- complexity-pushed-to-callers: configuration callers are forced to set. Here: configuration nobody sets.
- scope-and-requirements: required work that is missing. Here: unrequired work that is present.

## Sources
- ePort: none
- Fowler, Refactoring: speculative generality
- refactoring.guru: speculative generality
- A Philosophy of Software Design, ch. 19 (patterns for their own sake, getters and setters)
