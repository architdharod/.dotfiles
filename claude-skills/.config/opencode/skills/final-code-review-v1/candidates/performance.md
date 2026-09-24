---
name: performance
family: Process
tags: [any]
evidence: 5
---
# Performance

## Index line
Per-item lookups in loops, serialized independent work, unbounded queries, avoidable re-renders, heavy imports in hot paths.

## What to look for
- A database or network lookup inside a loop over a data-driven collection, or a lookup skipped for some items because it was too costly per item. Collect the keys and resolve them in one batched query.
- Independent async calls awaited one after another when nothing in the second depends on the first.
- A query with no limit, no pagination, and no bound on the set it scans, on a table that grows with usage.
- A context value built as a new object or array on every render, so every consumer re-renders whenever the provider renders.
- Constant lists, maps, or config objects allocated inside a component body on every render, when they depend on nothing from the render.
- A subscription to a frequently changing value at the top of a large component tree, when only a small leaf reads it.
- A store selector that returns a fresh object or array on each run, so the equality check never passes and the subscriber re-renders on every store change.
- A heavy module imported at the top of a hot path or a widely shared entry, when only one rare branch uses it.
- Work repeated per render or per request that could be done once at module load or cached by key.

## Why it matters
- Per-item lookups and serialized calls turn a fast path into one that scales with the data, and it only shows at production sizes.
- Unbounded queries work in development and time out on real tables.
- Unstable context values and broad subscriptions re-render whole trees per keystroke, and the cost hides until the tree is big.

## What not to flag
- Sequential calls where order matters, where the second call needs the first's result, or where a rate limit or a transaction requires it.
- Loops over small, fixed collections. Flag only when the size follows the data.
- Queries bounded by a key or by a small closed set.
- Inline objects passed to plain elements or cheap children in a repo that runs the React compiler. Hoisting is a nit there at most.
- Cold paths: one-off scripts, migrations, tests, and admin tools.
- Micro-optimizations on paths with no measurable cost.
- Perf machinery for small, cheap parts. Asking for lazy loading, virtualization, or caching where nothing is heavy is the opposite problem.

## Severity
- must fix: an unbounded query or a per-item remote call in a request path that scales with user data.
- should fix: an unstable context value, an over-broad subscription, or serialized independent calls on a user-facing path.
- nit: constants rebuilt per render, and heavy imports on a path that is rarely hot.

## Remedies
- batch the lookups by collecting keys first
- run independent calls concurrently
- add a limit and pagination
- hoist constants to module scope
- narrow the subscription to the leaf that reads the value and return stable selector values

## Related
- react-state-and-effects: effect misuse, state placement, keys, and rules-of-React violations go there. Render cost is here.
- manual-memoization: adding memoization the compiler already does goes there. Do not suggest it as a remedy here.
- data-loading-wiring: children re-fetching what a parent holds, and loader placement, go there.
- query-cache-and-keys: cache and refetch settings go there.
- batch-failure-isolation: one item's failure spreading to its siblings goes there. Speed is here.
- ci-config-and-dependencies: oversized bundled assets go there. Heavy imports on hot paths are here.
- shallow-abstractions: perf machinery around small parts is reported there.

## Sources
- review threads: 5 accepted change requests from real code reviews
- thermo-nuclear-code-quality-review skill: sequential orchestration
- seed list wider than the review threads
