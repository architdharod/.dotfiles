---
name: final-code-review-v1
description: Candidate-based review of a local git diff against a base branch. Runs one read-only helper agent per review candidate (74 candidates distilled from accepted requests in real code reviews and from design books), verifies every finding with a second agent, and reports only what to change, sorted by severity. Use when the user asks to review a branch, MR, or diff, or invokes /final-code-review-v1.
---

# Final code review v1

One helper agent per candidate. A candidate is one review concern. Helpers only judge code. A verifier checks every finding. The report holds only things to change.

## Arguments

`/final-code-review-v1 [base] [auto|all] [model] [N]`

- `base`: branch to diff against. Default `dev`.
- `auto`: pick the candidates the diff can plausibly violate, show the pick, run after OK. `all`: run every candidate whose tags match the diff.
- `model`: `sonnet`, `opus`, `fable`, or `haiku` for helper and verifier agents. Default: the session model.
- `N`: how many agents run at the same time. Default 8.

Effort: helpers use the session effort. Tell the user to set `/effort` first if they want a different level. When arguments are missing, ask once with AskUserQuestion: at most two questions, defaults as the recommended option. To review someone else's MR, the user checks the branch out first, for example with `glab mr checkout <iid>` or `gh pr checkout <n>`.

## Paths

- `<skill>` = the directory of this file.
- `<work>` = `<scratchpad>/review-<branch>` where `<scratchpad>` is the session scratchpad directory, or a fresh temp directory when the session lists none. Replace `/` in the branch name with `-`. Create it.
- Only committed changes are in the diff. If the working tree is dirty, tell the user to commit or stash first.

## Flow

1. **Prepare.** From inside the repo (any subfolder works), run `bash <skill>/scripts/prepare-review.sh <base> <work>`. It writes `diff.patch`, `files.txt`, `tags.txt`, `rules.txt`, and `summary.txt` and prints the summary. Stop and tell the user when the diff is empty or the base branch is missing.
2. **Pick candidates.** Read `<work>/summary.txt` and the index below. Do not read candidate files; the helpers do.
   - `all`: every candidate whose tags include `any` or share a tag with `tags.txt`. Note the skipped ids.
   - `auto`: choose the candidates the diff can plausibly violate, from the index lines and the file list. Show the list in one AskUserQuestion (options: run this list, or edit). Run after OK.
3. **Run helpers.** For each chosen candidate, one Agent call: `subagent_type` general-purpose, `model` as chosen. The prompt is `<skill>/prompts/candidate-agent.md` with every `{{PLACEHOLDER}}` filled: `CANDIDATE_ID`, `CANDIDATE_FILE` (`<skill>/candidates/<id>.md`), `DIFF_FILE`, `FILES_LIST`, `BASE`, `REPO_ROOT`, `RULE_FILES` (the lines of `rules.txt`, or `none`), `OUT_FILE` (`<work>/findings/<id>.json`). Launch N agents per message. When one returns, launch the next, until every candidate ran. Do not read the findings files yet.
4. **Merge.** `python3 <skill>/scripts/merge-findings.py <work>/findings <work>/merged.json`. It prints one line per merged finding.
5. **Verify.** For each merged finding, one Agent call, N at a time, same model. The prompt is `<skill>/prompts/verifier-agent.md` with `FINDING_ID`, `FINDING_JSON` (the object from `merged.json`), `CANDIDATE_FILE` (the first candidate in its list), `DIFF_FILE`, `BASE`, `REPO_ROOT`, `OUT_FILE` (`<work>/verdicts/<id>.json`).
6. **Report.** `python3 <skill>/scripts/assemble-report.py <work>/verdicts <branch> <base> <run> 74 "<skipped ids or none>" <work>/report.md`. Then invoke the humanizer skill on the report text: keep every fact and number, cut filler, plain words. Save the result to `<work>/report.md`. Print the report in chat, then the path on its own line. Format rules: `<skill>/prompts/report-format.md`.

## Rules for the orchestrator

