---
name: any-leakage
family: Design (books)
tags: [any]
evidence: 0
---
# any leakage

## Index line
any or un-narrowed unknown in signatures, fields, or state, so type errors move to runtime; narrow at the boundary.

## What to look for
- A parameter, return type, or field typed any in a new or changed signature. A return type of any spreads to every caller.
- any in an exported function or shared type, so modules the diff never touches inherit it.
- unknown accepted at a boundary and passed on without a type guard or a schema parse, or narrowed with a cast instead of a check.
- Values from JSON parsing, a fetch response, a form, an event payload, a message queue, storage, or an untyped library flow into typed code with no parse step.
- A cast straight from any or unknown to a rich object type where a guard or a parse would do.
- Implicit any: untyped callback parameters or destructured values in a file where the compiler's implicit-any check is off or suppressed.
- Compiler-silencing comments or lint suppressions for the explicit-any rule added by the diff.
- any used to satisfy a library type at one call site, then stored in state, a field, or a context, so it escapes the call site.
- A variable declared without a type and assigned later from several sources, so its type evolves and widens.
- Plain any where a more precise variant exists: an array of any, a record with any values, a function type with any arguments.
- Global or window patching typed through any.
- any in test files that hides a mismatch the production code would catch.

## Why it matters
- Every value touched by any loses checking, and so does every value derived from it.
- Runtime failures appear far from the untyped source and are hard to trace back.
- Refactors miss call sites the compiler cannot see through any.
- Type coverage drops with each any that leaks, and it rarely comes back.

## What not to flag
- any confined to one expression inside a function whose signature is fully typed. An unsafe cast hidden in a small well-typed function is the recommended pattern.
- unknown at the boundary that is narrowed before use.
- A library that ships no types, wrapped once in a typed adapter.
- Type coverage in files the diff does not touch.
- A default any on a generic parameter of a library type when callers still get inference.
- Casts and annotations between two specific types: that is imprecise-types.
- Whether validation of external input exists at all: that is validation-boundaries. This candidate covers whether the type after the check is narrowed.

## Severity
- must fix: any in an exported signature, a return type, or a shared type; unknown from external input cast to a rich type without a check.
- should fix: any escaping a call site into state or a field, suppressions added by the diff, plain any where a precise variant exists.
- nit: any in a one-line local, a test, or a generic default.

## Remedies
- replace any with unknown and narrow it with a type guard
- parse at the boundary with a schema
- hide the cast in a small well-typed function
- use the precise variant instead of plain any
- wrap the untyped library once in a typed adapter

## Related
- imprecise-types: casts and wide-but-specific types. This candidate covers any and unknown.
- validation-boundaries: whether external input is checked. This candidate covers whether the type follows the check.
- type-runtime-contradiction: types that permit what the code assumes impossible.
- test-fixtures-and-setup: fixture shape. any in a fixture is reported here.

## Sources
- review threads: none (seed only)
- Effective TypeScript: limit any, narrowest scope for any, precise variants of any, hide unsafe casts in well-typed functions, evolving any, prefer unknown to any, type coverage
