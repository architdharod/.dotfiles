---
name: guards-from-wrong-or-partial-sources
family: Correctness
tags: [api, web]
evidence: 17 accepted ePort threads
---
# Guards built from the wrong or a partial source

## Index line
A guard or derived state reads a proxy fact or only some sources, or runs where it cannot hold.

## What to look for
- A condition reads a proxy for the fact it needs (a timestamp being set, a title pattern, an object's shape, a caller-supplied value) while an authoritative field exists: a status, a discriminant, a stored flag.
- A value is inferred from an unrelated field, on read or on write, although the entity has a dedicated field for it.
- A loading, ready, or error guard checks one of several sources that feed the same view. The others can still be pending or failed when it passes.
- Two places derive the same fact by different rules, so they can disagree for some member. One decides an action and the other displays the state.
- A dedup, lock, or delete-protection check reads one store or one flag while a second source of "already done" or "still referenced" exists.
- A mapping or copy step between two representations drops a field, so state is lost on the next reload or round trip.
- A reset or reassignment path writes an entity into a state no consumer reads, or leaves a related field set, so the entity and its children are orphaned.
- A try/catch or a check wraps a call that never throws or never yields the guarded value, so the failure path is dead and bad input passes through.
- A blocking check sits where the surrounding framework skips it on an unrelated error (a validator that short-circuits, an early return), so the guarded action goes through.
- A check written for one path also runs on a path where its precondition never holds, so the intended fallback is unreachable.
- The same fact is re-derived from raw shape at several sites. One shape change flips all of them at once.

## Why it matters
- The guard passes or fails for states it was never meant to cover. The tested path looks right and the rest is wrong.
- Two derivations of one fact drift, and the action, the display, and the data contradict each other.
- Dedup and delete protection built from one source let duplicates in and delete rows that are still referenced.
- A guard that cannot run, or runs where it cannot hold, leaves the fallback dead with no error pointing at it.

## What not to flag
- A proxy used where the codebase has no authoritative field and adding one is out of scope. Ask for a comment instead.
- Guards for states the type already rules out: type-runtime-contradiction.
- A rule that covers one direction only: mirror-case-gaps.
- A missing precondition or atomicity on a state write: state-transition-integrity. Here the question is which facts the check reads.
- Placeholder data, Suspense placement, and loader wiring: data-loading-wiring.
- A mutation that invalidates too few queries: query-cache-and-keys.
- A dedup that protects a retried external write: external-writes-and-retries.
- One designated source of truth read while a second store mirrors it by documented design.

## Severity
- must fix: the guard decides a write, a delete, a dedup, access, or a user-visible status and reads the wrong or a partial source.
- should fix: a display fact from a proxy, a loading guard that misses one source, a dead try/catch, two derivations that can disagree.
- nit: the proxy and the authoritative field cannot diverge today and the proxy is read at one site.

## Remedies
- read the authoritative field
- derive the fact once in a shared helper and use it at every site
- combine every source into the guard
- move the check to where it cannot be skipped and runs only where its precondition holds
- carry the field through the mapping

## Related
- type-runtime-contradiction: guard versus type. Here: guard versus the other runtime sources.
- absence-conflation: failed, empty, and missing share one value. Here: the guard reads some flags and not others.
- state-transition-integrity: the transition is unchecked or not atomic. Here: the check exists but reads the wrong thing.
- ambiguous-result-shapes: the type lacks a discriminant. Here: the discriminant exists and the code ignores it.
- closed-set-exhaustiveness: an assumed relation between sets. Here: a guard that reads a proxy for one fact.

## Sources
- ePort: !32 !41 !52 !75 !81 !127 !157 !216 !240 !259 !261 !283 !290
- other: none
