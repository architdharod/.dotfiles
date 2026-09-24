# Report format

The report holds only things to change. No praise. No "this passed". No FYI. No list of what was checked beyond the first line.

## Layout

```
# Review: <branch> vs <base>

<N> must fix, <N> should fix, <N> nits. Candidates run: <N> of 74. Skipped: <ids, or none>.

## Must fix

### `path/to/file.ts:120-134`

**Problem:** <What is wrong. One or two sentences.>

**Why it matters:** <The concrete failure: which input or state, what breaks, for whom.>

**Evidence:** <path:line references and what they show; base behavior for regressions.>

```ts
<up to 8 verbatim lines, when useful>
```

**Fix:** <What to do. One sentence.>

(candidate: <id>, <id>)

## Should fix
...

## Nits
...
```

## Rules

- Worst first. Inside a section, order by file path, then line.
- Put a `---` divider line between entries in the same section. The script adds it. Keep it when humanizing.
- One entry per merged finding. List every candidate id that pointed at it.
- Plain words. Short sentences. No em-dashes. Name the file and lines once, in the heading.
- Run the draft through the humanizer skill before showing it. Keep every fact and every number. Cut filler.
- Omit empty sections. When nothing was confirmed, the whole report is one line: `No issues found. Candidates run: <N> of 74.`
- Save the report to `<work>/report.md`. Print the report in chat, then the path on its own line.
