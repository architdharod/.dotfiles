---
name: dependency-direction
family: Design (books)
tags: [any, config]
evidence: 0
---
# Dependency direction

## Index line
Imports that cross an architecture boundary the wrong way, or boundaries with no automated check.

## What to look for
- First find the intended boundaries: workspace packages, top-level folders per layer, path aliases, lint rules on imports, and rule files that describe layers. Judge the diff against those, not against a layering you would prefer.
- An import from a lower layer to a higher one. Lower means persistence, domain, and shared utilities. Higher means route handlers, UI, and app wiring.
- A shared package importing from an app package, or from another package that depends on it.
- Client code importing a server-only module, or a module that pulls in server-only dependencies.
- A deep import that reaches past a package's public entry into its internal files.
- Two modules or packages that import each other, directly or through a third.
- A layer skipped when the architecture treats layers as closed: presentation calling persistence directly.
- Domain or core code importing a framework, a database client, or an HTTP client where the repo keeps the domain pure.
- Production code importing from test utilities or fixtures.
- A package using a module it does not declare as a dependency, which works only through hoisting.
- The diff adds a new package, layer, or boundary with no lint rule, dependency check, or package manifest that enforces it. Or the diff disables or excludes an existing check.

## Why it matters
- One wrong-way import makes the lower layer depend on everything above it. It can no longer be built, tested, or reused alone.
- Cycles make load order and initialization fragile and stop tree shaking and incremental builds.
- A boundary with no automated check erodes one import at a time, and nobody notices until a package cannot be split out.

## What not to flag
- Type-only imports of a shared contract that lives in the shared package by design.
- Dependency inversion done right: the lower layer declares an interface, the higher layer implements it and passes it in.
- Test files importing from anywhere.
- A repo with one package and no declared layers. Do not invent layers. Without evidence of an intended boundary there is nothing to cross.
- Open layers the architecture allows to be skipped, when a doc or rule says so.
- Framework conventions that fix the import direction for a specific file kind.
- A missing automated check in a repo that has never had one, when the diff adds no new boundary. Mention it as a nit at most.

## Severity
- must fix: a cycle, a shared package importing an app, or client code importing server internals.
- should fix: a wrong-way import within one app, a deep import past a public entry, or an undeclared dependency.
- nit: a new boundary with no automated check, or a type-only import that crosses the wrong way.

## Remedies
- move the shared piece down into the package both sides may import
- invert the dependency with an interface the lower layer owns
- import from the package's public entry
- declare the dependency in the package manifest
- add an import rule or dependency check for the boundary

## Related
- wrong-home: code placed in the wrong layer goes there. The import edge itself is here.
- layer-abstraction-mismatch: adjacent layers with the same abstraction go there. The direction of the dependency is here.
- ci-config-and-dependencies: versions, floating deps, and files excluded from lint go there. Boundary checks between the repo's own modules are here.
- project-rule-conformance: read the repo's rule files there. Use what they say about layers here.
- together-or-apart: where module boundaries should be goes there. Which way imports cross them is here.
- strong-connascence: two places that must agree on order or timing go there.

## Sources
- review threads: none (seed only)
- Fundamentals of Software Architecture, chapter 10: layered architecture; fitness functions
