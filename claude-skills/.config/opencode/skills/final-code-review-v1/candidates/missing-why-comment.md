---
name: missing-why-comment
family: Text
tags: [any]
evidence: 17 accepted ePort threads
---
# Missing why-comment

## Index line
Non-obvious decisions, asymmetries, matchers, contracts, suppressions, and dependencies with nothing near the code saying why.

## What to look for
- A check, filter, matcher, or comparison whose purpose is not clear from its name and operands, with no comment saying what it is for or what it rules out.
- A decision whose reason lives only in the MR description, a review thread, a chat, or a transient doc. The reader of the code never sees those.
- An asymmetry: one direction, one branch, or one sibling treated differently from the rest, with nothing saying why.
- A placement or timing choice that breaks the usual pattern (data loaded earlier than its consumer, a cache lifetime, a retry count) with no stated reason.
- A new dependency, or a switch of library, with no note on why it was chosen and what it replaces.
- A lint or type suppression with no comment saying why the rule does not apply on that line.
- A shared helper whose docblock omits its contract: what it returns, what it accepts, the edge cases it handles, the ones it knowingly does not.
- A helper with a tricky boundary (a time zone edge, an off-by-one, a wrap-around) that its docblock does not show.
- A field or parameter docblock that restates the name and says nothing about who consumes the value, its range, or whether it is validated before it leaves the system.
- A positional or ordering contract (keys in a fixed order, arguments paired by position) with nothing that states it.
- Two helpers with similar names that implement different rules, where neither docblock says which rule is which.
- A docblock filled with internal implementation reasons while the contract callers need is absent.

## Why it matters
- The next reader cannot tell a deliberate choice from an accident, so they either "fix" it or copy it.
- A contract that lives in a thread or a chat is lost within a month; the code outlives the MR.
- An undocumented gap in a shared helper becomes a bug in every caller that assumed the general case.
- Unexplained suppressions and dependencies get copied as precedent.

## What not to flag
- Code whose intent is clear from good names and small functions. A comment that restates the code is worse than none.
- Cases where a rename or a small restructure would make the comment unnecessary. Suggest that instead.
- A reason already stated in an ADR, a README, or a rule file that the code links to or sits next to.
- A comment that exists and is wrong. That is text-disagrees-with-code.
- Suppression and dependency rules the repo's own rule files govern. project-rule-conformance checks those.
- Private helpers with one caller where the call site makes the purpose plain.
- The choice of value or placement itself. Other candidates judge whether it is right; here only the missing reason.

## Severity
- must fix: a positional contract, or a known gap in a shared helper, that callers cannot discover and the diff already relies on.
- should fix: a decision, asymmetry, or dependency whose reason exists only outside the code; a suppression with no reason; a shared utility docblock missing its contract.
- nit: a non-obvious local check that one line of comment would clarify.

## Remedies
- add a why-comment next to the code, or link the ADR or doc from it
- write the contract into the docblock: inputs, returns, edges, known gaps
- state the reason in the suppression comment
- record the dependency choice and alternatives in the repo docs
- rename or restructure so no comment is needed

## Related
- text-disagrees-with-code: a comment exists and is wrong.
- needless-or-transient-comments: a comment restates the obvious or cites a passing fact.
- docs-scope-and-durability: where a durable decision record belongs and when an ADR is warranted.
- magic-values, query-cache-and-keys, data-loading-wiring: whether the value or placement is right; here only the missing reason.
- project-rule-conformance: suppression and dependency rules the repo states.
- code-obviousness, naming: when the code itself should carry the meaning.
- strong-connascence: whether a positional contract should exist at all.

## Sources
- ePort: !41 !54 !66 !71 !85 !131 !155 !161 !288 !289 !291
- A Philosophy of Software Design: comments should describe what is not obvious from the code
