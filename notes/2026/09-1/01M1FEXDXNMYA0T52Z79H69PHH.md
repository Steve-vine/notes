---
id: 01M1FEXDXNMYA0T52Z79H69PHH
created: 2026-09-01T21:44:58.03799Z
updated: 2026-09-03T21:13:13.084967Z
type: task
title: 'Retire the Obs Loop: observation detection returns to the Integrations'
project: 01KX671DATY39VW6GWK3M2T3DN
number: 768
sprint: s7nj09w
comments:
- id: 01M1MHWCHXKD825Y7857YP9VWA
  author: Steve Vine
  at: 2026-09-03T21:13:01.757548Z
  text: |-
    Built — PR #713 (feature/ise-768-retire-obs-loop), migration 0150. The last of the nine.

    DISSOLVED, NOT RENAMED — taken literally
    It was never a loop. It was an outbound call, a cadence and a name, and all three belonged somewhere else:
    - **the call** (`connector.detect_observations()`) is an outbound harvest, so it now lives in `sync.py` beside the alert poll — both are an Integration talking to the outside world, which is the one thing an Integration does;
    - **the cadence** is the Conductor's, and the bespoke 40-line dispatcher with its own due calculation is now TWO LINES — the same two as `dispatch_syncs` with a different cadence. That is what retiring a dispatcher actually looks like;
    - **the change detection its name implied** went to the Differ.

    It stays SLOW. The 86,400s default exists because it dials out, and that reasoning survives the move intact — it is the Differ that runs per-minute, not this.

    MIGRATION 0150 — the columns carried the dissolved component's name
    `obs_detection_enabled` → `observations_enabled`, `obs_interval_seconds` → `observation_interval_seconds`, `last_obs_run_at` → `last_observation_at`, plus its error twin. A RENAME, not a re-purpose: same meaning, type, nullability and values. `ALTER … RENAME COLUMN` rather than add-copy-drop, because it is atomic and touches no rows — a backfill is where a "safe" rename goes wrong, and there is none here. ADR 0107 §7 is the reason: a layer name is never an object name, and `obs_` was the layer's.

    WENT SLIGHTLY BEYOND THE TASK LIST, deliberately
    The `/systems/{id}/obs-run` route → `/detect-observations`. Same defect as the columns, one line each side, and leaving it would have kept the retired component's name in the API surface — which is the thing the task is clearing.

    WHAT COULD NOT BE RENAMED, AND IS NOT
    The 6,447 `obs_run` and 100 `obs_run_requested` audit rows keep their action names. `audit_event` is append-only by trigger, and the trail records what the component was called when it ran. The audit WRITER therefore still says `obs-loop`, deliberately and with a comment saying why.

    Everything a human reads drops "Obs Loop": the system detail card, the signals empty states, the baseline copy, the spend explanation.

    One trap the tests caught: `test_a_connector_cannot_shadow_a_core_beat_entry` pins the core Beat entry names by hand, so renaming `dispatch-obs-loop` → `dispatch-observations` correctly broke it. The guard did its job.
assignee: steve
label:
- tech_debt
priority: medium
task_status: review
tech: null
---
Per ADR 0107, `obs_loop.py` dissolves rather than being renamed.

Its real job — `connector.detect_observations()` on a per-system cadence — is an outbound harvest, which makes it an ordinary Integration capability. Its cadence moves to the Conductor. The change-detection work its name implies moves to the Differ, which is new code.

**In scope:** move the detector call into the integration path; retire the bespoke dispatcher; migrate `System.obs_detection_enabled`, `obs_interval_seconds` and `last_obs_run_at`.

**Not in scope, and cannot be:** the 6,447 `obs_run` and 100 `obs_run_requested` audit rows keep their names — `audit_event` is append-only by trigger. ADR 0030 keeps its name too; it is amended, not rewritten.

**Watch:** the default cadence is 86,400s today *because* it dials out. That reasoning still applies to the harvest after the move — it is the Differ that runs per-minute, not this.

**Headless.** The only visible change should be that the Obs Loop stops appearing as a thing separate from its integration.

**Blocked by** the Conductor and the Differ.