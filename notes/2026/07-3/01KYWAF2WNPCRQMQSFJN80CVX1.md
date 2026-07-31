---
id: 01KYWAF2WNPCRQMQSFJN80CVX1
created: 2026-07-31T14:50:15.829556Z
updated: 2026-07-31T14:51:38.053248Z
type: task
title: 'Docs: Getting started — upgrading'
project: 01KX671DATY39VW6GWK3M2T3DN
number: 425
sprint: sp3en5k
assignee: steve
label:
- feature
priority: medium
task_status: backlog
---
Replace the stub at `src/content/docs/getting-started/upgrading.md` with a real upgrade guide: the Helm upgrade procedure, how migrations run automatically as a pre-upgrade hook, the backup requirement before upgrading — **including the key-encryption key**, without which a restore yields undecryptable credentials — rollback guidance, and where release notes live.

Ground in ADRs 0005 (Alembic migrations via Helm hook), 0008 (immutable image tags), 0012 (deployment). Operator audience, released capability only.