---
name: absence-conflation
family: Correctness
tags: [any]
evidence: 14
---
# Absence conflation

## Index line
One value stands for empty, missing, failed, unsupported, or not found, or a fallback masks missing data.

## What to look for
- One value (null, undefined, an empty string, list, or object) carries more than one meaning: not provided, confirmed empty, failed to load, unsupported, not found, not yet requested. Trace each meaning to the point where the code decides what to render or store.
- A default or fallback on a required field turns a missing value into an empty one, so the UI renders an empty or broken item instead of an error state.
- A default that treats an explicit null like an omitted value, when null means something (unassigned, cleared) and callers cannot ask for that meaning. Seed and fixture helpers are a common place.
- A lookup or parse with no not-found branch, so a miss throws, returns an empty value, or leaves a documented not-found response unreachable.
- A lookup keyed by a value echoed from another system (a name or label) that can miss, with no stable fallback key.
- "No filter given" and "filter matched nothing" share one representation, so an empty filter widens results instead of narrowing them to none.
- A derived status or rollup reads some failure flags but not all, so a partial load error shows as healthy or complete data.
- A not-yet-requested state (query disabled, nothing entered) is styled like loaded data that lacks the field.
- Schema defaults absorb contract drift, so a renamed or dropped upstream field is indistinguishable from a legitimately absent one.
- The declared not-found response and the handler's behavior disagree in either direction.

## Why it matters
- Missing data renders as valid empty data, so users and downstream code act on nothing as if it were confirmed.
- Filtering and authorization scope breaks when "no restriction" and "restricted to nothing" collapse into one value.
- Load failures hide behind healthy-looking UI, and tests seeded through defaults exercise the wrong state.

## What not to flag
- A default on a truly optional field where the domain defines omitted and empty as the same thing.
- A documented fallback with its reason in a comment. Whether the comment is adequate belongs to missing-why-comment.
- An empty-collection default for a list field where "no items" is the only meaning and load failure is signaled by a separate flag the consumer checks.
- Coalescing on a value the type already proves cannot be null.
- Not-found handling the framework provides at the route level, when the handler relies on it on purpose.
- A partial failure reported as success at the notification layer. That is outcome-signaling.

## Severity
- must fix: a collapse that changes filtering or authorization scope; a load failure rendered as healthy or complete data; a required-field fallback that renders broken output.
- should fix: a lookup miss with no branch; a default that swallows explicit null in a seed or helper; schema defaults that absorb drift.
- nit: styling of an empty state where the data itself is handled correctly.

## Remedies
- replace the shared value with a discriminated state
- add the not-found branch
- fail loudly on a missing required field
- keep failure flags separate until the render decision
- key the lookup by a stable identifier

## Related
- ambiguous-result-shapes: the type design of a return shape. Here the runtime data flow where meanings collapse.
- guards-from-wrong-or-partial-sources: a guard reading a proxy or partial fact. Here the concern is what absence means.
- outcome-signaling: partial failures reported as success by toasts, logs, or errors.
- error-messages-and-codes: which status code or message a miss gets.
- ui-state-fidelity: what the user sees versus state, when the cause is not a collapsed absence.
- define-errors-out-of-existence: the deliberate opposite move, making an absence a non-error.
- test-fixtures-and-setup: fixture shape and setup cost in general.

## Sources
- review threads: 14 accepted change requests from real code reviews
- other sources: none
