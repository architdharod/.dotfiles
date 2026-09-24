---
name: ui-state-fidelity
family: Frontend
tags: [web, shared-ui]
evidence: 10
---
# UI state fidelity

## Index line
What the user sees does not match the state: labels, empty states, duplicates, scope, raw values, pending feedback, routing.

## What to look for
- A toggle or bulk-action control keeps the same label after its action has fully applied, so it offers what is already done.
- A submit or action button is only disabled while the request runs, or a status change shows no in-flight feedback at all. Nothing says work is in flight, and the view jumps from old to new when the response arrives.
- Internal identifiers, keys, enum values, or codes rendered where a human label exists or should exist.
- A user-facing error that names records by id instead of by name.
- A highlighted or preselected option that is not what the confirm key commits. Highlight and selection disagree.
- Results filtered or deduped against another group, so a group looks empty although matches exist. Users read it as no match.
- Two descriptor sets read the same source keys, so one value renders twice in one panel.
- A shared body drags in fields from a sibling workflow that do not belong in this view.
- After the last step of a flow, navigation lands on a generic page instead of the view that shows the new state, so the result is unreachable from the main path.
- A tile, summary, or count shows one of several possible entities without saying which one.
- Data shown for a scope (one entity, one period, one filter) that the view does not name.
- Wrong or missing user-facing copy deferred to a follow-up although it sits on the main path.

## Why it matters
- Users act on what they see. A stale label or a wrong highlight makes them do the wrong thing.
- No pending feedback reads as a dead control. Users click again or leave.
- Raw ids and keys expose internals and mean nothing to the people who must act on them.
- An empty group or an unlabeled tile makes users trust wrong conclusions about their data.

## What not to flag
- No pending feedback on local actions that complete at once and cannot fail.
- Ids shown in developer, admin, or support views where the id is the intended reference.
- Empty states that are truly empty.
- Color-only status or missing accessible names: that is accessibility.
- Placeholder or stale data that the loading layer should mark: that is data-loading-wiring.
- The toast or message after an action completes: that is outcome-signaling.
- Whether the data layer tells absent from empty: that is absence-conflation. This candidate covers rendering that makes one state look like another.
- Layout breaking with real copy: that is layout-robustness.

## Severity
- must fix: the new state is unreachable after the main flow, the committed value differs from the highlighted one, or duplicate or unlabeled data leads to a wrong reading.
- should fix: no pending feedback on network mutations, internal values in user copy, an empty state that misleads, a label that does not follow state.
- nit: label wording, feedback on fast local actions.

## Remedies
- derive labels and highlights from the current state
- add a pending indicator to the control
- map internal keys to labels before rendering
- name the scope, and dedupe the descriptor set per workflow
- route to the view that shows the result

## Related
- accessibility: names, roles, and color. This candidate covers content and timing of what is shown.
- data-loading-wiring: how data arrives. This candidate covers how it is presented.
- outcome-signaling: reporting results after an action.
- absence-conflation: absent versus empty at the data layer.
- error-messages-and-codes: the error's condition and code. The ids in its text belong here.
- scope-and-requirements: deferrals in general. A deferred user-facing defect on the main path is reported here.

## Sources
- review threads: 10 accepted change requests from real code reviews
- other: none
