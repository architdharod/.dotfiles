---
name: primitive-obsession
family: Design (books)
tags: [any]
evidence: 0 accepted ePort threads
---
# Primitive obsession

## Index line
Plain strings and numbers carrying domain meaning where a union, enum, or branded type would stop mix-ups.

## What to look for
- Several different ids in one signature all typed as plain string or number, so a caller can pass them in the wrong order and the type check passes.
- A status, kind, mode, or category typed as plain string when the set of values is closed and known.
- A quantity typed as plain number with the unit only in its name or a comment, where two units meet (seconds and milliseconds, cents and whole units, percent and fraction).
- Money as a bare number with no currency, or amount and currency as two loose values.
- A date or time as a string or number whose format or zone the type does not fix, passed between modules.
- A value validated once (an email, a URL, a country or language code) then passed around as a plain string, so nothing marks it as checked.
- Structured data encoded into a delimited string that several modules parse back.
- A function that takes a string and immediately splits it into parts the caller already had separately.
- A boolean parameter where the two states have domain names or a third state is plausible.
- The same validation, formatting, or comparison for one kind of value repeated at several call sites because the value has no type to attach it to.

## Why it matters
- Two ids of the same primitive type can be swapped and nothing catches it until production data is wrong.
- A closed set typed as string admits typos and stale values, and no exhaustiveness check is possible.
- Unit mistakes pass every type check and every quick test.
- Behaviour that belongs to a value scatters across callers when the value has no type to hold it.

## What not to flag
- Values only stored and displayed, never compared, combined, or routed on.
- Local variables inside one function, where a type adds ceremony and no protection.
- A project that has decided against branded types. Check the repo's conventions and suggest a union or enum instead.
- Boundary layers that receive primitives from outside (request bodies, database rows) and convert them right there.
- A type for a value that appears once and never meets another value of the same primitive type.
- Counts and indexes, which carry no unit ambiguity.
- The literal at the use site. That is magic-values.

## Severity
- must fix: the diff already contains a swap or a unit mismatch that the missing type would have caught.
- should fix: a closed set typed as string in a shared signature or schema; a quantity whose unit lives only in its name across a module boundary; several same-typed ids in one signature.
- nit: local values and single-use parameters that would read better with a narrower type.

## Remedies
- replace string with a union or enum
- introduce a branded type for the id
- wrap the quantity, or the amount and its currency, in a small value type that carries the unit
- parse and validate once at the boundary, then pass the typed value
- move the value's behaviour into one module or onto the type

## Related
- magic-values: the literal at the use site.
- imprecise-types: types looser than inference or a schema allows.
- data-clumps-and-long-parameter-lists: several values that belong in one object.
- closed-set-exhaustiveness: whether every member of the set is handled.
- value-comparison-pitfalls: comparisons of dates and structured strings that go wrong.
- information-leakage: an encoding that several modules know.
- code-obviousness: tuples or generic containers for specific data.
- speculative-generality: types added for a case that never happens.

## Sources
- ePort: none
- Fowler, Refactoring: primitive obsession
- Effective TypeScript: precise unions and branded types
