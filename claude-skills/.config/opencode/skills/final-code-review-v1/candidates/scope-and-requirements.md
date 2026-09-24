---
name: scope-and-requirements
family: Correctness
tags: [any]
evidence: 16
---
# Scope and requirements

## Index line
Stubs, deferred hard requirements, and behaviour that contradicts the ticket, the design, or the reference system.

## What to look for
- Read first: the MR description if provided, commit messages, ticket text quoted there, design notes, and any repo doc that describes the reference system. Without them, judge from the diff's own claims: its title, comments, and names.
- TODO, FIXME, "later", or "follow-up" markers on behaviour the MR title, description, or ticket says it delivers.
- Template or scaffold placeholders left where real logic should be.
- A control that fakes an action with timers, hard-coded results, or local state that pretends a request happened.
- A follow-up promised in the description, a comment, or a commit message for something the feature cannot ship without: a permission check, recovery after an external side effect, user-facing names instead of raw ids.
- A global or shared change made to patch one local symptom, with the proper fix deferred.
- An element or behaviour the design or ticket specifies and the diff omits: a required control, a toggle that must change its own label, a rule for when a status shows.
- A rule stated in the ticket that the code applies differently or not at all.
- A choice, input, or path offered in the UI that the server side never handles.
- An outbound request to another system that differs from what that system's own client sends, so results differ from what users see there.
- Ordering, grouping, or conventions that reverse what the reference system and the design show.
- Code kept for a plan that has no consumer, with removal deferred.

## Why it matters
- Half-finished behaviour merged as done becomes the baseline; the follow-up rarely happens.
- A fake control teaches users the feature exists, then breaks trust when it does nothing.
- Deviations from the design or the reference system reach users as bugs, whoever wrote the code.
- Deferred integrity work (permissions, recovery) hurts most when it ships late.

## What not to flag
- A deferral the ticket or description scopes out explicitly, with a tracked follow-up, when the shipped part works on its own and nothing exposes the gap.
- Unfinished work kept unreachable behind a feature flag or an unlinked route.
- A TODO that names a tracked improvement beyond the MR's scope, not a gap in what the MR claims to deliver.
- Divergence from the reference system that the ticket asks for on purpose.
- Visual and layout defects against the design. Those belong to layout-robustness.
- A missing check or wrong state another candidate owns outright, unless the diff itself defers it with a note.
- Scope the reviewer would like to add that nobody asked for. This candidate checks what was promised.

## Severity
- must fix: fake or stub behaviour reachable by users; a permission or recovery requirement deferred; a global workaround that changes other pages.
- should fix: elements, behaviour, or rules the ticket or design calls for and the diff omits; parity gaps with the reference system; leftover code for an abandoned plan.
- nit: wording or ordering that differs from the reference where the ticket is silent.

## Remedies
- implement the deferred piece in this MR
- disable or hide the control until the behaviour exists
- remove the placeholder and the code that supports it
- match the reference system's request and ordering conventions
- split the MR so the shipped half is complete on its own

## Related
- layout-robustness: visual defects against the design.
- ui-state-fidelity: labels and states that do not follow the data on screen.
- authorization-checks, validation-boundaries, external-writes-and-retries, absence-conflation: own the missing check itself; here the diff knows and defers.
- blast-radius: the side effects of a global workaround on other flows.
- dead-code-and-export-surface: unused code as such; here the point is that removal was deferred.
- text-disagrees-with-code: a comment that claims a handled case the code lacks.
- needless-or-transient-comments: TODO markers that are stale or leak workflow, not gaps in delivery.

## Sources
- review threads: 16 accepted change requests from real code reviews