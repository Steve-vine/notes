---
id: 01KZV25PVH5NKAXGJ7QC5FT4PK
created: 2026-08-12T13:21:47.377648Z
updated: 2026-08-12T13:22:03.989326Z
type: task
title: Add geo to the claims so mp-geo is populated across the estate
project: 01KZTJ50S657DMMC3VFEFWN78V
number: 5
sprint: s6sx8uq
blocked_by:
- 01KZTMWVJHE399BV48PWQR6ZP0
assignee: steve
label:
- follow_up
priority: medium
task_status: todo
---
Follow-on from CPL-2. `mp-geo` is now stamped on all 64 tag blocks from `{{ $p.geo }}`, but no claim supplies `geo`, so it currently renders as an empty string on every AWS resource in the estate. Work happens in **devops.infrastructure.aws** (the claims), not in this repo.

## The work

Add `geo` to the `parameters.project` block of all ten claims:

- `env/sandbox/build/env-sandbox-xr.yaml` and `env/sandbox/template/env-sandbox-xr-TEMPLATE.yaml`
- `env/staging/build/env-staging-xr.yaml`
- `env/production/build-pri/env-production-xr.yaml`
- `bootstrap/{sandbox,staging,production}/build/bstr-*.yaml`
- `mgnt/{sandbox,staging,production}/build/mgnt-*-xr.yaml`

Plus the three rds claims, which use a flat `parameters` block rather than a nested `project` one — same files as CPL-4, so do both keys in one pass:

- `env/staging/build/env-staging-kora-uk-staging-mariadb-xr.yaml`
- `env/staging/build/env-staging-kora-us-staging-mariadb-xr.yaml`
- `env/production/build-pri/env-production-kora-uk-production-mariadb-xr.yaml`

Don't forget the sandbox TEMPLATE file — a new environment cut from it would otherwise start life untagged.

## Decide the vocabulary first

Nothing in either repo defines what `geo` means, so agree the value set before editing claims — retrofitting a rename across live resources is the expensive part, not the initial tagging.

Worth settling: is it the AWS region (`eu-west-2`), a region group (`uk` / `us`), or a business geography (`emea` / `amer`)? The estate already spans eu-west-2 and us-east-1, and the network keys (`network-envstaginguk`, `network-envstagingus`) and RDS project names (`kora-uk-staging`, `kora-us-staging`) both suggest uk/us as the working distinction. Note that `geo` sits in the `project` block, which is per-claim rather than per-region — a single fullstack claim spawns resources in both eu-west-2 and us-east-1, so a claim-level `geo` cannot distinguish them. If per-region accuracy is wanted, the value needs to come from the network block instead, which is a composition change on top of this.

## Notes

- No composition change is needed for the claim-level approach: `{{ $p.geo }}` is already in place and resolves as soon as the key exists.
- Until then `mp-geo` is present with an empty value on every resource, which is visible in cost reports and estate queries — worth not leaving to drift.
- Related: `env` is used as a cluster-role marker in some claims (`bstr`, `mgnt`) rather than a strict environment, so bootstrap and management resources will report `mp-env: bstr` / `mp-env: mgnt` rather than sandbox/staging/production. Not wrong, but worth knowing before building cost reports on `mp-env`.