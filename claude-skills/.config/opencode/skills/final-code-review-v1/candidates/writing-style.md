---
name: writing-style
family: Text
tags: [any]
evidence: 0 accepted ePort threads
---
# Writing style in comments, docs, and MR text

## Index line
Comments, docs, and MR text that read like generated prose: puffed up, padded, generic, or hedged instead of plain.

## What to look for
- Sentences that claim significance or quality instead of stating what the code does. Replace the claim with the fact.
- Trailing participle phrases tacked onto a sentence to add depth it does not have.
- Padding: a heading followed by a sentence that restates it, an opening that announces what follows, a closing line that sums up or cheers.
- Groups of three for their own sake, contrast built as "not this but that", and ranges between two things that share no scale.
- Vague authority with no source (a recommendation attributed to nobody), and claims stacked with hedges until nothing is asserted.
- Roundabout phrases where a short verb would do; passive sentences that hide who does what; fragments with no subject.
- Sentences generic enough to sit in any repo's docs and say nothing about this code.
- One concept named by a different word each time it appears, so a reader wonders whether two things are meant.
- Chat residue committed to the tree: offers to help, questions to the reader, sign-offs, thanks.
- Bullet lists where each item starts with a bold label and a colon, and a sentence would read better.
- Em dashes, bold on ordinary phrases, emoji, and title-case headings in docs that otherwise use sentence case.
- Commit messages or MR descriptions that list the files touched or restate the diff instead of saying why the change was made.

## Why it matters
- Padded text hides the one sentence the reader needed, so readers skim and miss it.
- Generic prose ages badly and gives a future reader nothing to check.
- Sales language in a comment raises doubt about what the code does, and generated-sounding text makes reviewers distrust the rest of the MR.

## What not to flag
- Plain, dry, technical prose. Dryness is not a tell.
- One transition word, one short emphatic sentence, or one dash on its own. Flag clusters, not single hits.
- Quoted text, proper names, and text the diff carries over unchanged from elsewhere.
- Precise formal vocabulary that the domain uses.
- User-facing copy that follows the project's tone guide.
- A comment whose content is wrong or stale. That is text-disagrees-with-code.
- A comment that should not exist at all. That is needless-or-transient-comments.

## Severity
- must fix: chat residue or padding that hides or contradicts the one instruction the reader needs.
- should fix: padded or generic docs and comments where the specific claim is missing; a cluster of tells in one file; MR text that restates the diff without the why.
- nit: a single tell: one dash, one bold label, one puffed word, one title-case heading.

## Remedies
- cut the sentence
- replace the claim with the specific fact
- name who does what in active voice
- write the why instead of the what
- run the text through the humanizer skill

## Related
- text-disagrees-with-code: wrong content. Here only the style.
- needless-or-transient-comments: comments that restate the code or narrate the author's workflow.
- missing-why-comment: a comment that is absent.
- docs-scope-and-durability: what a doc should cover and for how long.
- naming: identifiers rather than prose.
- project-rule-conformance: language and casing rules the repo states.

## Sources
- ePort: none
- humanizer skill (Wikipedia: signs of AI writing); user seed
