---
name: file-and-code-organization
family: Structure
tags: [any]
evidence: 12 accepted ePort threads
---
# File contents, file names, and reading order

## Index line
Files that mix scopes or are misnamed for their content, entry points buried under helpers, related derivations scattered.

## What to look for
- A file name that names one of several things the file holds, or names what the file held before the diff changed it.
- A file named for one specific consumer, channel, or feature that now holds generic code, so a sibling module imports from it although the name says it is not shared.
- One file that holds code of different scopes side by side: a generic utility, a feature-wide helper, and a one-off.
- Demo, story, or sample code in the same file as the implementation it demonstrates. The implementation belongs in its own file next to the story, and in the shared components folder only if it is shared.
- A form or view schema kept in a separate file from the form that owns it, while generic helpers sit next to the schema instead of in a shared helpers module.
- One small concern split across two files for no stated reason.
- Two derivations of the same source placed far apart, often with a comment that explains the distance instead of removing it.
- Setup or context for a later call placed far from the code that uses it, so it reads as redundant.
- The main exported function sits below its helpers, so the reader meets details before the purpose.
- A failure result returned early at the top of a function so the success path reads as the exception. The early return looks like a deliberate result rather than a guard.
- An entry file (route, handler, command) that inlines orchestration, credential handling, external calls, and response mapping, while sibling entries delegate those to a service module.
- A directory and its main file that share one name, so the path repeats itself.

## Why it matters
- Readers open the file the name promises and find something else, or miss code that lives under an unrelated name.
- Mixed scopes invite imports between siblings and turn a one-off into a shared dependency by accident.
- Scattered derivations drift apart, and the comment that explains the distance ages faster than the code.
- Helpers-first ordering makes the reader hold details before knowing what they serve.

## What not to flag
- Guard clauses that return early on invalid input or missing data. Flag only when the early-returned value is a real result and the success path is no longer the top-down story.
- Helpers above the entry point when the language or a lint rule requires definition before use.
- A file with several small exports under a name that covers all of them.
- Tests, stories, and styles colocated with the file they belong to, when the repo does that.
- Code that sits in the wrong layer or package: that is wrong-home.
- A sibling pattern that the diff skips: that is precedent-divergence, unless the file itself is the problem.
- A file that is merely long: that is oversized-units.

## Severity
- must fix: demo or story code ships inside a production module, or generic code under a specific name forces a sibling import that the next feature will break.
- should fix: file name lags content, mixed scopes in one file, one concern split across two files, scattered derivations, entry point buried below helpers, entry file inlining what siblings delegate.
- nit: directory and file sharing a name, setup placed far from use, branch order that reads bottom-up without hiding the main path.

## Remedies
- rename the file to its content
- split by scope (extract the service, move demo code out) or merge a split concern
- move the implementation next to its story
- colocate the two derivations and drop the explaining comment
- put the entry point first and helpers in call order

## Related
- wrong-home: code in the wrong layer or module. This candidate covers content and naming within the right module.
- together-or-apart: module boundaries by shared knowledge. This candidate covers single files and their names.
- naming: symbol names. File and directory names belong here.
- oversized-units: size alone.
- convoluted-control-flow: compound conditionals and branchy reassignment. Branch order that hides the main path belongs here.
- needless-or-transient-comments: the comment that compensates for distance is a symptom here, not a comment finding.
- precedent-divergence: a sibling already splits entry from service and the diff does not.

## Sources
- ePort: !43 !52 !131 !144 !155 !161 !233 !271 !283 !288
- other: none
