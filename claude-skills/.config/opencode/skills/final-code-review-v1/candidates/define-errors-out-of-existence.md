---
name: define-errors-out-of-existence
family: Design (books)
tags: [any]
evidence: 0
---
# Errors the API could define away

## Index line
An error is thrown or returned for a case the API could define away, so callers carry needless handling.

## What to look for
- A function throws or returns an error for a case the caller cannot use: removing something already gone, cancelling something already finished, subscribing twice, an empty range, an empty list.
- A special return (null, undefined, a failure result) for a boundary case whose natural value is an empty collection, zero, or a no-op.
- Every caller handles the new error the same way: swallows it, logs it, or converts it back into success. That shows the error carries no information.
- A check-then-act pair the caller must perform, where the callee could do both in one step and make the check unnecessary.
- A new error code or class for input the API could accept by normalizing it: surrounding whitespace, casing, a trailing separator, a missing optional part.
- A throw on out-of-range values where clamping or an empty result loses nothing.
- Try/catch wrappers whose only expected failure is the already-done case.
- An error added to the public surface of a module that only one internal caller can trigger and always ignores.

## Why it matters
- Every error case is an interface the caller must learn, test, and handle. Cases that mean nothing are pure cost.
- Handlers that neutralize an error spread the same boilerplate to each call site and hide the errors that matter.
- APIs that tolerate the harmless case are simpler to call and harder to misuse.

## What not to flag
- Errors that carry information the caller acts on differently: not found when the caller must decide whether to create.
- Validation of external input at a boundary: validation-boundaries.
- Cases where silent success would hide a real bug, mask a race, or lose data.
- Domain rules where the refusal is the product behavior.
- Unrecoverable states that should crash rather than be absorbed.
- Error paths the diff does not add or change.

## Severity
- must fix: rarely; only when the added error path makes callers retry or repair something that was never broken.
- should fix: the diff adds an error every caller already neutralizes.
- nit: an internal special case with one caller.

## Remedies
- make the operation idempotent
- return the empty value
- widen the accepted input by normalizing it
- fold the precondition into the operation
- delete the error branch and its handlers

## Related
- exception-aggregation: the same error class handled in many places or too high; here the error should not exist at all.
- complexity-pushed-to-callers: the wider pattern of making callers do the module's work.
- absence-conflation: when empty, missing, and failed must stay distinct, do not define the distinction away.
- ambiguous-result-shapes: how an outcome is signalled once it is a real outcome.
- error-messages-and-codes: the wrong message or code for a real error.

## Sources
- review threads: none (seed only)
- A Philosophy of Software Design ch. 10 (define errors out of existence)
