---
name: magic-values
family: Structure
tags: [any]
evidence: 5 accepted ePort threads
---
# Magic values

## Index line
Inline numbers, strings, and lists where a named constant, enum member, or shared export exists or should.

## What to look for
- A number in a comparison, slice, limit, timeout, retry count, or size check with no name and no comment saying where it comes from.
- A string literal compared with or assigned to a field whose type is an enum or a union, when the enum or a constant object already exists in the repo.
- A literal that repeats a value the shared schema, config, or constants module already exports.
- A list of keys, names, steps, or statuses written out by hand when the repo already exports that list.
- A literal whose value differs from what the other side sends or expects. The literal hides a bug.
- A test baseline (a date, an id, a count) written as a bare literal with no name and no comment on why that value.
- The same literal in more than one place in the diff.
- A literal passed as a positional argument where the reader cannot tell what it controls.
- A literal that encodes a unit, currency, locale, or time zone that only the author knows.

## Why it matters
- A literal that should match a shared value drifts when the shared value changes, and nothing tells the type checker.
- A literal that already disagrees with the source of truth is a silent bug at merge time.
- Readers cannot tell whether a number is a limit, a default, or an accident.
- Renaming an enum member does not reach string literals, so the build passes and the runtime fails.

## What not to flag
- Zero, one, minus one, the empty string, true, false, null, and undefined.
- Expected values inside test assertions. The literal is the point of the assertion.
- A literal whose meaning the surrounding name already states, when no shared value for it exists.
- The definition site of a constant, enum, or config schema. That is where literals belong.
- Class names, style values, and design tokens written the way the styling system expects.
- User-facing copy and log text. Copy that must match another place belongs to single-source-of-truth.

## Severity
- must fix: the literal disagrees with the value the enum, schema, or other side defines.
- should fix: a literal duplicates an existing enum member, constant, or exported list; a limit or timeout with no name.
- nit: a one-off literal that would read better with a name, when no shared value exists.

## Remedies
- replace with the existing enum member or constant
- import the list from the owning package
- extract a named constant next to its use
- move the value to shared config
- name the test baseline and say why that value

## Related
- single-source-of-truth: two hand-maintained copies that must stay in sync; here one literal where a named value exists or should.
- primitive-obsession: the type of the field or parameter that carries the value.
- closed-set-exhaustiveness: whether a map over the enum covers every member.
- missing-why-comment: a constant that has a name but no reason.
- query-cache-and-keys: whether a cache lifetime value is right for its consumers; here only whether it is named.

## Sources
- ePort: !56 !75 !79 !98 !156
- code-reviewer skill: magic variables
