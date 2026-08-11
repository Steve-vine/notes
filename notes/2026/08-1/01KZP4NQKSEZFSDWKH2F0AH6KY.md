---
id: 01KZP4NQKSEZFSDWKH2F0AH6KY
created: 2026-08-10T15:29:17.433809Z
updated: 2026-08-11T18:37:59.295789Z
type: task
title: A severity override cannot be narrower than a whole connector's alert surface
project: 01KX671DATY39VW6GWK3M2T3DN
number: 636
sprint: s1rgnyx
comments:
- id: 01KZR2W0BHTS3MKB3KS6QX7YXW
  author: Steve Vine
  at: 2026-08-11T09:36:14.705147Z
  text: |-
    PR #593 (stacked on #592). The decision settled the way the body recommended: **both** new rungs, because they answer different questions and neither substitutes for the other.

    **Migration 0126** adds `source_key` and `entity_id`, both nullable wildcards like the three already there.

    - `source_key` = "this monitor". It needs no new identity concept — it is already unique per system, so it is the signal's own name.
    - `entity_id` = "this host's alerts", the scope `ObservationSuppression` has had since the estate graph landed and alerts could not reach.

    **The specificity ordering turned out to be the load-bearing part**, and the body was right to flag it. Counting pinned fields breaks the moment there are five rungs: `(system, signal_type)` and `(kind, source_key)` both pin two fields and are not remotely the same rule, so a per-monitor override would lose to a per-kind one on whichever `max` saw first — and narrowing the scope would achieve nothing at all. `scope_specificity` now reads rungs narrowest-first as a comparable tuple. While there, the two copies of the matching logic (`severity.py` and the one I had added in `signal_decision.py` for ISE-635) became one; two ladders that could drift is exactly the defect this task describes, one level up.

    **One judgement not in the body: `ON DELETE CASCADE` on the entity FK**, where `issue.entity_id` (0124) and `finding.entity_id` both `SET NULL`. Those two record history and must survive their subject. This is a live rule *about* a subject, and a rule whose entity is gone would silently widen from "this host" to "every host" at the moment nobody is watching — the same failure as the original bug, arriving by a different route.

    **`kind` stays the default** for the one-click Downgrade. It is what the endpoint has always done, and silently narrowing it would change what an existing habit means. The dialog offers both, narrow first, with ISE-637's live count updating as you switch — 60 becoming 1 says more than any label could.

    Migration pinned against populated data, not just an empty schema: a pre-existing override keeps NULL in both columns and stays exactly as wide as it was. Defaulting them to anything else would narrow every rule in place and un-mute an estate without telling anyone.
assignee: steve
label:
- improvement
priority: high
task_status: done
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