---
name: security-basics
family: Process
tags: [any]
evidence: 0 accepted ePort threads
---
# Security basics

## Index line
Injection, leaked secrets, authorization from client-supplied data, PII or tokens in logs, open redirects, missing rate limits.

## What to look for
- User-controlled input concatenated or interpolated into a query, a raw SQL fragment, a shell command, a file path, a regular expression, or an HTML string.
- Raw HTML rendered from data: the framework's unsafe HTML escape hatch, markup built from strings, markdown rendered without the sanitizing step.
- A redirect target or return URL built from a query parameter with no check that it stays on the allowed origin or path list.
- A secret, API key, token, private key, or password in source, a fixture, a snapshot, a story, a log line, an error message, or a tracked env file.
- A server-only secret reachable from client code: imported into the browser bundle, exposed through a public env prefix, or returned in an API response.
- Tokens, session ids, auth headers, or full request bodies written to logs or the error tracker.
- Personal data (names, emails, addresses, document contents, health or financial details) written to logs, error reports, analytics, or URLs.
- Identity or role read from the request body, query, client-set headers, or browser storage and used to decide what the caller may do. The verified session or token is the only source.
- A sensitive route (login, password reset, token exchange, invite, email send, export, expensive search) added with no rate limit where the project applies one to siblings.
- Signed payloads (webhooks, tokens) accepted without verifying the signature, or with verification switched off by a flag.
- Access tokens, reset codes, or invite links generated from a non-secure random source.
- File uploads or downloads that trust the client's file name, path, or content type.

## Why it matters
- These defects have external consequences: data loss, account takeover, leaked credentials, regulatory exposure.
- One instance is enough. An attacker needs a single unguarded path.
- A secret in git history stays there after the fix and must be rotated, so catching it before merge matters.
- Logs and error trackers are widely shared and long retained, so PII and tokens in them leak to everyone with access.

## What not to flag
- Input that reaches the sink through a parameterized query, a query builder's bound values, an argument array, or the framework's escaping. Confirm the path before flagging.
- Static strings and developer-controlled values in queries or commands. Only attacker-controlled data injects.
- Public, non-secret configuration: public keys, browser client ids, feature flags.
- Obviously fake values in example env files and tests that could not work against a real system.
- Logging of request or entity ids that are not personal data and are needed to trace a request.
- Missing rate limits on cheap, idempotent, public routes, or where the project limits at the gateway.
- Redirects to a fixed allow list or to a relative path the code validates.
- Whether a role or ownership check exists at all. That is authorization-checks.

## Severity
- must fix: injection from attacker-controlled input; a real secret in source or a client bundle; authorization based on client-supplied identity or role; unverified signed payloads.
- should fix: tokens or PII in logs or error reports; an open redirect; a sensitive route with no rate limit where siblings have one; non-secure random for access tokens.
- nit: hardening siblings also lack and the project has not adopted, noted once.

## Remedies
- use parameterized queries and argument arrays; escape or sanitize at the sink
- move the secret to the secret store and rotate it
- redact tokens and personal data before logging
- take identity and role from the verified session only
- validate redirect targets against an allow list; apply the project rate limit to sensitive routes

## Related
- authorization-checks: whether a role or ownership check exists and which roles pass.
- validation-boundaries: shape and rule validation of input; here how input reaches a sink.
- error-reporting-hygiene: report structure and duplication; here what must never enter the report.
- ci-config-and-dependencies: env var wiring, tracked local config, dependency sources.
- guards-from-wrong-or-partial-sources: a guard that reads the wrong fact for correctness reasons, not because the client controls it.

## Sources
- ePort: none
- seed only: the candidate definition in candidates-proposed.md
