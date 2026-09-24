---
name: manual-memoization
family: Design (books)
tags: [web, shared-ui]
evidence: 0
---
# Manual memoization the compiler already does

## Index line
Manual memoization where the React compiler already handles it, without a documented exception and a reason comment.

## What to look for
- First confirm the repo compiles with the React compiler: look for the compiler plugin in the build config and its lint rule. If absent, stop; manual memoization is the normal tool there and only its dependency lists are worth checking.
- Then read the repo's own memoization rule, if one exists, and use its exception list and its required comment format. Without one, use the usual exceptions: context provider values, computations that are truly expensive, list items with internal state, components excluded from the compiler, and stable references for effect dependencies.
- useMemo, useCallback, or memo added or kept in the diff with no comment stating which exception applies.
- A comment that names a reason the compiler already covers: a plain derivation from props or state, or a handler passed to a child.
- A memoized value whose body reads the current time, randomness, or a ref, so the cached value goes stale while the dependencies stay the same.
- A dependency list that omits a value the body reads.
- memo on a component whose props are rebuilt each render by a parent outside the compiler, so the boundary never holds.
- memo added below a boundary that already stops re-renders, or at a level where the props are fresh objects every time.
- Memoization used to make an effect dependency stable when the effect itself should go.

## Why it matters
- Under the compiler, manual memoization is noise that readers must verify and that can defeat or duplicate the compiler's work.
- Wrong dependency lists and time-dependent bodies turn a harmless optimization into stale data on screen.
- A required reason comment is the only way a later reader can tell a deliberate boundary from a leftover.

## What not to flag
- Repos without the compiler.
- Memoization with the required comment naming one of the documented exceptions.
- A memo boundary on a list row that the author documents as a deliberate hard boundary, even when the compiler might already cover it.
- Third-party hooks or libraries that require stable references and say so in their docs.
- Files or components opted out of the compiler with a directive and a reason.
- A context value that is rebuilt every render and needs memoization: react-state-and-effects owns that, and the fix is to add it.

## Severity
- must fix: the memo caches a stale value that depends on time, a ref, or a missing dependency.
- should fix: memoization added without the required comment, or for a reason the compiler covers.
- nit: the comment exists but does not name the exception.

## Remedies
- remove the wrapper and let the compiler handle it
- add the required comment naming the exception
- move the memo boundary to the right level
- fix the dependency list
- opt the component out of the compiler and say why

## Related
- react-state-and-effects: effects, context values, subscriptions, and keys against React rules.
- derived-state-and-effect-sync: state that should be a derivation, not a memo or an effect.
- text-disagrees-with-code: a memoization comment that gives a wrong account of how hooks or memo behave.
- performance: avoidable re-renders from unstable values, where the fix may be memoization.
- project-rule-conformance: the repo's rule on memoization, when it says more than this candidate.

## Sources
- review threads: none (seed only)
- code-reviewer skill: memoization check; the repo's memoization rule file, read at run time; React Compiler docs
