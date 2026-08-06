---
id: 01KZB6Z99RP9FXPTJ425JZS8V5
created: 2026-08-06T09:37:48.856325Z
updated: 2026-08-06T18:34:33.784639Z
type: task
title: 'Azure evidence timestamps: use Z-suffix UTC — Azure Monitor double-decodes ''+00:00'' offsets into spaces'
project: 01KX671DATY39VW6GWK3M2T3DN
number: 585
sprint: scb3vol
assignee: steve
label:
- bug
priority: medium
task_status: active
---
Found live during ISE Test Plan execution (2026-08-06): `fetch_evidence` → `monitor_metrics` on CSP Softcat fails with HTTP 400 — `Detected invalid time interval input: 2026-08-06T07:30:02.095974 00:00/…` (space where `+` should be).

Root cause is on Microsoft's side but ours to work around: `_ev_monitor_metrics` (`connectors/azure.py:1115`) builds the timespan from `datetime.now(UTC).isoformat()` → `…+00:00`. httpx 0.28.1 correctly sends `%2B` (verified by repro), but Azure decodes the query **twice** — ARM front door `%2B`→`+`, then the Monitor metrics RP form-decodes `+`→space. Any `+00:00` offset in the metrics `timespan` arrives mangled no matter how correctly it is encoded.

Fix: emit Z-suffix UTC timestamps, e.g. `start.strftime("%Y-%m-%dT%H:%M:%SZ")` (or `isoformat().replace("+00:00", "Z")`), for both ends of the timespan.

Also fix the same latent exposure in `_ev_activity_log` (line ~1147): `$filter=eventTimestamp ge '<isoformat with +00:00>'` — switch to Z format in the same change. (`log_analytics_query` uses `PT{n}M` durations and is unaffected.)

Test note: the integration suite is green because nothing exercises live Azure — same "green suite, broken live" pattern as Sprint 47. Add a unit assertion that the generated timespan/filter strings contain no `+`, and verify live via `fetch_evidence` on a real VM (ISE Test Plan §7 checkboxes: monitor_metrics + activity_log).

Bug exists identically on main and staging.