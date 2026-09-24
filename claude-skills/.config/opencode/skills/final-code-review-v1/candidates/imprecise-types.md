---
name: imprecise-types
family: Types
tags: [any]
evidence: 12 accepted ePort threads
---
# Imprecise types, casts, and annotations

## Index line
Casts, wide types, or annotations where a schema, enum, or inference already gives the precise type.

## What to look for
- A cast on a value that a schema parse, a generic, or inference already types.
- A hand-written type that exists only to be the target of a cast, while the schema or the function already produces that type.
- A cast placed over a whole options or config object. It erases inference for unrelated generics inside the object.
- A field, parameter, or key typed as plain string, number, or open record while an enum, union, schema, or key set for it exists in the code.
- A helper that accepts any string key where the set of keys is known and could be constrained to the keys of the source type. Often the helper can go once the type is right.
- A set or list of strings used to sidestep a case or spelling mismatch that a typed guard could narrow to the enum.
- A changed-fields or partial object typed loosely instead of from the mutation's own parameter type.
- Open records of unknown used as overrides on fixtures or option objects where the target type is known.
- Explicit annotations on locals or trivial functions where the project's rule is to let inference work, or return types missing where the project requires them.
- A type described by a wide base so a typo is caught only at runtime, where deriving the type from the definitions would make it fail to compile.

## Why it matters
- A cast silences the compiler. The wrong type ships and fails at runtime.
- A wide type on a known set loses exhaustiveness and autocomplete, so typos ship.
- Hand-written copies of schema types drift from the schema.
- Annotations against the project rule add noise and review disagreement.

## What not to flag
- A cast at a real boundary where the input is untyped, applied once and narrowed there. any and unknown handling is any-leakage.
- A cast the compiler needs for a known limitation when a short comment says why.
- Annotations that deliberately widen or narrow an inferred literal to the intended union.
- Return types on a package's public API when the project asks for them.
- Types that are wide because the runtime value really is open-ended.
- The project's return-type rule, not personal preference, decides annotation findings. When the rule is unwritten, do not flag style; note the gap under project-rule-conformance.
- A new domain type for a bare primitive where none exists: that is primitive-obsession.

## Severity
- must fix: a cast that hides a real type mismatch or erases the type of a parsed value.
- should fix: a plain string or open record where an enum, schema, or key set exists; a hand-written duplicate of a schema type; a cast over a whole object; loose fixture overrides.
- nit: annotation style against the project rule, trivial return types.

## Remedies
- derive the type from the schema
- constrain the key to the keys of the source type
- narrow at the parser instead of casting the object
- replace the string set with a typed guard
- drop the annotation and let inference work, or add the return type the rule requires

## Related
- any-leakage: any and un-narrowed unknown spreading through signatures. This candidate covers casts and wide-but-specific types.
- primitive-obsession: introducing a domain type where none exists. This candidate covers not using one that exists.
- ambiguous-result-shapes: result shapes that need a discriminated union.
- type-runtime-contradiction: guards for cases the type forbids.
- closed-set-exhaustiveness: maps keyed by an enum that are not exhaustive.
- project-rule-conformance: the annotation rule itself and its exceptions.
- duplicated-logic: a fixture copied verbatim across packages.

## Sources
- ePort: !39 !46 !47 !79 !131 !161 !185 !216 !288
- code-reviewer skill: unnecessary typecasts
- Effective TypeScript
