---
name: dead-code-and-export-surface
family: Structure
tags: [any]
evidence: 32
---
# Dead code and export surface

## Index line
Unused exports, functions, props, no-op statements, commented-out code, and exports that exist only for tests.

## What to look for
- An exported function, type, interface, constant, or component that no other file imports. Search the repo for each new export. A type used only in its own file should not be exported.
- A function, method, variable, prop, or parameter that nothing calls, sets, or reads. Include definitions the diff orphans by removing their last caller.
- An export that exists only so a test can import it. Keep it private and test through the public surface, or redeclare the value in the test.
- A package entry point that exports a whole folder instead of the members consumers need.
- A statement with no effect on its path: a reset where nothing was set, a normalization already applied upstream, a second import from the same module, a framework attribute copied onto a component that nothing reads.
- Commented-out code, a rejected alternative implementation, or a definition kept in case it is needed later.
- Code kept for a migration or a future consumer that does not exist in this MR.
- A branch or fallback that an earlier check already makes unreachable.
- Two entry points for one action where one duplicates the other with a hard-coded mode.
- Header lines or boilerplate comments carried over from a generator that the repo strips from its own copies.
- The diff deletes an import or directive that looks unused. Check that no tool, type check, or story build relies on it before agreeing.

## Why it matters
- Dead code still gets read, typed, searched, and maintained. Readers assume it is load-bearing.
- Every export widens the public surface, so later changes must treat it as a contract.
- Test-only exports couple tests to internals and hide that the code has no real consumer.
- No-op statements and unreachable branches mislead readers about what can happen at runtime.

## What not to flag
- Imports, side-effect imports, or directives a tool needs (type check, stories, lint, a framework convention), even when nothing in the file references them.
- Exports a package publishes on purpose for consumers outside the repo, when the repo documents that surface.
- Exports a framework loads by convention: route modules, config files, default exports.
- Parameters an interface or callback signature requires even when this implementation ignores them.
- Dead code that existed before the diff and that the diff does not touch or orphan.
- A helper with a real second consumer that belongs in a shared home. That is wrong-home, not dead code.

## Severity
- must fix: a dead endpoint, route, or service method left reachable; a rejected implementation left in the tree; a deletion that breaks a tool dependency.
- should fix: unused exports and test-only exports; functions, props, or parameters nothing uses; commented-out code; a whole folder exported.
- nit: duplicate imports, no-op statements, generator header lines.

## Remedies
- delete the code
- drop the export and keep the member module-private
- test through the public surface
- redeclare the constant in the test
- narrow the package entry point to what consumers need

## Related
- wrong-home: a helper with a second consumer should move rather than lose its export.
- type-runtime-contradiction: a guard for a case the type forbids.
- duplicated-logic: two implementations that both have callers.
- speculative-generality: parameters and abstractions built for a future need. This candidate covers the plain unused definition.
- text-disagrees-with-code: a doc or comment that still cites the removed code.
- scope-and-requirements: stubs and placeholder behavior shipped on purpose.

## Sources
- review threads: 32 accepted change requests from real code reviews
- code-reviewer skill: unnecessary type exports
