---
name: data-model-and-migrations
family: Correctness
tags: [db, schemas, api]
evidence: 10
---
# Data model and migrations

## Index line
Migrations unsafe on a live database, missing rollout steps, model and database out of step, old stored shapes ignored.

## What to look for
- A migration that adds an enum value and uses it in the same transaction, in an index predicate, a default, or a data update. That passes on a fresh schema and fails on a live database.
- A migration whose number or timestamp collides with one already on the target branch, or a migration journal or snapshot edited by hand.
- A new enum value, status, or type that needs a seed row, a lookup row, or a backfill, with no migration or script that creates it.
- A schema change whose rollout needs steps beyond the migration, with none of them listed in the MR's tasks or the runbook. Check that the steps fail in a clean order if one is missed.
- A constraint, check, index, or default written in raw migration SQL that the ORM model does not declare, so the model no longer states the invariant and the next generated migration may drop it.
- A handler that writes a column the database maintains itself through a default or a trigger.
- A new persisted field or a changed shape with no path for rows saved before the change. A default that looks valid but leaves old rows unable to complete their flow counts.
- A stored key or identifier with no namespace or source prefix, so a second source of the same kind of key cannot be added later without a migration.
- A column, index, or constraint name that breaks the naming pattern the rest of the schema uses, so generated and hand-written migrations disagree.
- A migration that drops or renames a column with no compatibility for the code version that runs during the rollout.

## Why it matters
- A migration that passes locally and fails in production blocks the deploy and can leave the schema half applied.
- When the model and the database disagree, the next generated migration silently undoes the hand-written part.
- Old rows that the new code cannot read or complete are a production bug that no test on a fresh database catches.

## What not to flag
- Generated migration files and snapshots the ORM tool produced, when the diff shows no hand edits.
- Additive changes only: a nullable column, a new table, or a new index with no data dependency. No extra rollout steps are needed.
- An explicit write to a database-maintained column when the value must differ from the default on purpose.
- Down migrations, when the repo does not use them.
- A new value that users create at runtime rather than one the system must seed.
- Naming that follows the repo's stated convention even if it differs from the ORM's default.

## Severity
- must fix: a migration that fails on a live database, a journal edited by hand, or old rows the new code cannot process.
- should fix: a missing seed row or rollout step, a constraint absent from the model, or a key with no room for a second source.
- nit: a hand-set value the database would maintain anyway.

## Remedies
- split the enum addition and its first use into two migrations
- regenerate the migration on top of the target branch
- add the seed or backfill migration and list the rollout steps
- declare the constraint in the model and regenerate the snapshot
- add a fallback for the old persisted shape

## Related
- project-rule-conformance: the repo's own migration and naming rules are checked there by the letter. The substance is checked here.
- state-transition-integrity: runtime state changes, orphaned rows from application writes, and lifecycles go there. Schema-time concerns are here.
- validation-boundaries: request validation against the shared schema goes there. Database constraints against the ORM model are here.
- scope-and-requirements: deferred feature requirements go there. Deploy prerequisites for a schema change are here.
- absence-conflation: a fallback that masks missing data in general goes there. Old persisted shapes are here.
- incomplete-propagation: a new value missing from code siblings goes there. Missing seed rows and rollout steps are here.

## Sources
- review threads: 10 accepted change requests from real code reviews
- Repo rule files on database migrations and ORM naming, read at run time
