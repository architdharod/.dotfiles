---
name: query-cache-and-keys
family: Frontend
tags: [web]
evidence: 10
---
# Query cache options and keys

## Index line
Query keys, staleness, refetch, invalidation, and shared option factories set without regard to siblings or consumers.

## What to look for
- A query key that does not mirror its endpoint and its sibling keys: a variant suffix or a parameter is missing, so two responses share one cache entry or one dataset lives under two keys.
- A key assembled by hand at the call site while siblings use a shared key builder.
- A shared query-options factory that pins staleness, cache lifetime, or refetch settings every consumer inherits, with no parameter for a caller to override them.
- A cache lifetime tuned for one consumer inside options that other consumers share.
- A staleness window on a detail page that must refetch after navigation, so the user sees the previous visit's data until it expires.
- A prefetch whose staleness window is shorter than the time a user can spend before navigating, and no refetch interval, so navigation is instant only briefly.
- A consumer that omits the staleness its siblings use for the same near-static data, so it refetches on every focus and mount.
- A lookup or existence check that reuses the options of a broader search query, so every mounted instance becomes an observer with the search query's staleness and refetch behavior.
- A mutation whose invalidation misses a query that shows the changed data, or whose callback that does the invalidation is never reached.
- A query feeding a timer, countdown, or deadline that never refetches while mounted, so a change on the server fires a stale warning.
- Invalidation keyed too narrowly or too broadly against the key hierarchy: it misses a sibling, or it refetches everything.

## Why it matters
- A wrong key serves one endpoint's response for another, or splits one dataset into two caches that disagree.
- Options pinned in a shared factory spread one page's tuning to every consumer, and nobody can undo it locally.
- Missing invalidation leaves screens showing pre-mutation data after the user navigates back.
- Wrong staleness either hammers the server on every focus or shows stale data where the page promised fresh.

## What not to flag
- A staleness or refetch choice that matches its siblings and the data's rate of change, even when it differs from the library default.
- Literal durations where the project keeps them inline by convention: magic-values decides that.
- Where a mutation callback or loader lives, placeholder data, and Suspense placement: data-loading-wiring.
- A guard that reads one of two queries' loading flags: guards-from-wrong-or-partial-sources.
- Options pinned in an object with one consumer. The problem starts when the options are shared.
- Cache settings a written project rule prescribes for that page type: project-rule-conformance.

## Severity
- must fix: two endpoints share a cache key, or a mutation leaves visible data stale with no refetch path.
- should fix: pinned options in a shared factory, a missing sibling staleness, a prefetch that stops being instant, a time-driven query that never refetches.
- nit: a key that works but breaks the builder convention, or an option that matches behavior but not the sibling convention.

## Remedies
- mirror the endpoint in the key and reuse the key builder
- accept caller options in the factory and spread them last
- move staleness to the consumer that needs it, and give lookups their own options
- invalidate every query that shows the changed data
- add a refetch interval to time-driven queries

## Related
- data-loading-wiring: how loading and callbacks are wired. Here: what the cache options and keys are.
- guards-from-wrong-or-partial-sources: a guard that reads one of several queries. Here: an invalidation that names one of several queries.
- precedent-divergence: a sibling pattern ignored in general. Here: the query-option and key conventions specifically.
- magic-values: the duration literal itself.
- performance: over-broad subscriptions and re-renders. Here: refetch and cache policy.

## Sources
- review threads: 10 accepted change requests from real code reviews
- TanStack Query docs: important defaults, query keys, query invalidation, prefetching
