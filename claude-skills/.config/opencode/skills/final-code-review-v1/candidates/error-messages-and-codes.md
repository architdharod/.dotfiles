---
name: error-messages-and-codes
family: Correctness
tags: [api, web]
evidence: 8
---
# Error messages and codes

## Index line
Error codes, messages, and status classes that name the wrong condition, have no client mapping, or misclassify the fault.

## What to look for
- The thrown code or message names a condition other than the one the branch detected. Read the branch condition and the message side by side.
- A branch falls through to a default or generic error whose message does not fit the specific failure it detected.
- A code maps to a message that states the opposite of the condition it is raised for.
- Validation that throws inside a parse or transform step, so an input problem surfaces as a server error instead of a validation issue.
- A client for an upstream service collapses every non-success response into one error class, so permanent client faults are reported as retryable server faults, or the reverse.
- Two paths that fail the same way return different codes, or one of them has no entry in the client's code-to-message map.
- A code with no client-side mapping, so the user sees the generic fallback and the specific handling built for it never runs.
- A specific message that is unreachable because an earlier, broader branch catches the case first.
- A null or missing branch reuses wording written for a different state: expired versus never set.
- A message picks the first issue from a validation result, so it can describe a different field than the one the user touched.
- The status class does not match the fault: client input errors as server errors, server faults as client errors, a missing item as a bad request.
- A new code added without its message, translation, or mapping in the client.

## Why it matters
- Users and support act on the message. A wrong one sends them to the wrong fix.
- Status classes drive retry logic. A permanent fault labelled retryable loops forever; a transient one labelled permanent never recovers.
- Unmapped codes degrade to the generic toast, so the specific handling built for them never runs and the test plan holds for one path only.
- Monitoring groups by code. A wrong code files a failure class under the wrong group.

## What not to flag
- Generic wording on a true catch-all branch where no specific condition is known.
- Message tone or style with no factual mismatch: writing-style, or project-rule-conformance for language rules.
- Whether an outcome is reported at all, or several outcomes merged into one toast: outcome-signaling.
- Errors reported twice or without context to the tracker: error-reporting-hygiene.
- Not-found versus empty confusion in data handling: absence-conflation.
- Which layer validates: validation-boundaries. Here only the status class the failure surfaces as.
- Internal-only codes the UI never shows, left generic on purpose and marked as such.

## Severity
- must fix: the status class drives retries, or the message states the opposite of the truth.
- should fix: a wrong or unmapped code, a generic fallback where a specific message exists, the wrong issue picked from a list.
- nit: wording that is accurate but vague when a more specific message costs one line.

## Remedies
- raise the code and message that name the detected condition, one per branch
- map every code the route can return in the client
- report validation as an issue, not a thrown error
- classify upstream responses by status class before wrapping
- pick the issue by field, not by position

## Related
- outcome-signaling: is the outcome reported, and distinctly. Here: is the code or message right.
- error-reporting-hygiene: how errors reach the tracker. Here: how they reach the client.
- exception-aggregation: where errors are caught. Here: what they say.
- external-writes-and-retries: retry safety after an external write. Here: the status class that tells the caller whether to retry.
- absence-conflation: missing versus empty in data. Here: the same confusion in an error message.

## Sources
- review threads: 8 accepted change requests from real code reviews
- other: none
