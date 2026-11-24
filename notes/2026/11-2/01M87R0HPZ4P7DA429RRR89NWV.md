---
id: 01M87R0HPZ4P7DA429RRR89NWV
created: 2026-11-24T21:39:54.719303Z
updated: 2026-11-24T21:52:13.154483Z
type: task
title: Production is ready for Backup and Restore before the next release — room for a restore, a planned route for restoring the scheduled backup, and backups moved to the Barman Cloud plugin
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2157
sprint: szwetpq
assignee: steve
label:
- chore
priority: high
task_status: active
---
Production readiness for the Backup and Restore sprint (ADRs 0169–0174, 0176, 0177). **This must be done before the release that carries the sprint.** The bucket rule (COM-2123) is already applied.

**Chain:** independent (production infrastructure and the deployment repo; no Compass code expected).

**Who does what:** production's cluster API is IP-allowlisted, and the deployment repos' rules leave commits to Steve. **Claude prepares, validates and stages changes and writes the commands; Steve commits, pushes and runs them.** AWS reads (`AWS_PROFILE=production`, `--region eu-west-2`) can be done by Claude.

**1. Room for a restore.** A full restore rebuilds the copy beside the live data before swapping (ADR 0170), so the database needs free space for a second full copy plus its write-ahead log while it runs.
- Done when: production's database volumes have been checked (today about 1.35 GB of data on 50 GiB volumes per instance, per the setup notes; confirm the real size and usage). The free space needed for a restore at today's size, and a rule of thumb for later, is written in the deployment repo's readme.

**2. A planned route for restoring the scheduled backup into a new database cluster** (`docs/runbooks/restore-scheduled-backup.md`, COM-2127).
- The production cluster (`compass-prod-env`, `base/templates/cnpg-cluster.yaml`) only has an `initdb` bootstrap. `DATABASE_URL` is built from the cluster's name, and its ExternalSecret rewrites the Secret every 5 minutes. A recovery cluster therefore needs:
  - a recovery bootstrap that names the live app Secret, so CNPG doesn't reset the owner's password;
  - the `compass-app` IAM role trusting the new cluster's ServiceAccount;
  - `DATABASE_URL` pointed at the new cluster;
  - a new backup `serverName`, so it never archives into the old one's path.
- Done when: the chosen approach (for example, a values switch in `base/` that renders a recovery cluster, or a documented one-off manifest) is prepared and staged in `devops.application.compass`, the IAM change is written as a command, and the steps are in the deployment repo's readme next to the Compass runbook. Nothing is applied to production as part of this.

**3. Move scheduled backups to the Barman Cloud plugin.** CNPG 1.30 warns that the built-in `barmanObjectStore` goes in 1.31, and production uses it today (nightly base backup at 02:00 plus a continuous WAL archive to `s3://mp-envproductionpri-compass-prod-files/postgres-backups/`, 30-day retention).
- Done when:
  - production's current CNPG operator version is confirmed;
  - the plugin is installed the way the cluster's other operators are installed;
  - the Compass cluster uses an `ObjectStore` with the same bucket path, retention and IRSA identity, and the plugin as its WAL archiver;
  - the change is staged for Steve, with the order it must be applied in;
  - after Steve applies it, WAL archiving is confirmed running, and a new base backup is confirmed in the bucket (check the bucket itself, not cluster health: COM-727 found a cluster that said Ready while archiving nothing);
  - existing backups stay readable for the 30 days they're kept.
- Then **COM-730** (prove the scheduled backup by restoring it into a scratch cluster) runs against the plugin-based backups. Its write-up includes COM-2127's `recovery hold-after-restore` step.

**Not in this task:** the release itself, which happens only when Steve asks.