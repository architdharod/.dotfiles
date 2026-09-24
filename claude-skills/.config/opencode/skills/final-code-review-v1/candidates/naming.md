---
name: naming
family: Structure
tags: [any]
evidence: 25 accepted ePort threads
---
# Names that mislead, collide, or break the pattern

## Index line
Names that collide, mislead, overclaim or underclaim, say only the type, abbreviate, or break the sibling pattern.

## What to look for
- A name that claims a scope, filter, or result the code does not apply, or the reverse: a name narrower than what the code does. A check whose name does not say what it covers or leaves out counts too.
- A name that promises one shape or kind of thing and delivers another. A composite named as if it were a single item.
- A name that states only the type or the return type, not what is resolved, chosen, or computed, and not the fallback.
- A name that states a downstream effect instead of the fact the value holds. The reader should not need the ticket to understand it.
- A generic name on something built for one specific use, above all when it sits in a shared location. It invites reuse where it does not fit.
- A name that borrows a term the framework or the domain already uses for something else.
- Two names for one concept, or one name for two different values in one scope. Shadowing of an outer variable by a parameter or destructured field counts.
- A new name that collides with an existing export or utility, so a reader or a search cannot tell them apart.
- A name that breaks the pattern its siblings follow: verb order, prefix, suffix, casing, plural or singular, or the order of parts in file names.
- A constant or key whose spelling does not mirror the value it stands for when every sibling does, so a search for the value misses it.
- Abbreviations in identifiers or comments where a full word would do.
- A comment whose job is to explain what a vague name means. The meaning belongs in the name.

## Why it matters
- A misleading name is trusted without reading the body. The caller assumes behaviour the code does not have.
- Names are the main search key. Collisions and non-mirrored keys hide usages from readers and from grep.
- Generic names in shared places get reused where they do not fit, and a workaround spreads.
- Sibling patterns let readers guess a name without looking. Each break costs a lookup.

## What not to flag
- Names that follow a convention the repo's rule files state, even if another choice reads better. Rule conformance is checked elsewhere.
- Short names for short-lived locals, loop indexes, and callback parameters whose meaning is clear from the line they sit on.
- Abbreviations the codebase already uses throughout and the domain understands.
- A name that is accurate, matches its siblings, and does not collide, but is not the name a reviewer would pick.
- Names in code the diff does not touch, unless the diff changes what the thing does and the name no longer fits.
- A well-chosen name that still needs a comment on why. That is a comment concern.
- A bare literal with no name. That is magic-values. This candidate covers the name a value gets, not whether it gets one.

## Severity
- must fix: a name that claims a scope or result the code does not have, or collides with an existing export, so callers will misuse it.
- should fix: names that say only the type, generic names on specific things in shared places, two names for one concept, shadowing, breaks of the sibling pattern.
- nit: abbreviations, casing that lint does not catch, ordering of parts in sibling file names.

## Remedies
- rename to state the fact, not the effect
- rename to the scope the code actually has
- rename to match the sibling pattern
- merge the two names into one
- replace the explanatory comment with a better name

## Related
- magic-values: a literal with no name at all.
- missing-why-comment: a good name that still needs a why.
- wrong-home: a specific thing in a generic location. The generic name on it is this candidate.
- single-source-of-truth: two lists or enums for one set of values. Their differing names are this candidate.
- text-disagrees-with-code: a docblock that misstates what the code does.
- precedent-divergence: a new case wired unlike its siblings. Only the name is this candidate.
- dead-code-and-export-surface: an export that exists only so a test can reach it.
- project-rule-conformance: naming rules the repo states itself.

## Sources
- ePort: !32 !41 !45 !46 !50 !52 !54 !67 !75 !79 !85 !101 !155 !157 !161 !183 !233 !259 !271 !274 !291
- A Philosophy of Software Design, ch. 14 (choosing names)
