---
name: strong-connascence
family: Design (books)
tags: [any]
evidence: 0 accepted ePort threads
---
# Strong connascence

## Index line
Two places must agree on position, algorithm, execution order, timing, or identity where a name or type would do.

## What to look for
- Position: a caller and a callee must agree on the order of several same-typed parameters, tuple elements, or array slots where the index carries meaning.
- Algorithm: two components must run the same computation to interoperate, and nothing shares it. An encoder and its decoder, a hash computed on both sides, a sort order both assume, a key derivation repeated in two places.
- Execution order: one call must happen before another, and nothing at the type or API level enforces it. Initialize before use, set before send, register before dispatch.
- Timing: correctness depends on how long something takes, on two async operations finishing in a given order, or on updates being applied in a given order.
- Values: several values across modules must change together with no single write path.
- Identity: two components work only when they hold the same instance of a shared mutable object.
- The coupling crosses a module, package, or service boundary, where the same coupling inside one module would be tolerable.
- The diff raises the degree: a third or fourth place now has to agree.
- Dynamic connascence where static would do: a runtime check or a comment stands in for something the type system could enforce.
- A convention documented in a comment that callers must follow, rather than an API shape that makes it the only option.

## Why it matters
- Strong connascence means a change in one place breaks another with no compile error and no test that names the link.
- Dynamic connascence shows up only at runtime, often in production.
- Coupling across boundaries spreads into every consumer. Coupling inside a module stays with one owner.
- Raising the degree multiplies the places that must be found and changed together.

## What not to flag
- Connascence of name and type. Callers using a function's name and typed parameters is the goal, not a problem.
- Strong connascence inside one function or one small module with one owner.
- Positional parameters in short helpers with distinct types.
- Order enforced by the API shape: a constructor that takes what initialization needs, a builder whose type changes with each step.
- Framework-mandated ordering with a lint rule that enforces it.
- Parallel lists and copies that must match by value: that is single-source-of-truth. Raw literals both sides interpret: that is magic-values.
- A long parameter list as such: that is data-clumps-and-long-parameter-lists.

## Severity
- must fix: execution-order or timing connascence across a boundary that the diff adds and nothing enforces; identity coupling to a shared mutable instance across modules.
- should fix: position or algorithm connascence across modules; raising the degree beyond two places.
- nit: local position coupling; a documented convention inside one module.

## Remedies
- replace position with named fields
- move the shared algorithm into one module both sides call
- enforce the order through the API, so the wrong order does not compile
- replace timing with explicit sequencing
- collapse coupled values into one write path, or move the coupled parts into one module

## Related
- data-clumps-and-long-parameter-lists: the parameter list. Position coupling beyond parameters belongs here.
- single-source-of-truth: values that must match by hand.
- magic-values: literals both sides interpret.
- information-leakage: a design decision known by several modules. This candidate covers the form of the coupling and whether a weaker form would do.
- duplicated-logic: the same code in two places. Here the point is two sides that must compute the same thing to interoperate.
- state-transition-integrity: ordering of writes in a state machine.
- react-state-and-effects: effect ordering in React.

## Sources
- ePort: none
- Fundamentals of Software Architecture ch. 3: connascence (strength, locality, degree)
