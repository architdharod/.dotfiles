---
name: exception-aggregation
family: Design (books)
tags: [api, web]
evidence: 0
---
# Exception aggregation and masking

## Index line
One error class handled at many sites, or caught far from the level that understands it; handle each class once.

## What to look for
- The diff adds a catch around one call site for an error class that the same module, or a level above it, already handles for its siblings.
- The same handling pattern (catch, map to a response, log, return a fallback) repeated at several call sites, when one handler at the dispatcher, middleware, route boundary, or loop level would cover them all.
- A catch placed below the level that has the context to decide (the request, the user, the item), so it can only swallow, rethrow, or return a sentinel.
- A low-level failure that could be masked at its source with a retry, a default, or a self-heal instead propagates to every caller, and each caller now handles it.
- A catch that converts a specific error into a generic one and rethrows, so the aggregating handler above can no longer tell the classes apart.
- A blanket catch at a high level that swallows classes it does not understand along with the one it targets.
- One error class handled at two levels at once (a callback and a boundary, a hook and a wrapper), so recovery or the user message runs twice or in an order nobody chose.
- A catch-and-continue for a failure the code cannot recover from, where failing the operation and reporting it is the honest handling.
- Per-item handlers inside a loop that each do the same mapping, when one boundary around the loop would do it once. Keep per-item isolation only when items are independent.

## Why it matters
- Handlers copied at each call site drift. One gets the mapping wrong and the same error class produces different outcomes.
- A catch without context can only hide the error or make it vaguer. The information the top-level handler needs is gone.
- A too-broad catch turns unknown failures into silent ones.
- Every extra handler is a branch the reader must follow to know what a failure does.

## What not to flag
- One handler per error class at the level that understands it, even when it sits high. That is the goal.
- Per-item catches that keep independent items from aborting a batch: batch-failure-isolation.
- A catch that adds context and rethrows once, where the project's error-tracking rule asks for it. Double reporting belongs to error-reporting-hygiene.
- Framework-required boundaries at prescribed levels: a UI error boundary, a route error component, a job runner's handler.
- Handling that differs by call site because the recovery differs. Aggregation fits identical handling only.
- An error the API could remove entirely: define-errors-out-of-existence.
- Whether the code or message is right: error-messages-and-codes.

## Severity
- must fix: a broad catch swallows failure classes it does not handle, so the operation reports success or continues on corrupted state.
- should fix: the same handling repeated at several sites, or a catch placed where it lacks the context to decide.
- nit: a single redundant catch that only rethrows or repeats what the boundary handler does.

## Remedies
- move the handler to the boundary and delete the copies
- mask the error at its source with a retry or a default
- narrow the catch to the classes it handles and let the rest propagate
- let the operation fail and report it
- keep one handler per error class

## Related
- define-errors-out-of-existence: remove the error. Here: place the handling for errors that remain.
- batch-failure-isolation: keep independent items apart. Here: do not repeat the same handler per item.
- error-reporting-hygiene: how errors reach the tracker. Here: where they are caught.
- error-messages-and-codes: what the error says. Here: where it is handled.
- duplicated-logic: copied handler code in general. Here: the design that made the copies necessary.

## Sources
- review threads: none (seed only)
- A Philosophy of Software Design, ch. 10 (exception masking, exception aggregation, just crash)
