---
id: 01KXKTFR7TSRY6HSBXKNH4SEFD
created: 2026-07-15T21:21:23.19486418Z
updated: 2026-07-18T16:29:37.955863Z
type: task
title: Postgres backup and restore — including the KEK
priority: high
label:
- feature
- brief
task_status: backlog
assignee: steve
project: 01KX671DATY39VW6GWK3M2T3DN
number: 73
sprint: scxrykd
---
**The estate's most valuable rows have no backup.** CNPG runs as a single instance on local-path storage (`scripts/infra/postgres-cluster.yaml`) with **no `backup:` stanza, no WAL archiving, no `ScheduledBackup`, no restore runbook**. That volume holds the envelope-encrypted `Credential` rows (including the write credential Sprint 5 introduced) and the append-only `AuditEvent` log.

## Scope

- CNPG `backup` / `barmanObjectStore` (or `ScheduledBackup`) to an object store; WAL archiving; a retention policy.
- A **tested restore runbook** — a backup nobody has restored is a hope, not a backup.

## The KEK is the trap

The envelope-encryption key (`ISE_CREDENTIAL_MASTER_KEY`) lives in **exactly one hand-applied Secret** (`ise-env-overrides`) and **nowhere in the DB**. A Postgres restore without it yields **undecryptable `Credential` rows**. So "backup" must cover the KEK too, or the runbook must say plainly: after restore, re-enter every credential. Decide and document which.

Also flagged for the drill: the staging DB password is committed in cleartext (gitleaks-allowlisted) in two places — worth rotating as part of this.

**New ADR** for the backup strategy (next number after 0023). Staging-first deploy order.