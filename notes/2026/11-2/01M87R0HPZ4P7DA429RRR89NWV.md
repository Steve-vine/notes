---
id: 01M87R0HPZ4P7DA429RRR89NWV
created: 2026-11-24T21:39:54.719303Z
updated: 2026-11-25T09:17:31.823415Z
type: task
title: Production is ready for Backup and Restore before the next release — room for a restore, a planned route for restoring the scheduled backup, and backups moved to the Barman Cloud plugin
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2157
sprint: szwetpq
comments:
- id: 01M87SR2MFT5W14T207GTT4B6G
  author: Steve Vine
  at: 2026-11-24T22:10:14.287412Z
  text: |-
    Prepared, validated and STAGED, 24 Nov ~22:05 GMT. Nothing applied, committed or pushed. Steve was away and pre-approved preparation only.

    1. Room for a restore. Read from AWS: both database volumes are 50 GiB (gp2, encrypted, eu-west-2a) and the database is 1.35 GB. A restore needs at least 2 × the database + 5 GiB free on each volume, about 7.5 GiB today against an estimated 47 GiB free. Rule of thumb: grow the volumes once the database passes a quarter of them (12 GB). WAL archiving is running (newest WAL 21:58 UTC). The readme's "Room for a restore" section has the kubectl commands to confirm real free space.

    2. Restoring the scheduled backup into a new cluster. A `postgres.restore` switch in `base/`, off by default: production renders byte-for-byte the same as today. Switched on, it renders `compass-postgres-restored` from the backups, keeping the live owner's password. It points `DATABASE_URL` at the new cluster and gives it its own backup folder. It refuses reusing the live name or archiving into the folder it restores from. The IAM trust command for the new cluster's service account is in the readme and NOT run; best run before any incident. Validated with helm lint and template under Helm 3 and 4.

    3. Barman Cloud plugin. Production runs CNPG 1.28.1 (as declared) with cert-manager v1.20.1. Plugin v0.15.1 (chart 0.8.1) supports CNPG 1.26+, so no operator upgrade is needed first; v0.16.0 needs CNPG 1.30. The operator is installed by Crossplane from devops.library.crossplane (appcluster-comp-v2), not devops.infrastructure.aws.
    - Staged: an opt-in plugin Release in the library repo (branch feature/com-2157-barman-cloud-plugin from staging); the switch on env-staging-uk and env-production-uk-pri in the infra repo; and an ObjectStore (same folder, 30 days, IRSA), the cluster archiving through the plugin, and the nightly backup by plugin in the deployment repo.

    Order (commands in the agent's report and the readme):
    (1) commit the deployment repo's base/readme/CLAUDE.md (safe, renders nothing new) and run the IAM trust command;
    (2) library branch → PR into staging;
    (3) env-staging-uk key, then check the plugin there;
    (4) library staging → main in a CAB window (it also carries other unreleased changes);
    (5) env-production-uk-pri key;
    (6) only then, not near 02:00 UTC, the production values switch to plugin, then check WAL and a base backup from the bucket, then COM-730.

    Couldn't confirm without kubectl: real free space, the operator actually running, and whether IRSA reaches the plugin's sidecar. The bucket checks catch that. If the plugin can't archive, no WAL is lost (it queues on the volume), but point-in-time recovery stops advancing until it's fixed or reverted.

    Also found:
    - The complete-failure runbook named Argo CD's namespace `argocd`; production's is `argo-cd`. Fixed as COM-2158.
    - The deployment readme's bootstrap still says ROLE=compass-prod-app; the real role is compass-app. Pre-existing, left as is.
    - The staged deployment-repo CLAUDE.md gains two rules: never switch on `postgres.restore` to try it, and the plugin must be running before `method: plugin`.
assignee: steve
label:
- chore
priority: high
task_status: done
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