---
name: derived-state-and-effect-sync
family: Design (books)
tags: [web, shared-ui]
evidence: 0 accepted ePort threads
---
# Derived state and effect sync

## Index line
State computable from props or other state is stored or synced by an effect; effects do handler work.

## What to look for
- State is initialized from a prop and then kept in sync by an effect that sets it whenever the prop changes.
- A value held in state is a pure function of props or other state: a filtered list, a total, a formatted label, a boolean flag. It can be computed during render.
- An effect reads one piece of state and sets another, so the component renders twice per change and the two values disagree for one frame.
- An effect performs work the user triggered (a submit, a request, a toast, a navigation, a log line) and detects the trigger through a state flag the handler set.
- A chain of effects where each one sets state that fires the next.
- An effect calls a parent's callback to report a state change, instead of the handler that changed the state calling it.
- An effect copies child state up to the parent through a callback, where lifting the state would remove the copy.
- An effect resets local state when a prop changes, where a key or a render-time comparison does the same without an extra render.
- App-wide one-time initialization sits in a component effect that runs per mount, and twice in strict mode.
- A manual subscription to an external store built from an effect plus state, where the subscribe hook exists for this.

## Why it matters
- Each synced copy of a value can go stale, and the sync costs a second render pass.
- An effect standing in for a handler runs on every matching render, not only on the user's action, so it fires on unrelated re-renders and twice in strict mode.
- Effect chains are hard to read and break when one dependency is added.

## What not to flag
- Effects that synchronize with something outside React (the DOM, a subscription, a timer, the network) and clean up after themselves.
- Memo hooks for expensive derivations. That is manual-memoization.
- State seeded from a prop once and then owned by the user's edits, when the intent is explicit.
- A key-based reset that follows the React docs and has no cleanup the remount would cut short.
- Query library hooks, which are effects by design.
- Setting state during render in the narrow pattern the React docs allow for adjusting state on a prop change, when a comment says so.

## Severity
- must fix: a synced copy that can disagree with its source in a way the user sees or submits.
- should fix: derived values held in state; handler work done in an effect; an effect chain.
- nit: a small derived flag in state that cannot go stale today.

## Remedies
- compute during render
- move the work into the event handler
- lift the state to the parent
- reset with a key
- replace the manual subscription with the subscribe hook

## Related
- react-state-and-effects: keys, cleanup, remount hacks, effect scope, and state placement.
- manual-memoization: memo hooks and the compiler exceptions.
- data-loading-wiring and query-cache-and-keys: fetching through the query library and router.
- ui-state-fidelity: stale UI as the user experiences it.
- performance: re-render cost as such.

## Sources
- ePort: none
- React docs: you might not need an effect
