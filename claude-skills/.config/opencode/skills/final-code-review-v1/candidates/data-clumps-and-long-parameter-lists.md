---
name: data-clumps-and-long-parameter-lists
family: Design (books)
tags: [any]
evidence: 0 accepted ePort threads
---
# Data clumps and long parameter lists

## Index line
Several values that always travel together as separate parameters or fields, or parameter lists that keep growing.

## What to look for
- The same group of three or more values appears together in several signatures, several call sites, or several record types.
- Fowler's test: delete one value of the group. If the others stop making sense on their own, the group is a clump.
- A function with more than about five positional parameters, or with several parameters of the same primitive type in a row, so callers can swap them without a compile error.
- The diff adds one more parameter to a function that already has many, instead of introducing or extending a parameter object.
- Call sites pad optional positions with undefined to reach a later parameter.
- A caller unpacks an object into separate arguments and the callee uses them only together.
- A parameter the callee could derive from another parameter it already receives.
- A boolean flag parameter that switches between two behaviors, so call sites read as opaque true or false.
- Fields on a type that only make sense together and are always set, checked, or passed together.
- One member of the group passed alone, so the callee must re-fetch the rest.
- Test helpers and builders that take the clump as separate arguments.

## Why it matters
- Every new call site repeats the whole group and can get one member wrong or in the wrong order.
- The group has no name, so the concept it represents stays implicit and cannot get its own behavior.
- Long lists grow by one on every change and are where arguments get swapped.
- Flag parameters hide two functions inside one and make call sites unreadable.

## What not to flag
- Two values that travel together once or twice.
- A function whose many parameters are already named at the call site through an options object.
- Positional parameters in short pure helpers where the types differ and the order is natural.
- A parameter object introduced for a single caller, which only adds indirection: that is speculative-generality.
- Passing the whole object when the callee needs one field and should not depend on the object's type.
- Signatures dictated by a framework or library.
- A single primitive that deserves a domain type: that is primitive-obsession.

## Severity
- must fix: the diff adds a parameter to a list where callers already pad with undefined, or same-typed positional values are swapped at a call site in the diff.
- should fix: the group appears three or more times, or the diff extends an already long list.
- nit: a two-value clump, a flag parameter on a private helper.

## Remedies
- introduce a parameter object
- preserve the whole object
- replace a parameter with a query on another parameter
- remove the flag argument by splitting the function
- extract a class or module that owns the group

## Related
- primitive-obsession: one value needs a type. This candidate covers a group of values that needs an object.
- strong-connascence: caller and callee coupled by parameter position. Report a long list here and other position coupling there.
- speculative-generality: a parameter object nobody needs yet.
- shallow-abstractions: a wrapper type that adds nothing.
- test-fixtures-and-setup: helpers with unused parameters.

## Sources
- ePort: none
- Fowler, Refactoring: data clumps, long parameter list
