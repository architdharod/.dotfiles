---
name: single-source-of-truth
family: Structure
tags: [any]
evidence: 18
---
# Single source of truth

## Index line
One fact, list, type, or fixture kept by hand in two places, or one constant serving two rules.

## What to look for
- A hand-written list, map, or enum whose members are a subset or a relabeling of members another constant already holds.
- Two maps keyed by the same set where the second could be derived from the first, or from one meta table that holds every facet of each member.
- A type written inline that another module already exports, or a union spelled out where it could be derived from the constant it mirrors.
- The same constant, config value, endpoint address, timeout, or multi-step protocol defined in two modules.
- The same user-facing string in two files, including a test that repeats the string from the component instead of importing it.
- A test schema or fixture that copies the shape of a shared schema or of another fixture instead of extending or importing it. Check whether the copy also loosened a type.
- A component that re-lists the fields a formatter reads, so the two lists drift when a field is added.
- The same options block or key prefix repeated in every branch or every sibling, when one helper could own it.
- The same verdict computed in two layers from different inputs. Check whether the two can disagree at the boundary.
- One constant used by two rules that only happen to share a value today. Changing it for one rule silently changes the other.
- Shared logic that branches on type guards when the fact it needs already lives in a lookup the repo maintains.

## Why it matters
- Two copies drift. The next change updates one and the other keeps the old value with no error.
- A coincidental shared constant is a hidden coupling. Widening it for one rule reroutes the other.
- Subsets typed by hand lose the compiler's help when the source grows.

## What not to flag
- Two values that are equal today but stand for different decisions. Keeping them separate is the point. Flag only when one constant serves both.
- A duplicate that lives outside the diff and was not touched.
- A test that pins user-facing copy as a literal on purpose, when the repo's tests do that everywhere.
- A local alias that narrows or renames an exported type for readability and stays structurally tied to it.
- Fixtures that differ on purpose to cover different cases.
- Strings repeated across translation files, which the translation system owns.

## Severity
- must fix: two copies of a rule or value that can disagree and change behavior, or one constant secretly serving two rules.
- should fix: parallel maps, retyped shapes, copied schemas, and repeated option blocks.
- nit: a repeated short string, or a type that could be derived but rarely changes.

## Remedies
- derive the subset from the canonical constant
- import the exported type or schema and extend it
- move the shared value into the contract module both sides import
- add a meta table and derive each map from it
- split the shared constant into one per rule

## Related
- duplicated-logic: repeated behavior goes there. Repeated facts, values, types, copy, and fixtures are here.
- magic-values: one unnamed literal goes there. The same value in two places is here.
- incomplete-propagation: a copy that was left behind by an update goes there. The existence of the copies is here.
- information-leakage: a decision two modules both encode in logic with no literal copy goes there.
- closed-set-exhaustiveness: whether a map covers every member goes there. Whether the map could be derived is here.
- test-fixtures-and-setup: fixtures too thin or too broad go there. Fixtures that copy another shape are here.
- guards-from-wrong-or-partial-sources: one guard reading a proxy fact goes there. The same verdict derived twice is here.
- query-cache-and-keys: the cache values chosen go there. Repeating them per branch is here.
- naming: a copy whose name suggests a different concept is also reported there.

## Sources
- review threads: 18 accepted change requests from real code reviews
- A Philosophy of Software Design: information leakage
