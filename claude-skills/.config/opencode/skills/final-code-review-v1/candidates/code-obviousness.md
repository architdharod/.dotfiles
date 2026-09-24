---
name: code-obviousness
family: Design (books)
tags: [any]
evidence: 0 accepted ePort threads
---
# Code a reader cannot follow without deep study

## Index line
Code a reader cannot follow without deep study: unlabeled tuples, hidden control flow, surprising side effects, dense expressions.

## What to look for
- A tuple, pair, or positional array used for specific data, so the reader must know what each position means. Return values destructured by position are the usual case.
- A string-keyed record or generic container that holds a fixed set of known fields. A typed object with named fields says what it holds.
- Control flow that runs through events, emitters, subscriptions, or registered callbacks, so a reader cannot find who runs after whom by reading in order.
- A function that mutates its argument, writes shared state, or fires a request, while its name and signature promise a plain computation.
- A boolean or positional argument whose meaning is invisible at the call site.
- A compact expression that must be expanded in the head: nested conditional expressions, a fold whose accumulator changes shape, a regular expression with no name or comment.
- An order dependency between calls that nothing enforces or states. A unit that only works if another ran first.
- Logic that depends on module-level or global state the call site does not show.
- Unrelated statements interleaved in one block, or a long block with no blank lines between its steps.
- Code that needs a comment to be understood, when a change to the code would make the comment unnecessary.

## Why it matters
- A reader who cannot tell what code does guesses. Guesses are wrong often enough to cause bugs.
- Hidden control flow cannot be traced during an incident.
- Positional data breaks silently when a position is added or reordered.

## What not to flag
- Whether a name is accurate. That is naming.
- A missing explanation of why. That is missing-why-comment. Flag here only when the code, not a comment, is the fix.
- Long or deeply nested conditionals. That is convoluted-control-flow.
- A scalar that should carry a domain type. That is primitive-obsession.
- Event-driven flow the framework imposes, when handlers are small and named for the event.
- Positional tuples returned by library hooks or APIs where that shape is the stack's documented convention.
- Idioms the codebase uses throughout, which a reader of this repo is expected to know.
- Density in a hot path that a comment explains and a measurement justifies.

## Severity
- must fix: side effects that contradict the signature, or a hidden order dependency the diff relies on.
- should fix: positional tuples or string-keyed containers for specific data; hidden control flow the diff adds; boolean arguments with invisible meaning.
- nit: dense expressions and block layout.

## Remedies
- replace the tuple with a named object
- replace the boolean argument with an options object or two functions
- make the call order explicit, or merge the steps
- unnest the expression into named steps
- move the side effect out, or rename to admit it

## Related
- naming: whether the name is right. Here, the code surprises a reader who trusts the name.
- missing-why-comment: a why that only a comment can give.
- convoluted-control-flow: branching structure. Here, density and hidden meaning.
- primitive-obsession: scalars with domain meaning. Here, structures whose slots have unstated meaning.
- strong-connascence: two places that must agree on order or algorithm. Here, the order is hidden from the reader of one place.
- imprecise-types: a type wider than the value the code relies on.
- data-clumps-and-long-parameter-lists: values that travel together. Here, the meaning of each slot.

## Sources
- ePort: none
- A Philosophy of Software Design, ch. 18 (code should be obvious)
