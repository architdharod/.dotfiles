---
name: divergent-change
family: Design (books)
tags: [any]
evidence: 0
---
# One module that changes for every reason

## Index line
One module keeps changing for unrelated reasons, and the diff adds one more reason to it.

## What to look for
- The diff changes one file for two or more unrelated reasons at once. Each reason could be its own commit touching its own file.
- The file's history shows changes from many unrelated features. Ask what those changes had in common. If only the file name, the file is a magnet. Use git log for this.
- A file that nearly every feature MR touches, whatever the feature is.
- A component or hook that holds state and handlers for several unrelated user tasks, so a change to any task edits it.
- A function with several branches keyed on a mode, each branch owned by a different feature. New feature, new branch, same function.
- A config object or schema that mixes the settings of unrelated subsystems.
- A test file that breaks for unrelated reasons because its subject serves unrelated callers.
- The diff adds a field, case, or handler to a unit that otherwise has nothing to do with the feature.

## Why it matters
- Every feature change risks breaking the other features that share the unit. Reviewing a change means understanding all of them.
- Merge conflicts concentrate in the magnet file.
- Nobody owns the unit, because everybody edits it.

## What not to flag
- A file that changes often for a single reason. Frequency alone is not divergence.
- Registries that by design list every feature. They change with every feature, but for one reason: registration. Flag only when the registry holds logic beyond the list.
- A file that mixes concerns but has no change history to show they diverge. That is file-and-code-organization.
- A change that fans out across many files for one reason. That is incomplete-propagation.
- Size alone. That is oversized-units.
- A shared type or schema that changes because the domain model changes. That is one reason.
- The refactor of a magnet file when the diff only adds a small change to it. Report the pattern once. Do not block the change on the refactor.

## Severity
- must fix: only when the diff's change to the shared unit also alters an unrelated feature's behaviour.
- should fix: the diff creates a new unit that already serves two unrelated reasons, or adds a mode branch to a function that dispatches by feature.
- nit: the diff adds a small change to an existing magnet file.

## Remedies
- split the module by reason for change
- extract the feature's branch into its own module
- move the function to the feature that owns it
- replace mode branches with per-feature modules behind one interface
- move the setting into the subsystem's own config

## Related
- file-and-code-organization: what a file holds now. This candidate is why it keeps changing.
- together-or-apart: cohesion judged by shared knowledge. This candidate judges by change history.
- incomplete-propagation: one reason, many files. The inverse of this candidate.
- oversized-units: size.
- blast-radius: a change to a shared unit that alters unrelated flows. Report the behaviour change there.
- repeated-conditionals-on-type: the same switch in many places. Here one switch grows in one place for many owners.

## Sources
- review threads: none (seed only)
- Fowler, Refactoring (divergent change); refactoring.guru (change preventers)
