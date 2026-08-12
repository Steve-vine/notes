---
id: 01KZVG4149RT4G3TXHQEB8PSVJ
created: 2026-08-12T17:25:32.425146Z
updated: 2026-08-12T17:25:32.425146Z
type: task
title: Dispatcher cleanup `finally` uses narrow `except K8sTransientError:` — broaden to `except Exception`
imported_from: linear
priority: medium
assignee: steve
label:
- follow_up
- bug
task_status: done
project: 01KZV767QMFTN9CZ3TPGTSAASD
number: 378
---
## Symptom (potential, not yet observed)

Dispatcher's K8s Job cleanup in `_run_one_step`'s `finally` block uses a narrow `except K8sTransientError:` handler. Any non-transient exception from `delete_job(...)` (e.g. `ApiException` with status 400/403/422, a future `K8sNotConfiguredError`, or anything outside the wrapped-transient set) will bubble out of the `finally`, replacing the step's actual return value with a Celery task failure. Same anti…

---

*Excerpt — full description in Linear.*

Imported from Linear [DEV-176](https://linear.app/stevevine/issue/DEV-176/dispatcher-cleanup-finally-uses-narrow-except-k8stransienterror)