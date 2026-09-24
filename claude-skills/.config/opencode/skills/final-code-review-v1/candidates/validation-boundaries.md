---
name: validation-boundaries
family: Correctness
tags: [api, web, schemas]
evidence: 15 accepted ePort threads
---
# Validation boundaries

## Index line
Validation or normalization that another path skips, differs from the shared schema, or never reaches external input.

## What to look for
- A business rule enforced only in a client form schema. Check whether the API route and other entry points enforce the same rule.
- A second path to the same write (an alternate button, a skip path, a bulk path, a script) that does not run the validation the main path runs.
- A form schema overrides a shared field with a bare type and drops the shared bound: length, format, allowed values.
- A field typed as a plain string where the format is known (email, id, URL, timestamp), so an empty or malformed value travels downstream.
- External input (partner payloads, token responses, webhook bodies) used without parsing its shape at the boundary.
- External input concatenated or stored into a length-limited column with no cap before the write.
- A schema stricter than what the docs, the field's own description, or sibling fields promise, so an unread field can reject the whole request.
- An external contract guessed (a TODO, an assumed payload shape) instead of verified against the partner's docs or a recorded response.
- Normalization (trim, case, unicode) applied on one path but not on the compare, submit, or store path, so a padded value passes one check and fails the next.
- Client and server disagree on what an optional field's empty value is, so the client sends a value the server rejects with a generic error.
- An optional filter whose omission means "match nothing" instead of "match everything", or a filter made required when callers legitimately omit it.

## Why it matters
- Any caller that is not the client bypasses client-only rules, and the server stores invalid data.
- Unparsed or uncapped external input turns into server errors that partners retry forever.
- A schema stricter than the documented contract rejects valid requests over fields nobody reads.
- Mismatched normalization makes a value pass one check and fail the next with a message that explains nothing.

## What not to flag
- Client-side validation that duplicates a server rule for faster feedback, when the server has the rule too.
- Format checks the shared schema package already applies upstream on the same path.
- Internal-only paths where the caller is code in the same repo and the type already guarantees the shape.
- Optional filters whose default is documented and matches sibling filters.
- Values that come from the repo's own database or config rather than from an external system.
- A length cap the shared schema the route parses with already enforces.

## Severity
- must fix: a rule enforced only on the client while the server accepts anything; external input unparsed or uncapped before a write; a schema stricter than the documented contract on a live partner path.
- should fix: an alternate path that skips validation; a bare-type override that drops a shared bound; normalization on one path only; a filter default that widens or narrows results by surprise.
- nit: a known-format field typed as a plain string on an internal path with no downstream risk.

## Remedies
- move the rule into the shared schema
- parse and cap external input at the boundary
- reuse the shared field definition instead of overriding it
- normalize once at the boundary
- verify the partner contract against its docs or a recorded response

## Related
- wrong-home: where the validation code sits. Here whether every path runs it.
- absence-conflation: whether empty and missing share one value. Here whether the boundary accepts it.
- authorization-checks: role and ownership checks on routes.
- error-messages-and-codes: which status and message a rejection gets.
- data-model-and-migrations: column bounds and constraints on the database side.
- imprecise-types: compile-time types looser than needed. Here runtime schemas.
- precedent-divergence: an established multi-path form pattern ignored.
- blast-radius: a stricter parse reaching flows the MR did not target.

## Sources
- ePort: !41 !67 !71 !79 !85 !147 !161 !232 !241 !274 !290 !293
- other sources: none
