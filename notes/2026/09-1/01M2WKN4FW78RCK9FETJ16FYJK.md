---
id: 01M2WKN4FW78RCK9FETJ16FYJK
created: 2026-09-19T10:33:38.556068Z
updated: 2026-09-19T10:35:26.734084Z
type: task
title: The CNPG example pairs an image with backups it cannot run — `standard` has no barman-cloud
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 727
sprint: stek6vx
comments:
- id: 01M2WKRDDX98CJJ67GYN7S0TPY
  author: Steve Vine
  at: 2026-09-19T10:35:26.013795Z
  text: |-
    Example fixed: merged to main 2026-09-19 as 61d3746 (PR #732) — `examples/cnpg-cluster.yaml` now uses `16.15-system-bookworm`, says which image flavour goes with which backup method (system + built-in barmanObjectStore; standard/minimal + the Barman Cloud Plugin), names the symptom (Ready, but ContinuousArchiving False and an empty bucket) and gives the command that shows it.

    Production: the same image swap is staged, not committed, in `~/code/devops.application.compass` (`envs/prod-uk-compass-env.yaml`, `base/values.yaml`); rendered diff is the one imageName line. Waiting on Steve to commit and push; then verify ContinuousArchiving True and files under `s3://mp-envproductionpri-compass-prod-files/postgres-backups/`. Leaving this task in Review until that is seen. AWS side checked and correct (role `compass-app` trusts compass-prod:compass-postgres; policy allows the bucket).

    Follow-up worth its own task later: move backups to the Barman Cloud Plugin, which is where CNPG is heading; the built-in method is deprecated upstream.
assignee: steve
label:
- bug
priority: high
task_status: review
---
Found 2026-09-19 on production: the CNPG cluster was healthy and archiving nothing — `ContinuousArchiving: False — unexpected failure invoking barman-cloud-wal-archive: exec: "barman-cloud-check-wal-archive": executable file not found in $PATH`. The bucket was empty hours after go-live.

Cause: `examples/cnpg-cluster.yaml` (and the devops repo's chart, copied from it) uses `ghcr.io/cloudnative-pg/postgresql:16.15-standard-bookworm`. CloudNativePG split its images: `minimal` and `standard` no longer ship the barman-cloud tools, because backups are moving to the Barman Cloud Plugin; only the `system` flavour still carries them for the built-in `backup.barmanObjectStore` that the example's commented backup block uses. My comment there said "the standard image carries the contrib extensions" — true, and beside the point.

**Do**: in `examples/cnpg-cluster.yaml`, say which image goes with which backup method — `system` with the built-in `barmanObjectStore` block (deprecated upstream but works today with no extra install), `standard` with the Barman Cloud Plugin (an `ObjectStore` resource and `spec.plugins`, needs the plugin installed on the cluster) — and make the example internally consistent. State the symptom, because the cluster reports Ready either way. Same note in `scripts/infra/aws-staging/README.md` if that cluster is meant to have backups.

Production fixed in the devops repo by switching to `16.15-system-bookworm` (same Postgres version, rolling replacement).

**Acceptance**: following the example with its backup block uncommented produces a cluster whose `ContinuousArchiving` condition is True; the example says how to check that.