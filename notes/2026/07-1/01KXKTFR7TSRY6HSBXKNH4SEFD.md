---
id: 01KXKTFR7TSRY6HSBXKNH4SEFD
created: 2026-07-15T21:21:23.19486418Z
updated: 2026-07-21T08:39:07.215768Z
type: task
title: Postgres backup and restore — including the KEK
project: 01KX671DATY39VW6GWK3M2T3DN
number: 73
sprint: sd1gs0p
comments:
- id: 01KXV2MKP1SPKJMBYV62C83GW0
  author: Steve Vine
  at: 2026-07-18T16:58:32.00022Z
  text: |-
    Sprint 10 (2026-07-18): deferred behind the spend-relief release. Pulled forward into Sprint 10 as catastrophic-loss insurance, but it's blocked on a backup-destination decision — there is NO object store in the cluster today (CNPG is a single instance on local-path, no barmanObjectStore; no MinIO/S3 in scripts/infra or helm). Steve chose to smoke-test + release the three spend fixes (ISE-107/108/109) first and tackle this as its own focused piece next.

    Open before implementation:
    - Backup destination: in-cluster MinIO (self-contained, same-cluster durability only) vs external S3/R2 (off-site DR, needs bucket + creds). Not decided.
    - KEK strategy: back up ISE_CREDENTIAL_MASTER_KEY (lives only in the hand-applied ise-env-overrides secret) alongside, or document credential re-entry post-restore.
    - New ADR for the backup strategy (next number after 0023).
assignee: steve
priority: high
task_status: backlog
---
**The estate's most valuable rows have no backup.** CNPG runs as a single instance on local-path storage (`scripts/infra/postgres-cluster.yaml`) with **no `backup:` stanza, no WAL archiving, no `ScheduledBackup`, no restore runbook**. That volume holds the envelope-encrypted `Credential` rows (including the write credential Sprint 5 introduced) and the append-only `AuditEvent` log.

## Scope

- CNPG `backup` / `barmanObjectStore` (or `ScheduledBackup`) to an object store; WAL archiving; a retention policy.
- A **tested restore runbook** — a backup nobody has restored is a hope, not a backup.

## The KEK is the trap

The envelope-encryption key (`ISE_CREDENTIAL_MASTER_KEY`) lives in **exactly one hand-applied Secret** (`ise-env-overrides`) and **nowhere in the DB**. A Postgres restore without it yields **undecryptable `Credential` rows**. So "backup" must cover the KEK too, or the runbook must say plainly: after restore, re-enter every credential. Decide and document which.

Also flagged for the drill: the staging DB password is committed in cleartext (gitleaks-allowlisted) in two places — worth rotating as part of this.

**New ADR** for the backup strategy (next number after 0023). Staging-first deploy order.