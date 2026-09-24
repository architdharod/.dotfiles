---
name: data-loading-wiring
family: Frontend
tags: [web]
evidence: 9 accepted ePort threads
---
# Data that arrives late, stale, borrowed, or after access is gone

## Index line
Wrong wiring between routes, queries, mutations, and components, so data arrives late, stale, borrowed, or after access is gone.

## What to look for
- A route loader that starts a prefetch but does not return or await it. A direct link then renders before the data exists.
- A component that copies loader or route-context data once into local state or a ref. Cache invalidations never reach it again.
- Data that decides where a click or navigation lands, fetched only inside the click handler. The user waits on the click. Load it early and without blocking the page.
- A query that suspends, with no suspense boundary between it and the page shell, so one slow fetch blanks the whole page.
- A suspense boundary so wide that unrelated regions wait on one fetch.
- Effects that must run after a mutation, placed in the call-site callbacks. Those callbacks are skipped when the component unmounts first. Must-run effects belong on the mutation definition.
- A child that receives an id and refetches the entity its parent already holds, then invents fallbacks for the loading gap.
- A settled or ready flag derived from the fetching state. Background refetches on the same key flip it. Only the placeholder-data state marks data borrowed from another key.
- A hook that keeps previous data across key changes and hands it out as current, without exposing the borrowed state, or with that state optional so callers can omit it.
- After a write that removes the caller's access to a resource, the client still invalidates and refetches that resource. The refetch is guaranteed to fail. Navigate away first, or remove the query.
- A fetch started in an effect that a loader or a query hook should own.

## Why it matters
- Direct links and refreshes render empty or crash when a loader does not wait.
- Borrowed data shown as current puts the previous item's values under the new item's heading.
- Mutation side effects in the wrong place skip silently, and the cache stays stale.
- Refetches that are guaranteed to fail log errors and show error toasts for a write that succeeded.

## What not to flag
- Cache timing and key shape: stale time, garbage collection time, refetch intervals, key conventions. Those are query-cache-and-keys.
- Effect and memoization rules in general. Those are react-state-and-effects.
- A non-blocking prefetch in a loader when the page renders correctly without the data and a comment or the docs say so.
- Optimistic updates and pending states that follow the library's documented patterns.
- A child fetching by id when the parent truly does not hold the entity, or holds a different shape of it.
- Call-site callbacks used for effects that may safely skip when the component is gone.
- A route-level suspense boundary when the whole route needs the data before it can show anything.

## Severity
- must fix: loader data a direct link needs that is not awaited; refetch after access loss; must-run mutation effects at the call site.
- should fix: borrowed data treated as current; snapshot reads that miss invalidations; missing or over-wide suspense boundaries; fetches that block a click.
- nit: a child re-fetching what the parent holds when the cache makes it cheap and no fallback logic was invented.

## Remedies
- return the promise from the loader
- move must-run effects to the mutation definition
- pass the entity, not the id
- key the ready state on the placeholder-data flag
- navigate before invalidating, or remove the query

## Related
- query-cache-and-keys: timing, invalidation policy, key conventions.
- react-state-and-effects: effect and memo rules, remount hacks, state placement.
- absence-conflation: a fallback that masks missing data. Here the fallback fills a loading gap the design should not have.
- ui-state-fidelity: the pending feedback the user sees. Here the feedback is derived from the wrong flag.
- performance: fetch waterfalls and serialized requests.

## Sources
- ePort: !32 !36 !43 !46 !232 !241 !244
- TanStack Router docs (data loading)
