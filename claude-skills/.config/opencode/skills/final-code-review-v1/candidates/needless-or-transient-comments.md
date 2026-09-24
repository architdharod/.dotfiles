---
name: needless-or-transient-comments
family: Text
tags: [any]
evidence: 14 accepted ePort threads
---
# Needless or transient comments

## Index line
Comments that restate the obvious, cite transient facts, leak the author's workflow, list callers, or use docblock syntax on nothing.

## What to look for
- A comment that restates what the name or the next line already says, or defines an ordinary domain term the codebase uses everywhere.
- A comment that justifies code by a transient fact: a migration's rollout state, a flag phase, a design mock, a product decision, a meeting. The fact expires and the comment stays.
- A comment that cites a ticket, a chat, or a person as the reason instead of stating the reason.
- A comment that records the author's process: what was tried, what a local setup does, what comes next, what a previous iteration looked like.
- A comment that describes code that is not in the repository: a planned helper, a removed branch, another repo.
- A comment that lists where a symbol is used. Callers change and the list rots.
- A comment that defends a plain derivation because a related derivation sits far away. Moving the two together removes the need for the prose.
- A test or fixture comment that explains when a state can arise in production instead of what the test asserts or what the fixture represents.
- A comment the diff replaces with a vaguer one: the old one named a concrete value, the new one names a phase.
- A docblock in documentation syntax attached to no declaration, so tools bind it to the next unrelated symbol or drop it.
- Inconsistent commenting: some members of a list or object carry an obvious comment, others carry none.

## Why it matters
- Readers stop reading comments when most add nothing, and the one that matters gets skipped.
- A comment tied to a rollout, a decision, or a workflow becomes false silently, and nobody owns removing it.
- Where-used lists and ticket citations send readers outside the code for facts the code should state itself.

## What not to flag
- A comment that explains a non-obvious decision, constraint, or guarantee. That is the good case; missing-why-comment asks for more of them.
- A durable reference to a standard, a vendor document, or a documented API behavior the code implements.
- A comment that contradicts the code it sits on: text-disagrees-with-code.
- Commented-out code: dead-code-and-export-surface.
- Docblocks on a public API that a doc generator or a written project rule requires, even brief ones.
- Comments in docs files and ADRs: docs-scope-and-durability.
- TODO markers: scope-and-requirements and project-rule-conformance decide those.

## Severity
- must fix: never on its own.
- should fix: a comment that will go stale by itself (rollout, decision, workflow, where-used) or one that describes code that does not exist.
- nit: restating the obvious, an orphan docblock, inconsistent commenting.

## Remedies
- delete the comment
- state the durable rule instead of the transient reason
- move the two derivations together and drop the prose
- move the process note to the MR description
- turn the orphan docblock into a plain comment

## Related
- missing-why-comment: the opposite gap, a non-obvious decision with no comment.
- text-disagrees-with-code: a comment that is wrong about the code. Here: a comment about things outside the code, or about nothing.
- docs-scope-and-durability: the same durability test applied to docs files.
- writing-style: prose that is padded or generic. Here: prose that should not exist.

## Sources
- ePort: !148 !161 !233 !259 !289 !292
- A Philosophy of Software Design, ch. 12 and 13 (comments)
- refactoring.guru: comments (dispensables)
