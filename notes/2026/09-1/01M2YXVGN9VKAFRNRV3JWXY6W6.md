---
id: 01M2YXVGN9VKAFRNRV3JWXY6W6
created: 2026-09-20T08:10:22.249146Z
updated: 2026-09-24T20:29:39.42272Z
type: task
title: Production's database backup is proven by restoring it once — into a scratch cluster, timed, then thrown away
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 730
sprint: stek6vx
assignee: steve
label:
- chore
priority: medium
task_status: backlog
tech: null
---
Backups are landing (COM-720, confirmed from the bucket 2026-09-20: `base/20260920T020000/` `status=DONE`, WAL segments 1→305 with no gaps). Nothing has ever been restored from them. A backup nobody has restored is a hope, not a recovery: the things that break a restore — bucket permissions for a *new* cluster's service account, a missing WAL, an image/plugin mismatch, the app Secret's password not matching the restored role — only show up when one is attempted.

**Steve runs it** (the production API is IP-allowlisted; Claude prepares the manifest and reads the output).

**Do**, in `compass-prod` (or a scratch namespace whose ServiceAccount the `compass-app` role trusts — the trust policy names `compass-prod:compass-postgres`, so a differently named cluster needs `POSTGRES_SA` added via `s3-irsa.sh`, or reuse the name in another namespace and extend the trust):
1. A one-off CNPG `Cluster` `compass-postgres-restore`, 1 instance, same `16.15-system-bookworm` image and storage class, `bootstrap.recovery.source` → an `externalClusters` entry pointing at `s3://mp-envproductionpri-compass-prod-files/postgres-backups/` with `serverName: compass-postgres`. **No `backup:` section on the restored cluster** — it must never archive into the live cluster's path. Apply by hand, not through Argo CD.
2. Time it from apply to Ready. Then check the data, read-only: `alembic_version` matches production's, row counts for `users`, `directory_users`, `controls`, `activity_log` are plausible, latest `activity_log.created_at` is close to the restore point.
3. Once more with `recoveryTarget.targetTime` set to a moment mid-morning — proves point-in-time recovery, which is what the WAL archive is for.
4. Delete the cluster and its PVCs. Confirm the live cluster's `ContinuousArchiving` is still True and the bucket path has no foreign timeline.

Write the procedure and the measured time into the devops repo readme ("Restoring the database"), including the step that matters in a real incident: the restored cluster's `compass` role password comes from the backup, so `compass-secrets`' `DATABASE_URL` must still match it (it will, if `production-uk-compass-creds` has not changed) and the app must be pointed at the new `-rw` Service.

**Acceptance**: a restore from last night's backup reaches Ready with plausible data; a point-in-time restore lands at the requested time; the time taken is written down; nothing was written into the live cluster's backup path; the scratch cluster is gone.

Later, separately: move backups to the Barman Cloud Plugin (the built-in `barmanObjectStore` is deprecated upstream) — repeat this test after that change.