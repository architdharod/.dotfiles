---
name: complexity-pushed-to-callers
family: Design (books)
tags: [any]
evidence: 0 accepted ePort threads
---
# Complexity pushed to callers

## Index line
A module leaves cases, defaults, or call ordering to every caller when it could handle them once itself.

## What to look for
- A new function, hook, or component makes every caller pre-check, sort, validate, or format its input before the call, when it could do that once inside.
- A configuration parameter is exposed to callers although the module has enough information to pick a good default, so each caller guesses the same value.
- A step that must happen before or after every call (acquire and release, open and close, load and mark stale) is left to callers instead of wrapped by the module.
- A helper returns raw or partial data and each caller finishes the job: the same filter, the same mapping, the same missing-value handling at every call site.
- Several methods or options must be called in a fixed order, or flags only make sense in combination, and no single method covers the common case.
- A shared module is specialized to one caller: its parameters, shapes, and cases mirror that caller's screen or flow, and the next caller will need a variant.
- Callers must know the module's internals to use it correctly: which error to catch, which field to reset, what state the previous call left behind.
- A boolean or mode parameter is added so one caller can switch off part of the module's work, when the module could detect the case itself.
- Several entry points exist for near-identical jobs and differ only in a detail the module could take as data.
- A hook or helper leaves a correctness step optional, so a caller can forget it. Making the input required removes that class of mistake.

## Why it matters
- Complexity handled once inside a module is handled many times outside it, and each caller is a chance to get it wrong.
- Special-purpose interfaces multiply because each new caller needs its own variant.
- Callers coupled to the module's internal ordering break when the module changes.

## What not to flag
- Parameters that vary per caller and that the module cannot decide: business inputs, identity, the target of an action.
- A general interface that would have to guess a policy the caller owns (what to do on conflict, how long to wait) when callers legitimately differ.
- Thin adapters at a boundary that keep the module free of one framework's types.
- A module the diff only calls. Flag interfaces the diff adds or changes.
- A private helper with one caller in the same file. Generality is not owed before a second caller exists.
- Call orders a framework imposes (lifecycle hooks) that the module cannot wrap.

## Severity
- must fix: a required step left to callers where forgetting it corrupts state or leaks a resource.
- should fix: pre-processing or defaults repeated at every call site; a fixed call order with no combined method; one-caller specialization on a shared module.
- nit: a mode flag that could be a default while there is one caller.

## Remedies
- pull the check or default into the module
- wrap the fixed sequence in one method
- make the input required so callers cannot skip the step
- generalize the interface to the common case and drop the variants
- take the varying detail as data

## Related
- shallow-abstractions: a wrapper that does too little. Here an interface that asks too much of callers.
- define-errors-out-of-existence: errors callers must handle that the API could define away.
- duplicated-logic: the same code at several call sites, whatever the cause.
- wrong-home: where code sits. Here what the interface asks of callers.
- layer-abstraction-mismatch: pass-through layers that add nothing.
- data-clumps-and-long-parameter-lists: parameters that always travel together.
- speculative-generality: generality for a need nobody has. The line is whether a second caller exists or is in the MR's scope.

## Sources
- ePort: none
- A Philosophy of Software Design (Ousterhout): ch. 6 general-purpose modules are deeper, ch. 7 different layer different abstraction, ch. 8 pull complexity downwards
