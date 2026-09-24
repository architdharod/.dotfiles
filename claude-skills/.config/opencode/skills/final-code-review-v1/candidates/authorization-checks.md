---
name: authorization-checks
family: Correctness
tags: [api, web]
evidence: 6 accepted ePort threads
---
# Missing or misplaced authorization

## Index line
A mutating route lacks its role or ownership check, a privileged role bypasses checks, or the client duplicates server auth.

## What to look for
- A new or changed mutating route with no role check and no ownership check, or with the check deferred to a follow-up. Compare with what the spec or ticket requires and with sibling routes.
- A route with no forbidden path: nothing can answer 403, and no test covers it.
- A check based on group membership or a client-side flag where a realm role or server-held ownership is the source of truth.
- A mutation that never verifies the caller is the assignee or owner of the entity it changes.
- A privileged role skips integrity or business checks that apply to everyone else. Elevated rights should widen what a user may do, not disable checks on what is valid.
- Client-side route guards that re-check authorization the API enforces and redirect before the request. Prefer the loader and a server 403 handled once.
- A read route that returns rows across owners or tenants without the filter its siblings apply.

## Why it matters
- A missing check on a write is a data-integrity hole for every user, not a cosmetic gap.
- Group-based or client-based checks pass for the wrong people and drift from the role model the rest of the system uses.
- Client guards that duplicate the server fight the router, add a second place to maintain, and give no security.

## What not to flag
- Routes a rule file or comment declares open on purpose, with their own auth where they need it.
- A check done once in a plugin, middleware, or route group the route registers with. Do not demand a repeat inside the handler.
- Hiding controls in the UI that a user may not use, when the server also enforces. That is presentation.
- An admin bypass that a rule file or spec states as intended.
- Injection, secrets, PII, rate limits: security-basics.

## Severity
- must fix: a mutating route ships without the check, or a privileged bypass reaches integrity rules.
- should fix: the check uses the wrong source (groups, client data) while a stricter layer still holds.
- nit: client guards that only duplicate what the server already enforces.

## Remedies
- add the role check through the project's auth helper
- add an ownership condition to the query
- apply integrity checks to every role
- replace the client guard with a loader and a 403 handler
- add the forbidden-path test

## Related
- security-basics: injection, secrets, PII, and authorization decided from client-supplied data.
- state-transition-integrity: whether the write is safe once the caller is allowed.
- validation-boundaries: what the input may contain, not who may send it.
- missing-test-cases: the 403 test when the check exists but is untested.
- scope-and-requirements: a check deferred to a follow-up is also a deferred hard requirement.

## Sources
- ePort: !14 !32 !41 !46 !71 !85
- ePort threads only
