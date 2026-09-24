---
name: ci-config-and-dependencies
family: Process
tags: [ci, config]
evidence: 14
---
# CI configuration and dependencies

## Index line
CI jobs without needs, timeouts, or retries; checks that skip files; floating versions; ad-hoc dependency hosts; wrong config; warnings.

## What to look for
- A CI job waits on a whole stage or uses the older dependency form instead of declaring its real inputs with needs, so the pipeline serializes work that could run in parallel.
- A job without a timeout, or a long job not marked interruptible. A hung job blocks the pipeline until the global limit, and a superseded pipeline keeps running.
- A job that pushes, publishes, or deploys over the network without a retry policy for transient errors.
- Tool, image, or action versions pinned in some jobs and floating in others, or a range where the lockfile expects a pin.
- A dependency fetched from a personal or ad-hoc host, a branch of a git URL, or a loose tarball. Installs break when the host moves.
- Files or directories excluded from typecheck or lint: test files skipped by typecheck, or a directory-wide lint exemption that also covers spec files the runner still collects.
- Runtime code reads an environment variable that no environment, pipeline, or example env file provides, and a hard-coded fallback hides the gap. Monitoring expects a release stamp the pipeline never sets.
- An example or template config value that gives wrong results when copied: a base URL missing a path segment, a port that differs from the app's.
- Per-developer editor or launcher config committed instead of ignored.
- Large binary assets checked in with no size budget and in an uncompressed format.
- A deprecated CLI flag, API, or test utility used where the current form exists and the tool warns about it.
- Console warnings the diff introduces or leaves, with neither a fix nor a note in the MR and in the code saying why they are acceptable.

## Why it matters
- Pipelines get slow and flaky, and people stop trusting them.
- Excluded files pass CI with type errors and lint violations that hold only by convention.
- A dependency host that disappears breaks every install and every deploy.
- Wrong example config gets copied into real environments, and untracked warnings hide the next real one.

## What not to flag
- Floating versions where the project documents a policy of tracking the latest.
- Stage ordering in a pipeline of two or three jobs where needs would change nothing.
- Environment variables documented as optional with a safe default that is neither a secret nor a real endpoint.
- Assets already under the budget or in a compressed format.
- A deprecated API with no stable replacement in the version the project uses.
- Warnings from a third-party package that are documented as accepted.
- Lint suppressions and the repo's rule files: that is project-rule-conformance.
- Migrations and schema files: that is data-model-and-migrations.

## Severity
- must fix: a dependency from an ad-hoc host, a check excluded so that type errors pass CI, an environment variable nothing provides with a fallback pointing at a real endpoint.
- should fix: missing needs, timeout, retry, or interruptible; inconsistent pins; a deprecated API that warns; wrong example config; committed local config; an oversized asset.
- nit: warnings documented but not fixed, a floating patch version.

## Remedies
- declare needs and add timeout, retry, and interruptible
- pin versions consistently and vendor or fork the ad-hoc dependency
- include the excluded files in typecheck and lint
- provide the variable in the pipeline and the example env file, and fix wrong example values
- ignore local config, compress the asset, migrate off the deprecated API, fix or document the warning

## Related
- project-rule-conformance: the repo's own rule files. This candidate covers pipeline and tooling config.
- data-model-and-migrations: schema and migration files.
- security-basics: secrets in config. A dependency host as a supply-chain risk is reported here.
- error-reporting-hygiene: what is sent to error monitoring. The variables and release stamp that feed it belong here.
- text-disagrees-with-code: docs that describe config wrongly. An example config file with a wrong value belongs here.

## Sources
- review threads: 14 accepted change requests from real code reviews
- other: none
