---
id: 01KZTQNY9Y98H6EZ57ANWHCX5V
created: 2026-08-12T10:18:24.958953Z
updated: 2026-09-09T10:28:56.046131Z
type: task
title: Add env to the RDS claims so mp-env is populated on RDS resources
project: 01KZTJ50S657DMMC3VFEFWN78V
number: 4
sprint: s6sx8uq
blocked_by:
- 01KZTMWVJHE399BV48PWQR6ZP0
comments:
- id: 01M22VD8Q6N4KRDWRAG48DGAYR
  author: Steve Vine
  at: 2026-09-09T10:28:54.117112Z
  text: |-
    Done — verified in staging 2026-09-09.

    Claims repo commits `09b9760` (staging) and `da78eac` (production) added `env` and `geo` to the mariadb claims. Confirmed live on mgnt-staging-uk: all four RDS managed resources carry the right tags in AWS, not just in desired state —

    - `kora-uk-staging-mariadb-db-instance` → `mp-project: kora-uk-staging-mariadb`, `mp-env: staging`, `mp-geo: uk`
    - `...-db-replica`, `...-db-subnet-group`, `...-db-parameter-group` → same

    The RDS instances are also among the 17 resources in the whole estate with no stale `Project`/`env` keys (see CPL-6), because they had no tags before this work — so RDS is the cleanest part of the migration.

    One loose end, not worth its own ticket: `env/staging/build/env-staging-kora-us-staging-mariadb-xr.yaml` is entirely commented out ("US DB not required for now") and its commented parameters carry neither `env` nor `geo`. Whoever uncomments it needs to add both, or it starts life with empty tags that — per CPL-7 — may be awkward to correct afterwards.

    Production claim has `env: "production"` in the file; not verified against the live production resources, as this review was staging-only.
assignee: steve
label:
- follow_up
priority: medium
task_status: done
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