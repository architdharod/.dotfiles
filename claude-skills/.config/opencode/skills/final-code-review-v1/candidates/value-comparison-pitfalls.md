---
name: value-comparison-pitfalls
family: Correctness
tags: [any]
evidence: 3 accepted ePort threads
---
# Value comparison pitfalls

## Index line
Dates crossing UTC and local boundaries, structured values compared as raw strings, comparators that return NaN or hide null handling.

## What to look for
- A UTC instant handed to a component or function that reads local calendar fields (year, month, day), or a local calendar date turned into an instant without an explicit zone. The day shifts for users outside the server's zone.
- A date-only value built from an instant by string slicing or by the local clock.
- Timestamps, dates, versions, or numbers held as strings and compared with string comparison. This works only while every value shares one format, one offset, and one padding.
- A comparator built by subtraction on values that may be unparseable, so it returns NaN and the sort order becomes undefined.
- A comparator that handles null or undefined through a default value instead of an explicit branch, so where missing values sort is hidden.
- A sort whose order is visible to users with no stated tie-break or missing-value policy.
- Objects, arrays, or date instances compared by reference where value equality is meant.
- Equality on floating-point results without a tolerance.
- A comparison that lowercases or trims one side only.

## Why it matters
- Zone mistakes show the wrong day to some users and pass tests run in one zone.
- String comparison of structured values passes on today's data and breaks on the first value with a different format.
- A NaN-returning comparator makes sort order depend on input order and on the engine.
- A hidden null policy makes the visible order change when data is missing, and nobody can say whether that is intended.

## What not to flag
- String comparison of canonical fixed-format values from one source when the type or schema guarantees the format.
- Subtraction comparators on values that are numbers by type.
- Date-only fields stored and compared as calendar dates with no instant semantics anywhere.
- A default zone chosen on purpose and documented.
- Whether null means missing or empty: that is absence-conflation. This candidate covers where nulls sort.
- Display formatting of dates, unless it reads the wrong zone.

## Severity
- must fix: a user-facing date can shift by a day across zones, or a comparator can return NaN or an inconsistent order on real data.
- should fix: raw string comparison of structured values without a format guarantee, a hidden null policy in a user-visible order.
- nit: a missing comment on tie-break or ordering when the code is otherwise explicit.

## Remedies
- convert at the boundary with an explicit zone
- parse first, then compare the parsed values
- write the comparator with explicit branches for missing and unparseable input
- document the ordering and the null policy next to the comparator
- compare by value, not by reference

## Related
- absence-conflation: what a missing value means. This candidate covers how it compares and sorts.
- primitive-obsession: dates and ids carried as bare strings. This candidate covers the comparison, not the type.
- guards-from-wrong-or-partial-sources: a guard that compares the wrong fact.
- missing-why-comment: an undocumented ordering choice is reported here when the comparator is the subject.

## Sources
- ePort: !54 !216 !231
- other: none
