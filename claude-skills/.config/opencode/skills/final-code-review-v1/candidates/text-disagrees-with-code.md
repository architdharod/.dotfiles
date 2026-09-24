---
name: text-disagrees-with-code
family: Text
tags: [any]
evidence: 36
---
# Text disagrees with code

## Index line
Comments, docs, API descriptions, or UI copy that contradict the code or omit a constraint it enforces.

## What to look for
- A comment, docblock, or file header that names a symbol the diff renamed or removed, describes behavior the diff deleted, or sits above a different function than the one it describes.
- A comment that states a rule as absolute while the code below has a fallback or an exception to it.
- A comment that justifies a choice with a wrong account of how a library, a hook, or a service behaves, or a config comment that misstates how a service is reached.
- A prop or parameter docblock that promises more than the implementation does, or whose name suggests a wider contract than the code honors.
- A response schema or API description that lists a status the handler can never return, or omits one the shared middleware can return. Check sibling routes with the same middleware.
- A schema description that names the wrong subject, or schema examples that still show an old key.
- A served spec or contract doc that omits a constraint the code enforces. A constraint the spec generator drops counts.
- A glossary or doc that defines a term the code no longer uses, describes a seam or pairing the code no longer has, or introduces vocabulary the code does not use.
- A change that updates one documented fact while the same diff changes others in the same doc. Check every documented fact the diff touches.
- UI copy that names a location, section, or state that a logic change made wrong.
- A test title that says one thing while the body asserts another.
- An MR description or commit message that claims a change, a check, or a config the branch does not contain.

## Why it matters
- Readers trust text over code when they are in a hurry. Wrong text sends them to a wrong conclusion with no error.
- A served API spec is a contract. When it is wrong, clients build against values the server rejects or statuses it never sends.
- Stale glossary entries teach new people vocabulary that nothing in the code answers to.

## What not to flag
- Text that is vague or thin but not wrong. That is missing-why-comment or docs-scope-and-durability.
- A comment that cites a transient fact that is still true today. That is needless-or-transient-comments.
- Docs for behavior that lives outside the diff and was not changed by it.
- Style, tone, or length of the prose.
- A doc that describes intent the code is meant to reach, when the MR says so and tracks the gap.

## Severity
- must fix: a served spec, contract doc, or UI copy that misstates what the system accepts, returns, or does.
- should fix: comments, docblocks, glossary entries, and MR text that contradict the code.
- nit: a comment naming a renamed symbol where the meaning is still clear.

## Remedies
- update the text to match the code
- fix the code when the text states the intended rule
- delete the comment
- regenerate the spec, or express the constraint so the generator keeps it
- fold the useful half of a glossary entry into an existing entry

## Related
- missing-why-comment: absent explanation goes there. Present but wrong text is here.
- needless-or-transient-comments: comments that restate the obvious or cite a rollout go there.
- docs-scope-and-durability: docs that snapshot the MR or reach outside their scope go there. Docs that misstate the code are here.
- naming: a symbol name that misleads goes there. Prose that misleads is here.
- scope-and-requirements: code that does less than the ticket asked goes there. Text that misstates what the code does is here.
- error-messages-and-codes: an error message naming the wrong condition goes there. Other copy is here.
- ui-state-fidelity: labels that must follow runtime state go there. Static copy that a logic change made false is here.
- dead-code-and-export-surface: the unused prop or export goes there. Its stale docblock is here.
- incomplete-propagation: code siblings left unchanged go there. Text left stale is here.

## Sources
- review threads: 36 accepted change requests from real code reviews
- A Philosophy of Software Design: comments
