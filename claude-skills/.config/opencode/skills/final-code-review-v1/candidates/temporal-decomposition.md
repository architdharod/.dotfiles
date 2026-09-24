---
name: temporal-decomposition
family: Design (books)
tags: [any]
evidence: 0
---
# Modules split by when they run, not by what they know

## Index line
Modules or steps split by when they run, so two of them must know the same format or rule.

## What to look for
- New modules, files, or functions named after the phase they run in rather than the knowledge they own.
- Two units on opposite sides of a phase split that both encode the same format, field layout, encoding, or ordering rule. Changing the format means changing both.
- A pipeline where the output of an early step is a loosely typed intermediate that a later step must interpret again, using the same rules the early step used to produce it.
- A prepare unit and a matching finish or cleanup unit that must agree on what was prepared, with nothing shared between them but convention.
- Serialization in one unit and the matching parse in a unit that is not its twin, so the two can drift apart.
- Handlers for the start and the end of a process that each hard-code the same constants, keys, or shape assumptions.
- A UI flow split into one hook or handler per lifecycle moment, where each re-derives the same knowledge about the data.
- The diff adds a step to a phase-ordered chain and must also touch a sibling phase to keep a format in sync.
- A unit whose only reason to be separate is that it runs at a different time, and whose interface is a bag of everything the next unit needs.

## Why it matters
- Knowledge held in two places changes in two places. One update is forgotten and the format drifts.
- Phase-shaped modules are shallow. Each has a wide interface, everything the next phase needs, and little logic of its own.
- The reader must read the whole chain to learn how one piece of data is treated.

## What not to flag
- A pipeline where each stage owns its own knowledge and the interface between stages is small and typed. Order is fine when it is not the only reason for the split.
- A split by phase that the framework imposes: route loaders, lifecycle hooks, middleware order. Flag only knowledge that leaks across it, if any.
- Straight-line code inside one function that reads, then transforms, then writes. This candidate is about module boundaries, not statement order.
- Two units that share a type or a schema through a single owner. Shared knowledge reached through one import is not leakage.
- Duplicated logic with no phase relationship. That is duplicated-logic.
- A decision known in several modules for a reason other than phase ordering. That is information-leakage.

## Severity
- must fix: only when the leak has already produced a mismatch the diff shows.
- should fix: the diff creates a new phase split whose two sides encode the same format or rule.
- nit: the diff extends an existing phase split and a merge would be easy.

## Remedies
- merge the phases that share knowledge into one module
- move the shared format into one owner and have both phases call it
- replace the intermediate with a typed value that carries its meaning
- split by knowledge, not by time

## Related
- information-leakage: the same decision known in several modules, for any reason. This candidate is the phase-ordered cause.
- together-or-apart: code that belongs together, split. This candidate is the specific case of splitting by time.
- duplicated-logic: identical code in two places, regardless of phase.
- shallow-abstractions: phase modules tend to be shallow. Flag the shallowness there.
- strong-connascence: two places that must agree on execution order or an algorithm.

## Sources
- review threads: none (seed only)
- A Philosophy of Software Design, ch. 5 (information hiding; temporal decomposition)
