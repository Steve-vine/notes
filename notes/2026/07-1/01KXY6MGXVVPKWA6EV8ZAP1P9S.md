---
id: 01KXY6MGXVVPKWA6EV8ZAP1P9S
created: 2026-07-19T22:06:06.779871768Z
updated: 2026-07-24T13:29:25.807691Z
type: task
title: DataDog connector under-detects firing monitors (overall_state vs per-group live state)
project: 01KX671DATY39VW6GWK3M2T3DN
number: 153
order: 2.0
sprint: skj7tft
comments:
- id: 01KY1X6RQ89YRK8AWGBNCR7S5S
  author: Steve Vine
  at: 2026-07-21T08:38:16.552809Z
  text: |-
    PR #148 → main, merged to staging.

    Root cause confirmed and it was simpler than the ticket's hypothesis: `GET /api/v1/monitor` returns no per-group state unless `group_states` is requested. `list_monitors()` was called bare, so `monitor.state.groups` was never populated, `_alerting_groups` always returned empty, and every monitor fell back to the rolled-up `overall_state`.

    Fix: request `group_states=all` when detecting; distinguish "reports groups, none alerting" (not firing) from "reports no groups" (simple monitor, fall back to overall_state) — conflating those re-derived a phantom monitor-level finding from a stale overall_state and flipped the key shape between syncs, which is the churn half; fold DataDog's implicit `*` group back to "no group" so simple monitors keep their existing `monitor/{id}` identity rather than re-opening as new incidents.

    Awaiting staging smoke test against the two live monitors.
priority: medium
task_status: done
---
**Bug (connector accuracy, connectors/datadog.py).** ISE reports monitors as `recovered` while they are firing in DataDog, so their signals clear and their incidents look stale/closed.

**Found in prod 2026-07-19.** 14 of 15 high `monitor_alert` findings showed `recovered` in ISE while alerting in the DataDog UI (e.g. "Chinwag - UK - Application Exception"). Every produced finding is keyed `monitor/{id}` with **no group** — so `_alerting_groups(m)` is returning empty for all of them and `_monitor_findings` is falling back to `m.overall_state` from `list_monitors()`.

**Cause (to confirm).** `overall_state` from the monitor *list* endpoint lags and/or rolls up multi-group monitors, so a monitor Alerting on one group can read OK overall. `_alerting_groups` isn't extracting per-group `monitor.state.groups`, so per-group Alerts are missed and monitors flip to `recovered` between syncs.

**Fix.** Read live per-group state (the monitor `state.groups` / a search endpoint that returns current group states) and emit one Alert per *alerting group* keyed `monitor/{id}/{group}` — the shape ADR 0025 §3 / ADR 0027 already intend and that `_group_finding` already supports. Verify against the two live monitors above. Watch for churn: today the connector alternates the detected set, marking real alerts `recovered` (feeds incident churn — see the 462 incidents observed).

**DoD.** A monitor Alerting on a group surfaces a firing Alert keyed by that group in ISE that stays firing while DataDog shows it Alert; no spurious `recovered` flips across consecutive syncs of a steadily-alerting monitor.