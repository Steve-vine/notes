---
id: 01KYWAF2WNPCRQMQSFJN80CVX1
created: 2026-07-31T14:50:15.829556Z
updated: 2026-08-07T08:35:15.446398Z
type: task
title: 'Docs: Getting started — upgrading'
project: 01KX671DATY39VW6GWK3M2T3DN
number: 425
order: 0.015625
sprint: sp3en5k
comments:
- id: 01KYWB2J00HR7MDZM4M704ZP8N
  author: Steve Vine
  at: 2026-07-31T15:00:53.888605Z
  text: |-
    Done on feature/ise-425-docs-upgrading — PR #20, left OPEN for review.

    Real upgrade guide: two-part backup requirement up front (database AND the credential key-encryption key — "treat the pair as one artefact; a backup of either alone is not a backup", with the concrete failure — restored estate, undecryptable credentials); helm upgrade with a pinned immutable tag and the <branch>-yyyymmdd-hhmm format + why latest is never published; the ordered migration-hook account (append-only files, exactly-once, FAILS THE UPGRADE BEFORE ANY POD ROLLS, hook logs as first triage stop, no startup races); rollback section including the honest caveat that helm rollback does NOT un-migrate — safe for additive schema, and for destructive migrations the recovery path is the backup, not rollback; housekeeping (hook resources survive helm uninstall → delete the namespace; registry tag retention). Facts from ADRs 0005/0008/0012. Build/lint green.
assignee: steve
priority: medium
task_status: done
---
Replace the stub at `src/content/docs/getting-started/upgrading.md` with a real upgrade guide: the Helm upgrade procedure, how migrations run automatically as a pre-upgrade hook, the backup requirement before upgrading — **including the key-encryption key**, without which a restore yields undecryptable credentials — rollback guidance, and where release notes live.

Ground in ADRs 0005 (Alembic migrations via Helm hook), 0008 (immutable image tags), 0012 (deployment). Operator audience, released capability only.