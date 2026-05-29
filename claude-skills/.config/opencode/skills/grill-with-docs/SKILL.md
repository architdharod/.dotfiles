---
name: grill-with-docs
description: Intensive design review that challenges plans against the project's domain model and documented decisions (CONTEXT.md/ADRs). Use when user wants to stress-test a plan against existing documentation, mentions "grill with docs", or wants domain-aligned design review.
---

Conduct an intensive design review of this plan by challenging it against the project's domain model and documented decisions. Ask **one question at a time**, wait for feedback before proceeding, and recommend an answer for each question.

**Domain Alignment:** Flag terminology conflicts immediately. When my language diverges from `CONTEXT.md` definitions, surface the discrepancy: "Your glossary defines X as Y, but you seem to mean Z."

**Precision Through Challenge:** Sharpen vague terms into canonical language. Stress-test fuzzy concepts with concrete edge-case scenarios to expose boundary issues.

**Code-Reality Checks:** Verify stated behavior against actual code. Surface contradictions immediately — if documentation claims one thing and code shows another, highlight that gap.

If a question can be answered by exploring the codebase or reading documentation, do that instead of asking.

**Incremental CONTEXT Updates:** When terms are resolved, update `CONTEXT.md` immediately (not in batches). Keep it a glossary only — no implementation details or spec material.

**Selective ADRs:** Only create Architecture Decision Records when all three hold: the decision is costly to reverse, surprising without context, and represents a genuine trade-off between alternatives.

Respect the existing repo structure: single-context (`CONTEXT.md` at root) or multi-context (`CONTEXT-MAP.md` pointing to per-context docs).
