---
id: 01KXTRVAJCCVD92GZQJJF49VY4
created: 2026-07-18T14:07:26.284865941Z
updated: 2026-07-21T18:31:30.868974Z
type: task
title: Fix the DataDog idle-drain leak — stabilise the metrics-slice summary
project: 01KX671DATY39VW6GWK3M2T3DN
number: 109
sprint: scxrykd
assignee: steve
priority: high
task_status: done
---
**Sprint 10 (spend relief).** The DataDog `_metrics` slice builds its summary as a rolling 1-hour active-metrics **count** (`connectors/datadog.py:533-537`, `int(time.time()) - 3600`). That count drifts constantly on any live estate, so `snapshots_fingerprint` (`ai/fingerprint.py`) changes every cycle → `due_for_summary` is always true → `dispatch_summaries` (`worker.py:64`, every 900s) re-fires the summarise agent for the DataDog system forever, with no user activity. This survives the ISE-44 fix, which closed `taken_at` churn but not volatile content *inside* a summary.

## Scope
- Make the metrics-slice summary **stable** (drop the volatile count / replace with a stable descriptor) or drop the slice from the summarise fingerprint. Prefer the direction the re-architecture takes anyway: metrics are *evidence-on-demand*, not state that drives scheduled AI.
- Note the analyse gate has a sibling issue (monitor severity flaps re-arm the Opus analyse) — the Sprint 11 monitors-only reshape addresses that; no fix needed here.

## Optional follow-on (interim)
While the Obs Loop (Sprint 14) is built, consider lowering/gating `dispatch_summaries`/`dispatch_analyses` cadence (`worker.py:64-73`) to stem idle spend now — a config change, reverted when the Obs Loop lands.

## Acceptance
On a static 2-system staging estate, idle `summarise-state`/`analyse` dispatch drops to ~0/hr (no new `AgentRun` rows while nothing changes). Refs: `connectors/datadog.py:533-537`, `ai/fingerprint.py`, `tasks/ai/summarise.py`, `worker.py:64-73`.