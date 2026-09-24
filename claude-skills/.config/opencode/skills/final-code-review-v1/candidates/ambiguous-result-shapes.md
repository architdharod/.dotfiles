---
name: ambiguous-result-shapes
family: Types
tags: [any]
evidence: 5
---
# Ambiguous result shapes

## Index line
Results or states whose outcome is encoded by absence or by several booleans instead of a tagged union.

## What to look for
- A function that returns a value on success and undefined or null on failure, so callers cannot tell failure from an empty result and get no error detail.
- A result type whose members share no discriminant field, so callers must cast or probe optional fields to learn which case they hold.
- A state or result object with several independent boolean flags for one facet. Count the combinations the type allows against the ones that can occur.
- Fields that only mean something in one mode but are typed optional in every mode, so each consumer re-checks them.
- A type assertion at a use site that stands in for a runtime fact the compiler cannot see. A discriminant set where the value is parsed would let narrowing replace the cast.
- A cast over a whole object that discards inference for unrelated generics, when narrowing one field at the parser would do.
- A new result shape that differs from how every other result type in the repo signals its outcome.
- Consumers that recombine flags or re-derive the case in several places, each with its own fallback.

## Why it matters
- Untagged shapes push a runtime check onto every consumer, and each consumer gets it slightly wrong.
- Independent booleans allow impossible combinations, and the type cannot rule them out.
- Casts hide the gap. A later change to the shape compiles and fails at runtime.

## What not to flag
- A lookup that returns undefined for a plain miss when no failure case exists and the repo's lookups all do that.
- A single boolean for a single independent facet.
- Optional fields that are optional in every mode for real.
- A cast the repo needs at a library boundary, with a comment on why.
- A result shape the repo has standardized on, even if another shape would be nicer.

## Severity
- must fix: an untagged shape or independent flags that let an impossible combination reach production code, or that force casts in several consumers.
- should fix: a new result type that breaks the repo's outcome convention, or a cast that a discriminant at the parser would remove.
- nit: an optional field that could be tied to a mode but has one consumer.

## Remedies
- return a tagged union with a discriminant field
- add the discriminant where the value is parsed
- model each facet as its own tagged state
- narrow one field instead of casting the object
- follow the repo's existing result type

## Related
- imprecise-types: the cast itself goes there. The shape that makes the cast necessary is here.
- absence-conflation: several meanings of nothing sharing one data value goes there. A result with no tag at all is here.
- type-runtime-contradiction: a type and a runtime check that disagree goes there. A type too loose to carry the case is here.
- outcome-signaling: what the user or the log sees about an outcome goes there. The type that carries it between functions is here.
- closed-set-exhaustiveness: once a union has a tag, whether every member is handled goes there.
- primitive-obsession: a status carried as a bare string goes there.
- precedent-divergence: a break from the repo's result convention is also reported there when a sibling shows the pattern.

## Sources
- review threads: 5 accepted change requests from real code reviews
- Effective TypeScript: tagged unions
