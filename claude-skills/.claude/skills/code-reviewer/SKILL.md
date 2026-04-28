---
name: code-reviewer
description: Review code changes on the current branch against a base branch (default dev). Checks for rule conformance, DRY violations, magic variables, useMemo/useEffect misuse, unnecessary typecasts, and unnecessary type exports. Interactively suggests additional review areas.
---

## Code Review Skill

Review all code changes on the current branch compared to a base branch.

### Step 1: Determine the diff

- Ask the user which base branch to compare against. Default to `dev` if they confirm or don't specify.
- Run `git diff <base>...HEAD --name-only` to list changed files, then `git diff <base>...HEAD` to get the full diff.
- If no changes are found, inform the user and stop.

### Step 2: Gather project rules and context

Use subagents to:
- Read all cursor rule files in `.cursor/rules/*.mdc` at the project root.
- Read the surrounding code context for each changed file (the unchanged portions and neighboring files) to understand the existing style and patterns.

These rules and context are the ground truth for the review. Every finding must be grounded in the project's actual conventions.

### Step 3: Run the mandatory checklist

Evaluate EVERY changed file against each of these checks. Report findings grouped by file with line references and severity (`error`, `warning`, `suggestion`).

#### Check 1: Style & Rule Conformance
- Verify the new code follows ALL project cursor rules (`.cursor/rules/*.mdc`).
- Verify the new code matches the style and patterns of the existing codebase (naming, file structure, import ordering, architecture layers, etc.).
- Use subagents to explore the existing codebase and compare patterns.

#### Check 2: DRY Violations
- Flag duplicated logic, repeated code patterns, or copy-pasted blocks that should be extracted into shared functions, utilities, or components.
- Check across the diff AND against existing code in the repo -- if similar logic already exists elsewhere, flag it.

#### Check 3: Magic Variables
- Flag any literal values (numbers, strings, booleans) used inline without a named `const`, config entry, or `as const` object.
- Acceptable exceptions: `0`, `1`, `-1`, `""`, `true`, `false`, `null`, `undefined`, and values in test assertions.

#### Check 4: `useMemo` / `useEffect` Misuse
- This project uses `babel-plugin-react-compiler` which handles memoization automatically.
- Flag any `useMemo`, `useCallback`, or `memo()` usage that does NOT fall into the documented exceptions (context provider values, expensive O(n log n)+ computations, list items with internal state, compiler-excluded components, effect dependency stability).
- Every manual memoization MUST have a comment prefixed with `// Intentional useMemo:` or `// Intentional memo:` explaining why.
- Flag unnecessary `useEffect` usage -- check if the logic could be handled by event handlers, TanStack Query, derived state, or URL search params instead (per the react-state hierarchy).

#### Check 5: Unnecessary Typecasts
- Flag every `as Type` typecast in the changed code.
- For each one, determine if a proper `as const` object, type narrowing, Zod schema, or discriminated union could replace it.
- Typecasts are acceptable ONLY when working around bugs in external libraries or type system limitations that cannot be resolved otherwise. If acceptable, it should have an explanatory comment.

#### Check 6: Unnecessary Type Exports
- Flag any `export type` or `export interface` in the changed code that is not imported by any other file in the project.
- Use subagents to search the codebase for imports of each exported type. If no other file imports it, flag it as a `warning`.
- Types and interfaces used only within the file they are defined in should not be exported.

### Step 4: Present the review

For each file, present findings in this format:

```
### `path/to/file.ts`

| Line | Severity | Check | Finding |
|------|----------|-------|---------|
| 42   | warning  | DRY   | This sorting logic duplicates `sortByDate()` in `src/utils/sort.ts` |
| 78   | error    | Magic | `"pending"` used without a named const -- use the status object from `schemas` |
```

If a check has no findings for any file, explicitly state that the check passed.

End with a summary count: X errors, Y warnings, Z suggestions.

### Step 5: Interactive follow-up

After presenting the mandatory checklist results, ask the user one question at a time about whether they'd like you to also review for:

1. Error handling patterns (per `error-handling.mdc`)
2. Security concerns (auth, input validation, injection)
3. Performance (unnecessary re-renders, N+1 queries, missing indexes)
4. Test coverage (are the changes tested? are edge cases covered?)
5. Accessibility (ARIA attributes, keyboard navigation, screen readers)
6. API contract consistency (request/response schemas, OpenAPI alignment)

For each area the user agrees to, perform a focused review of the diff for that concern and present findings in the same format. Continue asking until the user declines or all areas have been covered.
