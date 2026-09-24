---
name: precedent-divergence
family: Structure
tags: [any]
evidence: 27
---
# New code ignores the pattern its siblings use

## Index line
A new case is wired its own way although a sibling already solves the same problem with an established pattern.

## What to look for
- Find the siblings first: files in the same directory, modules with the same suffix, entries in the same registry, the newest merged sibling in git log. Compare the diff against them, not against taste.
- A new route, query, mutation, form, or component does by hand what its siblings do through a shared helper, hook, registry, or component.
- A new call site builds its URL, key, payload, filter, or error mapping with different logic from siblings in the same file.
- A new async flow awaits or chains by hand where the documented project pattern uses callbacks, and nothing in the flow needs the ordering.
- A new query or mutation omits an option, callback, or invalidation that every sibling sets, so its data goes stale or refetches when siblings do not.
- A per-case branch is added to shared code where siblings register through a lookup keyed by kind.
- A schema, builder, or field is stricter, looser, or more optional than the sibling schema for the same data, with no stated reason.
- The diff splits or merges files (types, helpers, orchestration, service and route) differently from how sibling modules are laid out.
- Test setup introduces a new idiom for a dependency (timers, mocks, instances) where the same file already has an idiom for it.
- A UI element keeps a library default where the surrounding screen uses a customized convention, so one symbol means two things on one screen.
- A new handler treats all outcomes of an API alike where the sibling handler for the same API distinguishes a recoverable one.
- A replacement component drops behavior the pattern gave for free (validation, error display, accessible state) because it was not wired into the same layer.

## Why it matters
- Two ways of doing one thing means every reader must learn both and every future change must touch both.
- Deviations often drop behavior the pattern carried, so the new case is quietly worse than its siblings.
- Consistency is a cheap correctness check: a reviewer can compare against the sibling instead of reasoning from scratch.

## What not to flag
- The sibling is the outlier. Check rule files and the newest siblings; when the diff follows the documented or newer pattern, the older sibling is the problem, not the diff.
- A deviation with a stated reason in a comment or the MR description that names a real need: concurrency, ordering, a library limit, a different transport.
- A pattern that cannot serve the new case without changing the pattern itself. Then judge the change to the pattern, not the deviation.
- Formatting, import order, and other things a formatter or linter owns.
- The only sibling is deprecated or under migration.
- Naming that breaks the sibling naming scheme belongs to naming. A written rule belongs to project-rule-conformance.

## Severity
- must fix: the deviation drops behavior siblings have, or gives one symbol opposite meanings on one screen.
- should fix: the deviation adds a second way to do one thing that later changes must keep in step.
- nit: a local layout or ordering difference with no behavior cost.

## Remedies
- reuse the sibling's helper, hook, or component
- register in the existing lookup instead of branching
- align the schema or builder with the sibling
- adopt the sibling file layout
- adopt the documented async pattern

## Related
- project-rule-conformance: a rule a file states in words; here the pattern is shown only by siblings.
- duplicated-logic: the diff re-implements a helper that exists; here it wires the case in a different shape.
- reinvented-library-feature: a library or design-system primitive rebuilt by hand.
- query-cache-and-keys: whether the cache option's value itself is right.
- wrong-home: the code sits in the wrong layer, whatever the siblings do.
- ambiguous-result-shapes: the shape's own problems; here only the departure from the repo convention counts.

## Sources
- review threads: 27 accepted change requests from real code reviews
- code-reviewer skill: style conformance; A Philosophy of Software Design ch. 17 (consistency)
