---
name: docs-scope-and-durability
family: Text
tags: [docs]
evidence: 7 accepted ePort threads
---
# Docs that will not last or do not belong

## Index line
Docs that snapshot a moment, copy from code, record routine choices formally, or define terms outside their scope.

## What to look for
- A doc that describes the state of the code as of this diff: what is done so far, what is temporary, what the next MR will do. Durable docs describe concepts and responsibilities, not progress.
- A doc that copies a list, table, or rule that lives in code. The two drift. Point at the code, or generate the doc from it.
- A doc that names concrete paths, files, or symbols in another repo or service. They go stale unseen. Describe the responsibility instead.
- An architecture decision record for a choice that is easy to reverse and involves no real trade-off. Decision records are for choices that are hard to undo or that closed a genuine debate.
- A decision doc that presents a still-open question as settled.
- A glossary entry that explains how data flows or how a feature works. The glossary defines language. Mechanism belongs in a design doc.
- A glossary entry that names a concept from another system that does not exist in this repo.
- A glossary entry that breaks its own rules: it uses a word its own avoid-list bans, or defines a term in a form the code does not use.
- A new identifier or label in the diff whose form disagrees with the glossary's term, in number, wording, or spelling.

## Why it matters
- Snapshot docs are wrong within a few MRs and nobody deletes them. Readers then trust a stale picture.
- A list copied from code is a second source of truth. Readers cannot tell which copy is right.
- Decision records for routine choices bury the ones that matter and train readers to skip them.
- A glossary that mixes mechanism and language, or borrows terms from elsewhere, stops being the place people check words against.

## What not to flag
- A comment or doc that disagrees with the code it describes. That is text-disagrees-with-code.
- A decision with no explanation of why. That is missing-why-comment.
- Prose style: verbosity, padding, tone. That is writing-style.
- Transient facts inside code comments. That is needless-or-transient-comments. This candidate covers standalone docs, decision records, and glossaries.
- Changelogs, release notes, and MR descriptions. Those are meant to snapshot a moment.
- A decision record for a choice that is genuinely hard to reverse, even a small-looking one.
- A doc that cites a path in the same repo, when the path is stable and a rename would show up in a search.
- Glossary rules the repo's own rule files state. Rule conformance checks those. Here, check the entry's scope and durability.

## Severity
- must fix: a doc that copies a rule or list from code, or presents an open decision as settled.
- should fix: snapshot docs, decision records for routine choices, glossary entries that describe mechanism or foreign concepts, identifiers that disagree with the glossary term.
- nit: a cross-repo path reference that could be a description of the responsibility.

## Remedies
- rewrite as the durable concept and drop the progress notes
- link to the code instead of copying it, or generate the doc from the code
- delete the decision record, or downgrade it to a note
- move mechanism out of the glossary into a design doc
- align the identifier with the glossary term

## Related
- text-disagrees-with-code: the doc is wrong about the code.
- missing-why-comment: a decision with no why.
- needless-or-transient-comments: transient facts in code comments.
- writing-style: how the prose reads.
- single-source-of-truth: parallel hand-maintained lists in code. A doc that copies code is the doc side of the same problem and is flagged here.
- naming: an identifier's form in general. A mismatch against a glossary term is flagged here.
- project-rule-conformance: glossary rules the repo states itself.

## Sources
- ePort: !155 !161 !168 !183 !271 !280 !288
- ePort threads only; no book or skill source
