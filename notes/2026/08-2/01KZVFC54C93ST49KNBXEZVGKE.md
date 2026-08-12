---
id: 01KZVFC54C93ST49KNBXEZVGKE
created: 2026-08-12T17:12:30.092989Z
updated: 2026-08-12T17:12:30.092989Z
type: task
title: Provision RV_PARAMS_PATH / RV_INPUTS_PATH for external_job spec engines
imported_from: linear
assignee: steve
priority: high
task_status: done
project: 01KZV767QMFTN9CZ3TPGTSAASD
number: 309
---
**Shared substrate gap surfaced by the cloudflare port (**DEV-304**).** The first `external_job` spec-1.0.0 engine cannot receive its params: the dispatcher's jobspec only ever provisions the legacy `RV_OPTS` env var, never `RV_PARAMS_PATH`. Spec 1.0.0 (`docs/engine-spec.md`) makes `RV_PARAMS_PA…

---

*Excerpt — full description in Linear.*

Imported from Linear [DEV-310](https://linear.app/stevevine/issue/DEV-310/provision-rv-params-path-rv-inputs-path-for-external-job-spec-engines)