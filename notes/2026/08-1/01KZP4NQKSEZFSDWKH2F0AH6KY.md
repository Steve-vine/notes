---
id: 01KZP4NQKSEZFSDWKH2F0AH6KY
created: 2026-08-10T15:29:17.433809Z
updated: 2026-08-10T15:29:45.249888Z
type: task
title: A severity override cannot be narrower than a whole connector's alert surface
project: 01KX671DATY39VW6GWK3M2T3DN
number: 636
sprint: s1rgnyx
assignee: steve
label:
- improvement
priority: high
task_status: backlog
---
Raised 2026-08-10 out of [ISE-635]. One override muted every DataDog monitor alert in the estate for five days — and that was the *narrowest scope the model can express*, not a mis-set one.

**The scope is three columns.** `severity_override` is unique on `(system_id, signal_type, kind)`, and `severity.py:60` matches on exactly those three (NULL = wildcard). There is no `source_key`, no `entity_id`, no per-monitor dimension.

**`kind` is a per-connector accident, not a per-signal identity.** DataDog emits one kind for its entire monitor surface — `connectors/datadog.py:1485`, `kind="monitor_alert"` — covering all 60 monitor findings on staging (33 at high or above). Compare Kubernetes (7 kinds: `pending_pod`, `crashloop`, `oom_kill`, `unhealthy_workload`, `node_not_ready`, `node_pressure`, `node_flapping`), GitHub (3), EntraID (4). So the override's grain is fine for some connectors and useless for the one carrying the most signals: to quieten one noisy synthetic you must downgrade every DataDog monitor.

**And for alerts there is no fallback.** The mute ladder has fine grain everywhere except here:

| Tool | Scope | Applies to |
| --- | --- | --- |
| Ignore | one signal | any |
| Silence | one signal | any |
| Observation suppression | `(entity_id, kind)` | **observations only** — `suppression.py:38` returns None for an alert |
| Severity override | `(system_id, signal_type, kind)` | any |

`ObservationSuppression`'s own docstring calls itself "the estate-graph scope the override layer could not express until the entity graph existed (ISE-115)" — the entity graph now exists, and the override layer still cannot express it. The gap is closed for observations and open for alerts.

**This is the same defect shape as [ISE-632]**: `kind` is being asked to carry a distinction it does not hold. There it makes a hand-typed kind match nothing; here it makes one monitor's tuning hit sixty.

**The decision to settle**: what does an override key on? Adding `source_key` makes "this monitor" expressible and is cheap (it is already unique per system). Adding `entity_id` makes "this host's alerts" expressible and matches the suppression model. Both are additive columns on an existing scope tuple, but the unique constraint and the specificity ordering in `_specificity` both have to grow with them — a narrower scope must win over a broader one, or a per-monitor override loses to a per-kind one.

**Acceptance**: a single noisy monitor can be downgraded without touching its 59 siblings; a more specific override wins over a broader one; alerts can be scoped to an entity the way observations already can.