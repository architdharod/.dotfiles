---
name: incomplete-propagation
family: Structure
tags: [any]
evidence: 15 accepted ePort threads
---
# A change reached some siblings but not all

## Index line
A change reached some siblings (routes, schemas, docs, tests, list members) but not all of them.

## What to look for
- Take every rename, removed value, new field, and changed contract in the diff. Search the whole repo for the old name or the old rule: comments, docs, stories, example values in schemas, log and monitoring tags, test titles, file headers.
- A new field, option, tooltip, or treatment added to some sibling branches or states but not to the resting, terminal, or negative ones.
- A new authoritative field replaces an old check on some paths while another path still trusts the old check or a caller-supplied value.
- A prefix, wrapper, or format is now applied at the source while one call site still applies it, so it happens twice.
- Sibling schemas for the same field disagree on optional versus required after the change.
- A description or doc updated for one sibling route while the same change touched its siblings.
- A doc or glossary updated for one fact while the MR changed several documented facts.
- A list that names some members of a set and leaves the rest. List all or none.
- A helper method omits the note or contract its sibling carries for the same case.
- A message mapping where one entry was left describing the old condition after the codes changed.

## Why it matters
- The missed spot is the one that breaks: a path still trusting the old field, a value prefixed twice, two schemas that reject each other's data.
- Stale names in docs, stories, and tags send the next reader to a symbol that no longer exists.
- Half-applied changes look finished, so nobody comes back for the rest.

## What not to flag
- Siblings left out with a stated reason, or where the change does not apply because the sibling's data or state differs.
- Old names in migrations, changelogs, or other historical records that must keep their original text.
- Generated files that are rebuilt from the source the diff changed.
- A repo-wide pattern the MR did not introduce. Stop at the change's own siblings; do not demand a migration of the whole codebase.
- A comment or doc that is wrong on its own, without the diff having changed the same fact elsewhere. That is text-disagrees-with-code.

## Severity
- must fix: a missed sibling changes behavior: a path still on the old field, a double-applied wrapper, sibling schemas that disagree.
- should fix: docs, stories, tags, or tests still name the old thing or describe the removed behavior.
- nit: an example value or a comment in a place nothing reads.

## Remedies
- search the repo for the old name and fix every hit
- apply the change to every sibling in the set
- move the fact into one shared definition so the next change is one edit
- complete the list or drop it

## Related
- text-disagrees-with-code: the text is wrong by itself; here the diff changed the fact elsewhere and missed this spot.
- single-source-of-truth: the fix when the same fact is hand-maintained in several places.
- closed-set-exhaustiveness: a map over a closed set is not exhaustive; here a change to the set skipped a member.
- error-messages-and-codes: the message names the wrong condition on its own; here a mapping was left behind by a change.
- mirror-case-gaps: one direction of a rule is missing, not one sibling of a change.
- blast-radius: the change touched flows it should not have; here it missed flows it should have.

## Sources
- ePort: !14 !38 !56 !131 !144 !157 !183 !233 !259 !274 !288 !297
- Fowler, Refactoring: shotgun surgery
