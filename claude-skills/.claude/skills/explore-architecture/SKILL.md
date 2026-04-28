---
name: explore-architecture
description: Explore and compare architecture or system design approaches for a given problem before committing to an implementation. Produces 2-3 drastically different solution options with pros, cons, and industry context. Use when user wants to explore solutions, compare architectures, evaluate design tradeoffs, or decide on an approach before writing a PRD.
---

# Explore Architecture

## When to use

This skill sits **before** PRD writing. The goal is divergent thinking — present the user with genuinely different paths so they can make an informed choice. The output feeds into `write-a-prd` once a direction is chosen.

## Process

### 1. Understand the problem deeply

Interview the user until you can answer all of these:

- **What** is the core problem? (not the solution — the problem)
- **Who** experiences it and how often?
- **What constraints** exist? (scale, latency, cost, team size, timeline, existing tech stack)
- **What has been tried or considered** already?
- **What does success look like?** (measurable outcomes)

If the user has an existing codebase, explore it to understand current architecture, dependencies, and integration points.

Do not move on until you can restate the problem in your own words and the user confirms it.

### 2. Research and ideate

Based on the problem, research relevant architecture patterns and industry approaches:

- Search for how industry leaders have solved similar problems
- Consider both established patterns and emerging approaches
- Look at relevant trade-offs: build vs buy, monolith vs distributed, sync vs async, etc.
- Think across paradigms — don't just vary the same idea slightly

### 3. Present 2-3 drastically different solutions

For each solution, write up:

<solution-template>

### Solution N: [Descriptive Name]

**Approach**: 2-3 sentence summary of the core idea.

**How it works**:
- Key components and their responsibilities
- Data flow and integration points
- Core technology choices

**Industry precedent**: Who uses this pattern and why. Link to relevant engineering blogs, papers, or talks when possible.

**Pros**:
- [specific advantage with context]

**Cons**:
- [specific disadvantage with context]

**Best when**: The conditions under which this solution shines.

**Worst when**: The conditions under which this solution falls apart.

**Rough effort**: T-shirt size estimate (S/M/L/XL) with brief justification.

</solution-template>

### 4. Comparison matrix

After presenting solutions, provide a comparison table across the dimensions that matter most for this specific problem (pick 5-7 from: complexity, scalability, cost, time-to-market, team skill fit, maintainability, flexibility, risk, operational burden, etc.)

### 5. Recommendation and next steps

- State which solution you'd lean toward and why, but frame it as input — the user decides
- Identify open questions that need answering before committing
- Suggest what to validate or prototype first
- Note if the chosen direction is ready for a PRD or needs further exploration

## Key principles

- **Diverge, don't converge** — the solutions should feel genuinely different, not variations on a theme. If two solutions share the same core architecture, they're not different enough.
- **No premature commitment** — present trade-offs honestly. Don't steer toward the "obvious" answer.
- **Ground in reality** — reference real systems, real patterns, real failure modes. Avoid theoretical hand-waving.
- **Match the user's context** — a startup with 2 engineers has different "best" answers than a company with 200. Always factor in constraints.
- **Name the risks** — every solution has failure modes. Be specific about what could go wrong.

## Output format

Write the full exploration as a markdown file so the user can save, share, and reference it when writing the PRD. Suggested filename: `explorations/<problem-slug>-architecture.md`