- Never review the diff yourself. You route, merge, and report.
- Keep helper output out of your context. Helpers write files and reply with one line.
- Helpers and verifiers are read-only. The prompt templates say so. Do not weaken that.
- Do not add findings of your own. Do not drop or soften a confirmed finding. Do not add praise, FYIs, or "this passed" lines.
- If a helper fails or returns nothing, rerun it once. Then note the candidate as "not run" in the report's first line.

## Candidate index

Details live in `candidates/<id>.md`. Read one only when the user asks about it. `evidence` is the number of accepted change requests from real code reviews behind the candidate; 0 means it comes from a book or an earlier skill.

<!-- INDEX:START -->
| candidate | family | tags | evidence | looks for |
|---|---|---|---|---|
| `blast-radius` | Structure | any | 12 | A shared-code change alters flows the MR did not target, removes unrelated behavior, or deletes what planned work needs. |
| `closed-set-exhaustiveness` | Structure | any | 6 | Maps and branches over a closed set that compile with a member missing; assumed invariants nothing enforces; misclassified members. |
| `convoluted-control-flow` | Structure | any | 2 | Dense compound conditions, branchy reassignment chains, and one-off special cases bolted onto shared paths. |
| `dead-code-and-export-surface` | Structure | any | 32 | Unused exports, functions, props, no-op statements, commented-out code, and exports that exist only for tests. |
| `duplicated-logic` | Structure | any | 23 | The same non-trivial logic exists in two places, or a new helper re-implements one the repo already has. |
| `file-and-code-organization` | Structure | any | 12 | Files that mix scopes or are misnamed for their content, entry points buried under helpers, related derivations scattered. |
| `incomplete-propagation` | Structure | any | 15 | A change reached some siblings (routes, schemas, docs, tests, list members) but not all of them. |
| `magic-values` | Structure | any | 5 | Inline numbers, strings, and lists where a named constant, enum member, or shared export exists or should. |
| `missed-simplification` | Structure | any | 0 | A reframing exists that deletes whole branches, modes, flags, layers, or state while keeping behavior. |
| `naming` | Structure | any | 25 | Names that collide, mislead, overclaim or underclaim, say only the type, abbreviate, or break the sibling pattern. |
| `oversized-units` | Structure | any | 0 | A function or file grows past a healthy size while a clean split into smaller units is available. |
| `precedent-divergence` | Structure | any | 27 | A new case is wired its own way although a sibling already solves the same problem with an established pattern. |
| `reinvented-library-feature` | Structure | web, shared-ui, api | 10 | A UI primitive or library feature hand-built, worked around, miscomposed, or copied and drifting, although the library provides it. |
| `shallow-abstractions` | Structure | any | 13 | Wrappers, pass-through functions, extra files, and machinery that add parts without adding clarity. |
| `single-source-of-truth` | Structure | any | 18 | One fact, list, type, or fixture kept by hand in two places, or one constant serving two rules. |
| `wrong-home` | Structure | any | 33 | Code sits in a layer or module that does not own it, including one-consumer re-exports and downstream workarounds. |
| `ambiguous-result-shapes` | Types | any | 5 | Results or states whose outcome is encoded by absence or by several booleans instead of a tagged union. |
| `imprecise-types` | Types | any | 12 | Casts, wide types, or annotations where a schema, enum, or inference already gives the precise type. |
| `type-runtime-contradiction` | Types | any | 5 | Guards for cases the type forbids, or types that promise what the runtime does not deliver. |
| `absence-conflation` | Correctness | any | 14 | One value stands for empty, missing, failed, unsupported, or not found, or a fallback masks missing data. |
| `authorization-checks` | Correctness | api, web | 6 | A mutating route lacks its role or ownership check, a privileged role bypasses checks, or the client duplicates server auth. |
| `batch-failure-isolation` | Correctness | api, web | 5 | One failing item aborts, discards, or starves a whole batch of independent items. |
| `data-model-and-migrations` | Correctness | db, schemas, api | 10 | Migrations unsafe on a live database, missing rollout steps, model and database out of step, old stored shapes ignored. |
| `error-messages-and-codes` | Correctness | api, web | 8 | Error codes, messages, and status classes that name the wrong condition, have no client mapping, or misclassify the fault. |
| `error-reporting-hygiene` | Correctness | api, web | 4 | Error reports that fire twice, lack the ids needed to act, or attach context in the wrong slot. |
| `external-writes-and-retries` | Correctness | api, web, db | 7 | Non-idempotent external writes a client can retry, dedup that misses a source, full updates where a partial update exists. |
| `guards-from-wrong-or-partial-sources` | Correctness | api, web | 17 | A guard or derived state reads a proxy fact or only some sources, or runs where it cannot hold. |
| `mirror-case-gaps` | Correctness | any | 8 | A sync, reconciliation, guard, or test handles one direction of a symmetric pair and forgets the other. |
| `outcome-signaling` | Correctness | any | 9 | Partial failure reported as success, distinct outcomes merged into one signal, recovery paths that leave no trace. |
| `scope-and-requirements` | Correctness | any | 16 | Stubs, deferred hard requirements, and behaviour that contradicts the ticket, the design, or the reference system. |
| `state-transition-integrity` | Correctness | api, db | 12 | A write moves an entity to a new state without checking preconditions, claiming it atomically, or finishing the lifecycle. |
| `validation-boundaries` | Correctness | api, web, schemas | 15 | Validation or normalization that another path skips, differs from the shared schema, or never reaches external input. |
| `value-comparison-pitfalls` | Correctness | any | 3 | Dates crossing UTC and local boundaries, structured values compared as raw strings, comparators that return NaN or hide null handling. |
| `accessibility` | Frontend | web, shared-ui | 9 | Missing or constant accessible names, color-only status, invalid states without a visible reason, lost focus or keyboard reach. |
| `data-loading-wiring` | Frontend | web | 9 | Wrong wiring between routes, queries, mutations, and components, so data arrives late, stale, borrowed, or after access is gone. |
| `layout-robustness` | Frontend | web, shared-ui | 7 | Layout that breaks with real copy, other viewports, or overflow, or visibly departs from the design. |
| `query-cache-and-keys` | Frontend | web | 10 | Query keys, staleness, refetch, invalidation, and shared option factories set without regard to siblings or consumers. |
| `react-state-and-effects` | Frontend | web, shared-ui | 5 | List keys, state placement, remount hacks, effect scope, and cleanup against React rules; transient UI state in the URL. |
| `shared-ui-component-contracts` | Frontend | shared-ui, web | 5 | Shared components that break caller styling, bake in call-site details, or lack a story reaching each state. |
| `ui-state-fidelity` | Frontend | web, shared-ui | 10 | What the user sees does not match the state: labels, empty states, duplicates, scope, raw values, pending feedback, routing. |
| `e2e-selectors` | Tests | e2e, tests | 5 | E2E locators coupled to DOM nesting, translated copy, live counts, or page-wide scope instead of stable, scoped hooks. |
| `missing-test-cases` | Tests | tests | 24 | A decision, guard, boundary, or closed-set member ships with no test that fails when it is removed or mutated. |
| `test-fixtures-and-setup` | Tests | tests, e2e | 16 | Fixtures too thin, unrealistic, or too broad; costly resources rebuilt per test; teardown that skips on failure. |
| `test-wiring-and-layer` | Tests | any | 9 | A unit is tested but its call site is not, or tests run at a layer without asserting its contract. |
| `weak-or-tautological-assertions` | Tests | tests, e2e | 22 | Tests that stay green when the code is wrong: existence-only, path-only, same-source, or partial assertions, and repeated neighbours. |
| `docs-scope-and-durability` | Text | docs | 7 | Docs that snapshot a moment, copy from code, record routine choices formally, or define terms outside their scope. |
| `missing-why-comment` | Text | any | 17 | Non-obvious decisions, asymmetries, matchers, contracts, suppressions, and dependencies with nothing near the code saying why. |
| `needless-or-transient-comments` | Text | any | 14 | Comments that restate the obvious, cite transient facts, leak the author's workflow, list callers, or use docblock syntax on nothing. |
| `text-disagrees-with-code` | Text | any | 36 | Comments, docs, API descriptions, or UI copy that contradict the code or omit a constraint it enforces. |
| `writing-style` | Text | any | 0 | Comments, docs, and MR text that read like generated prose: puffed up, padded, generic, or hedged instead of plain. |
| `ci-config-and-dependencies` | Process | ci, config | 14 | CI jobs without needs, timeouts, or retries; checks that skip files; floating versions; ad-hoc dependency hosts; wrong config; warnings. |
| `performance` | Process | any | 5 | Per-item lookups in loops, serialized independent work, unbounded queries, avoidable re-renders, heavy imports in hot paths. |
| `project-rule-conformance` | Process | any | 13 | Read the repo's own rule files at run time and check the diff against every rule they state. |
| `security-basics` | Process | any | 0 | Injection, leaked secrets, authorization from client-supplied data, PII or tokens in logs, open redirects, missing rate limits. |
| `any-leakage` | Design (books) | any | 0 | any or un-narrowed unknown in signatures, fields, or state, so type errors move to runtime; narrow at the boundary. |
| `code-obviousness` | Design (books) | any | 0 | Code a reader cannot follow without deep study: unlabeled tuples, hidden control flow, surprising side effects, dense expressions. |
| `complexity-pushed-to-callers` | Design (books) | any | 0 | A module leaves cases, defaults, or call ordering to every caller when it could handle them once itself. |
| `data-clumps-and-long-parameter-lists` | Design (books) | any | 0 | Several values that always travel together as separate parameters or fields, or parameter lists that keep growing. |
| `define-errors-out-of-existence` | Design (books) | any | 0 | An error is thrown or returned for a case the API could define away, so callers carry needless handling. |
| `dependency-direction` | Design (books) | any, config | 0 | Imports that cross an architecture boundary the wrong way, or boundaries with no automated check. |
| `derived-state-and-effect-sync` | Design (books) | web, shared-ui | 0 | State computable from props or other state is stored or synced by an effect; effects do handler work. |
| `divergent-change` | Design (books) | any | 0 | One module keeps changing for unrelated reasons, and the diff adds one more reason to it. |
| `exception-aggregation` | Design (books) | api, web | 0 | One error class handled at many sites, or caught far from the level that understands it; handle each class once. |
| `feature-envy` | Design (books) | any | 0 | A function that works mostly on another module's data and belongs next to that data. |
| `information-leakage` | Design (books) | any | 0 | A format, layout, protocol, or ordering decision known by several modules, so one change touches all of them. |
| `layer-abstraction-mismatch` | Design (books) | any | 0 | Adjacent layers that expose the same abstraction: pass-through methods, decorators that add nothing, threaded variables. |
| `manual-memoization` | Design (books) | web, shared-ui | 0 | Manual memoization where the React compiler already handles it, without a documented exception and a reason comment. |
| `message-chains` | Design (books) | any | 0 | Code walks a chain of objects or optional fields to reach a value, so it depends on the whole path. |
| `primitive-obsession` | Design (books) | any | 0 | Plain strings and numbers carrying domain meaning where a union, enum, or branded type would stop mix-ups. |
| `repeated-conditionals-on-type` | Design (books) | any | 0 | The same switch or if-chain on a type, status, or kind appears in several places instead of one dispatch. |
| `speculative-generality` | Design (books) | any | 0 | Parameters, options, abstractions, or extension points added for a future need that no present caller has. |
| `strong-connascence` | Design (books) | any | 0 | Two places must agree on position, algorithm, execution order, timing, or identity where a name or type would do. |
| `temporal-decomposition` | Design (books) | any | 0 | Modules or steps split by when they run, so two of them must know the same format or rule. |
| `together-or-apart` | Design (books) | any | 0 | Related code split across modules, or unrelated code fused into one module because it was written together. |
<!-- INDEX:END -->
