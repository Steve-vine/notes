---
id: 01KZV9QDE1PXKSZVDFDF3PQFTS
created: 2026-08-12T15:33:47.585428Z
updated: 2026-08-12T15:33:47.585428Z
type: task
title: smoke-user-seed Helm hook OOMKilled at 128Mi (release shows failed; bump hook memory)
priority: low
task_status: backlog
imported_from: linear
assignee: steve
project: 01KZV767QMFTN9CZ3TPGTSAASD
number: 5
---
**Surfaced during the DEV-305 e2e smoke (pre-existing, not introduced by the port).**

The `smoke-user-seed` post-upgrade Helm hook (`python scripts/dev/seed_smoke_user.py` → `redvektor-admin`) is capped at **128Mi** and gets **OOMKilled**. Consequence: the Helm release lands in `failed` status even though all workloads are healthy. Because the smoke user already exists (the DB persists across deploys), the e2e still logs in fine — so this is a **false-failure / cosmetic** issue, not a functional blocker, but it makes `helm upgrade` status misleading and would bite a clean-DB deploy.

**Fix:** bump the hook's memory limit (chart concern) — raise the `resources.limits.memory` on the `smoke-user-seed` hook to something that fits the `redvektor-admin` seed process, and confirm a clean-namespace deploy seeds + reports `deployed`.

Priority Low — non-blocking. Source: DEV-305 session summary (`docs/sessions/305-port-subfinder.md`, finding 4).

---

Imported from Linear [DEV-314](https://linear.app/stevevine/issue/DEV-314/smoke-user-seed-helm-hook-oomkilled-at-128mi-release-shows-failed-bump)