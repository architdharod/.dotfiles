---
name: ralph-loop
description: Automatically pick the next unblocked task from a markdown task tracker file, implement it, verify it, and mark it done. Use when user mentions "ralph loop", "ralph", or invokes the ralph-loop workflow.
---

# Ralph Loop

Pick the next unblocked task from a markdown tasks file, implement it, verify, and mark it done. One task per invocation.

## Workflow

### 1. Locate the task file

Ask the user for the path to their markdown tasks file if not already provided or in context.

### 2. Parse tasks and select the next task

Read the file and identify all tasks. Apply these rules in order:

1. **Skip done tasks** -- any tasks where the Done checkbox is checked (`- [x] Done`)
2. **Skip blocked tasks** -- any task whose `Blocked by` section references task numbers that are NOT yet done
3. **Pick the first remaining task** -- lowest task number among unblocked, incomplete tasks

If no tasks remain, inform the user that all tasks are complete.

### 3. Announce the pick

Tell the user which task was selected and why (e.g., "task #4 is the next unblocked task -- tasks #1 is done and it has no other blockers"). Summarize what will be built.

### 4. Explore the codebase

Before implementing, explore the existing codebase to understand current state, patterns, and conventions. This context is critical for correct implementation.

### 5. Implement

Use the task's `What to build` section as the spec and `Acceptance criteria` as the checklist. Use the TodoWrite tool to track each acceptance criterion as a sub-task. Implement the full task, marking criteria complete as you go.

### 6. Verify

Ask the user if you can run any verification commands. If user says yes, then run any verification commands mentioned in the acceptance criteria (e.g., `make lint`, `make test`). Fix tasks until all verification passes. Do NOT mark the task done until verification succeeds.
If user says no, then move to next step.

### 7. Mark done

Edit the markdown file: change the task's `- [ ] Done` to `- [x] Done`.

### 8. Report and stop

Summarize what was implemented. List the next unblocked task(s) that would be picked on the next invocation. Do NOT automatically continue to the next task.

## Markdown file conventions

The skill expects this structure (flexible on exact wording):

```markdown
## task #N: Title

- [ ] Done

### What to build

Description of the work.

### Acceptance criteria

- [ ] Criterion 1
- [ ] Criterion 2

### Blocked by

- Blocked by task #M
```

- tasks are `##` headings containing a `#N` task number
- Each task has a `- [ ] Done` checkbox (checked = `- [x] Done`)
- Blockers reference task numbers (`#1`, `#2`, etc.) under a `Blocked by` section
- "None" or absent blockers means the task is immediately available
