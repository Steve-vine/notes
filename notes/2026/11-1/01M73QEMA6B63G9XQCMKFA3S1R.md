---
id: 01M73QEMA6B63G9XQCMKFA3S1R
created: 2026-11-10T21:57:28.006291Z
updated: 2026-11-10T21:59:08.878272Z
type: task
title: 'Target: GitHub''s Secrets reads recreated as configuration — deploy keys, the organisation''s fine-grained tokens and Actions secrets through App sign-in and follow-on reads, run beside the coded GitHub App and compared'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1713
sprint: sj4f1kj
blocked_by:
- 01M73QC5JFEQX7MZGKRC9RF4N6
- 01M73QCHFKHNH35P0021RQ8YQT
- 01M73Q9S96V19DX5JNC9G9GYXP
- 01M73QBB97RXXF7VVZ2GTZN0EV
assignee: steve
label:
- feature
priority: high
task_status: todo
---
One of the sprint's three targets (ADR 0146, COM-1705). Today a coded GitHub App (ADR 0141 §13, COM-1575/1576/1581) reads deploy keys, fine-grained tokens and Actions secrets for Secrets. Sprint sep79bz already proves the organisation's alerts and repositories as feeds (COM-1704). This task finishes GitHub.

**Chain:** independent (configuration and comparison on staging)

## What gets set up

- The GitHub Collection integration gains an account using **App sign-in** (COM-1707). This is a read-only GitHub App with the same permissions as today's coded one, or the same App.
- Feeds into Secrets:
  - **deploy keys**: the repositories, then each repository's keys (COM-1706). A repository answering "no permission" is skipped and its keys are left as they were, matching today's behaviour;
  - **fine-grained tokens** granted to the organisation, with owner, expiry and last use;
  - **Actions secrets as stored copies**: organisation, repository and environment secrets, by name and last change, through follow-on reads.

## Done when

- On staging (E2E Test Company, then Test Company), the configured feeds and the coded GitHub App are run side by side for at least two days.
- A comparison on this task lists, for each kind, the keys or copies each found. They must match. Every difference is explained or fixed (as a capability, never a special case).
- Rotation proof for a test deploy key works through the feed: add a new key, change the stored copy, remove the old key, and the secret shows *Seen at source and store*.
- The full configuration is exported as JSON on this task, so it can be recreated on production.
- No code change for GitHub (COM-1696).