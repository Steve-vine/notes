---
id: 01KZTQNY9Y98H6EZ57ANWHCX5V
created: 2026-08-12T10:18:24.958953Z
updated: 2026-08-12T10:18:41.937466Z
type: task
title: Add env to the RDS claims so mp-env is populated on RDS resources
project: 01KZTJ50S657DMMC3VFEFWN78V
number: 4
sprint: s6sx8uq
blocked_by:
- 01KZTMWVJHE399BV48PWQR6ZP0
assignee: steve
label:
- follow_up
priority: medium
task_status: todo
---
Follow-on from CPL-2. `mp-env` currently renders as an empty string on every RDS resource. Work happens in **devops.infrastructure.aws** (the claims), not in this repo.

## Why

Every other composition binds `{{- $p := .observed.composite.resource.spec.parameters.project }}`, and those claims supply `parameters.project.env` (e.g. `"staging"`). The two rds comps are the exception — they bind `$p` to the whole `parameters` block:

```
apis/rds/mariadb-comp-v2.yaml:26  {{- $p := .observed.composite.resource.spec.parameters }}
apis/rds/pgsql-comp-v2.yaml:26    {{- $p := .observed.composite.resource.spec.parameters }}
```

and the live claims have no `env` key. Their `envPrefix` is not an environment — it is set to the full project name (`kora-uk-staging-mariadb`), so it cannot stand in.

Result: `mp-project` is correct on RDS, `mp-env` is present but empty. Shipping in that state was a deliberate call (agreed 2026-08-12) rather than an oversight.

## The work

Add `env` to `spec.parameters` in the three RDS claims:

- `env/staging/build/env-staging-kora-uk-staging-mariadb-xr.yaml` → `env: "staging"`
- `env/staging/build/env-staging-kora-us-staging-mariadb-xr.yaml` → `env: "staging"`
- `env/production/build-pri/env-production-kora-uk-production-mariadb-xr.yaml` → `env: "production"`

Use the same values the fullstack claims use for `parameters.project.env` in each environment, so RDS lines up with everything else in cost reports. No pgsql claims exist yet — whoever adds the first one needs to include `env` from the start.

No composition change is needed: `{{ $p.env }}` is already in place and starts resolving as soon as the claim carries the key. Verify after sync with `aws rds list-tags-for-resource` on the instance ARN, or by filtering the estate on `mp-env`.

## Alternative if the claims cannot change

Rebase the two rds comps onto a nested `project` block like every other composition. That is the tidier long-term shape but a breaking parameter change for existing claims, so it is not worth doing purely for a tag.