---
name: react-state-and-effects
family: Frontend
tags: [web, shared-ui]
evidence: 5 accepted ePort threads
---
# React state and effects

## Index line
List keys, state placement, remount hacks, effect scope, and cleanup against React rules; transient UI state in the URL.

## What to look for
- A list key built from a value that can repeat (a label, a name, a display string), or from the array index on a list that reorders, filters, or edits items.
- Transient UI state (a panel open, a hover, a draft, a focused tab) kept in URL search params, so back navigation and shared links replay it.
- State reset by forcing a remount (a changing key, conditional mounting) on a component that has cleanup effects or exit animations the remount cuts short.
- A hook that watches a long-running condition (a timer, a running job, a subscription) is mounted only on some pages, so navigating elsewhere unmounts it while the condition still holds.
- An effect that subscribes, starts a timer, adds a listener, or starts a request has no cleanup, or a cleanup that does not undo what the setup did.
- A dependency array edited to silence the lint rule (a dependency omitted, a value hidden in a ref) instead of restructuring the effect.
- State held in a component that is not the lowest common owner of the parts that read it, so values travel through callback chains.
- A hook called conditionally, in a loop, or after an early return.
- State or props mutated in place instead of replaced with a new value.

## Why it matters
- Repeated keys make React reuse the wrong instance: inputs keep stale text and items render out of order.
- URL-stored transient state pollutes history and shared links, and back navigation reopens panels.
- Remount hacks and narrowly scoped effects skip cleanup, leak timers, and drop warnings the user needed.

## What not to flag
- Manual memo hooks and the project's compiler exceptions. That is manual-memoization.
- Effects that mirror props into state or compute derived values. That is derived-state-and-effect-sync.
- A key-based reset on a simple component with no cleanup effects or exit animation, which the React docs recommend.
- Index keys on a static list that never reorders, filters, or edits items.
- Shareable state in the URL (filters, page, selected id) that a link should restore.
- A hook mounted per page when the condition it watches is scoped to that page.
- Query cache options and loader wiring. Those are query-cache-and-keys and data-loading-wiring.

## Severity
- must fix: a watcher unmounted while its condition still holds; repeated keys on a list with inputs or stateful items; missing cleanup on a subscription or timer.
- should fix: a remount hack that skips cleanup; transient state in the URL; state at the wrong level; a dependency array edited to silence the lint rule.
- nit: a key choice on a static list that could use a stable id.

## Remedies
- key by a stable id, or dedupe before rendering
- reset the state inside the component
- mount the hook at the scope of the condition it watches
- move the state to its owner: local component state, or the lowest common owner
- add the effect cleanup

## Related
- derived-state-and-effect-sync: derived values in state, effects that sync state, effects doing handler work.
- manual-memoization: memo hooks and the compiler exceptions.
- performance: unstable context values and over-broad subscriptions.
- query-cache-and-keys and data-loading-wiring: query library and router wiring.
- ui-state-fidelity: what the user sees. Here only the React mechanism behind it.

## Sources
- ePort: !41 !43 !183 !280 !298
- code-reviewer skill: useMemo and useEffect misuse
- React docs: rules of hooks, rendering lists, synchronizing with effects, you might not need an effect
