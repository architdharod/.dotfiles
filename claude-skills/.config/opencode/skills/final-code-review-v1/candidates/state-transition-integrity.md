---
name: state-transition-integrity
family: Correctness
tags: [api, db]
evidence: 12 accepted ePort threads
---
# State changes without guards, atomicity, or a way to finish

## Index line
A write moves an entity to a new state without checking preconditions, claiming it atomically, or finishing the lifecycle.

## What to look for
- A status update whose preconditions (the row exists, is in the expected state, belongs to the caller, has the expected kind) are not checked in the same statement or transaction as the write.
- A read followed by a write with no atomic claim, where two callers can pass the read at the same time and both proceed.
- A multi-phase write where the first phase commits a state that no later step can recover from if the next phase fails. Look for a completion write that precedes the creation of the next step.
- A failure after a committed phase returns a generic error, so the client's retry hits a conflict and the user is stuck.
- A path that can leave an entity in an in-progress state with nothing left that can close it.
- A delete of a parent that leaves child rows, linked steps, or remote ownership markers behind.
- A step, job, or task that never ran is closed with a success-like status instead of being removed.
- A mutation trusts a client-supplied id or snapshot for which row is current, instead of checking it is still the open one.
- A terminal or fallback write guarded by row id alone, without the claim token, version, or active-status fence the main path uses.
- A parse or schema accepts either arm of a union at a transition, so the wrong arm can be copied forward unchecked.
- A committed row points at another entity by a mutable reference only, so a later delete leaves the row half-described.
- A reset that puts an entity into a pool that no reader consumes.

## Why it matters
- A crash or race between phases strands real work: tasks nobody can pick up, containers nobody can close, rows nobody owns.
- False success statuses poison analytics and hide the failure that caused them.
- Stale clients and concurrent callers are normal, not rare. An unfenced write lets one overwrite finished work.

## What not to flag
- Single-statement updates whose precondition sits in the where clause or a database constraint.
- Writes that are idempotent, where a repeat produces the same end state.
- Intermediate states that are designed, visible, and resumed by a worker, with that documented in code.
- A precondition already checked earlier in the same request, shown in the diff or the surrounding code. Do not demand it twice.
- Soft deletes where dependents must stay for history and the code says so.
- Retry and idempotency of external calls: external-writes-and-retries. Who may call: authorization-checks.

## Severity
- must fix: a race, crash, or stale client can corrupt data, strand an entity, or overwrite completed work.
- should fix: the lifecycle can only complete by manual repair, or analytics record success for work that never ran.
- nit: the precondition is checked but not atomically, the race window is theoretical, and a comment says so.

## Remedies
- check preconditions and fence with a token or version inside the write itself
- wrap the phases in one transaction
- cascade or block the delete
- delete a never-run step instead of closing it
- give one service ownership of the whole lifecycle

## Related
- external-writes-and-retries: distinguishing a later failure from a failed external write, and safe retries.
- guards-from-wrong-or-partial-sources: the guard reads the wrong fact; here the guard is missing or not atomic.
- authorization-checks: whether the caller may act at all.
- outcome-signaling: how a partial failure is reported, once the write itself is sound.
- data-model-and-migrations: constraints the schema itself should hold.

## Sources
- ePort: !71 !108 !113 !116 !127 !156 !274 !283 !291
- thermo-nuclear-code-quality-review skill: non-atomic updates
