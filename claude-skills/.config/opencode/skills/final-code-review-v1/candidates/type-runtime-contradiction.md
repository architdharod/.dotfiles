---
name: type-runtime-contradiction
family: Types
tags: [any]
evidence: 5
---
# Type and runtime contradict each other

## Index line
Guards for cases the type forbids, or types that promise what the runtime does not deliver.

## What to look for
- Optional chaining, a nullish fallback, or a null check on a value whose type says it is always present.
- A default supplied for a field the type or schema marks required.
- A guard that returns early or throws for a state the union type cannot represent.
- A branch for a variant the union does not include, or a default arm for a case that "cannot happen" and is not asserted unreachable.
- A cast or type assertion that gives external data (a token, a response body, a parsed payload, a DOM node) a shape nothing checked at runtime.
- A type declared narrower than what the source documents or sends: a required field the sender may omit, a union missing a value the sender emits.
- A schema marks a field required while the code that reads it still guards for absence. One side is wrong; find out which.
- A hand-written type for data a client library already types, where the two differ.
- A non-null assertion on a value that can be absent at runtime.
- Fields made optional only so a partial construction compiles, then assumed present everywhere else.

## Why it matters
- When the type and the guard disagree, one of them lies and the reader cannot tell which.
- A dead guard hides the real contract and gets copied; a missing guard on a lying type crashes far from the cause.
- A cast on external data turns a type error into a runtime error with no stack trace pointing at the boundary.
- A type that overstates a guarantee makes every consumer trust a promise nothing enforces.

## What not to flag
- A guard at a true boundary where the value arrives as unknown and is narrowed right there.
- Defensive checks the project rules require at a stated boundary.
- A guard kept on purpose with a comment saying why the type cannot be trusted there. Without the comment, missing-why-comment applies.
- An exhaustiveness check that asserts never in the default arm.
- Optional chaining on a value whose type is optional, even when the author believes it is always set in practice.
- A shared parser left lenient on purpose because other flows feed it looser data. Say which side to fix; do not assume the strict side.

## Severity
- must fix: a cast or narrow type on external data the runtime does not guarantee; a type that claims a field is present when the sender can omit it.
- should fix: guards, defaults, or optional chaining for cases the type forbids, when the type is right; a hand-written type that shadows a library type.
- nit: a single redundant null check in local code where the type is clearly right and the check is harmless.

## Remedies
- fix the type and schema together to match the runtime
- remove the dead guard
- parse at the boundary and drop the cast
- use the library's own type
- assert the impossible arm unreachable

## Related
- imprecise-types: casts and annotations that are merely looser than needed; here type and runtime disagree.
- any-leakage: unknown or any spreading past the boundary.
- validation-boundaries: validation missing on external input; here the declared type is what is wrong.
- absence-conflation: what a missing value means once it is legitimately absent.
- blast-radius: when the fix is to tighten a parser other flows share.
- ambiguous-result-shapes: fields optional only because they depend on a mode.

## Sources
- review threads: 5 accepted change requests from real code reviews