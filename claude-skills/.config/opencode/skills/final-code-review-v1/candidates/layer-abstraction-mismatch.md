---
name: layer-abstraction-mismatch
family: Design (books)
tags: [any]
evidence: 0 accepted ePort threads
---
# Layer abstraction mismatch

## Index line
Adjacent layers that expose the same abstraction: pass-through methods, decorators that add nothing, threaded variables.

## What to look for
- A chain of two or more layers where each method has the same name, the same parameters, and the same return type as the one it calls, and does nothing else.
- A new service, hook, client, or repository whose public surface mirrors the layer below it one to one.
- A wrapper class or decorator that re-exposes most of the wrapped interface to add one small thing. Ask whether the small thing belongs in the wrapped class or in the caller.
- A parameter accepted by several functions only to be handed down to a callee, with none of the intermediate functions reading it.
- Two adjacent layers that use the same vocabulary for their operations, so a reader cannot tell what each layer adds.
- A subclass or extension that overrides methods only to call the parent with the same arguments.
- A hook that wraps a client method and returns it unchanged.

## Why it matters
- Each pass-through layer is a second copy of an interface. A signature change now touches every layer.
- Readers cannot tell where the real work happens and step through layers that do nothing.
- Threaded variables couple every intermediate function to a value it never uses. Adding one more means editing the whole chain.

## What not to flag
- A dispatcher that chooses among several methods with the same signature. Choosing is its job.
- Several implementations of one interface with the same signatures. That is polymorphism, not pass-through.
- A layer that changes the abstraction: it maps errors, validates, retries, caches, converts units, or narrows the interface.
- A framework-required entry point that only forwards, when the framework gives it no other job and every sibling looks the same.
- A wrapper that hides a third-party API behind the project's own names on purpose, unless it mirrors the third party one to one.
- A variable threaded through one or two hops. Flag it at three or more, or when the diff adds another hop.

## Severity
- must fix: rarely. Raise when a new layer doubles every signature in a busy area and the diff adds no other value there.
- should fix: a new pass-through layer or decorator, or a variable threaded through several functions.
- nit: one pass-through method with a single caller.

## Remedies
- expose the lower layer's method directly to callers
- merge the two layers into one
- move real work into the pass-through layer so it earns its place
- pass a context object instead of threading the variable
- store the value on an object that already travels the chain

## Related
- shallow-abstractions: a single thin wrapper, element, endpoint, or helper goes there. A stack of layers repeating one interface, and threaded variables, are here.
- wrong-home: re-exports and barrels added for one consumer go there.
- data-clumps-and-long-parameter-lists: values that always travel together go there. A value threaded through functions that never read it is here.
- complexity-pushed-to-callers: interfaces too special-purpose go there.
- speculative-generality: a layer added for a future need goes there. A layer that adds nothing today is here.
- dead-code-and-export-surface: layers with no caller go there.

## Sources
- ePort: none
- A Philosophy of Software Design, chapter 7: different layer, different abstraction
