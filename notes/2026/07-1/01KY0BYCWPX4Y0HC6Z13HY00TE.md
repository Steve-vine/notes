---
id: 01KY0BYCWPX4Y0HC6Z13HY00TE
created: 2026-07-20T18:17:22.070487Z
updated: 2026-07-21T15:30:34.45929Z
type: task
title: Hide Kind and Confidence columns in the alerts list view
project: 01KX671DATY39VW6GWK3M2T3DN
number: 165
order: 5.0
sprint: skj7tft
assignee: steve
label: null
priority: medium
task_status: done
---
In the alerts list both columns are uniform noise: **Kind** is always `monitor_alert` (DataDog is the only alert-capable connector, one kind per detection mechanism) and **Confidence** is always `—` (by design — confidence is Observation-only; Alerts are source-asserted and carry no ISE judgement, ADR 0025/0026, `models.py:266-268`).

Remove both columns from the **alerts** list view only:

- **Keep the data** — no backend/schema change; the fields stay on `Finding` / `FindingRead`.
- **Keep both columns in the observations view**, where kind (crashloop, oom_kill, estate_drift…) and confidence genuinely vary.
- Keep the drill-in detail (`SignalDetail`) as is — it already shows Kind and hides Confidence when null.

## Implementation

`SignalsPage.tsx` renders one shared table for both views with an `isObservation` flag already used to switch the last column (Suppression vs Actions, ~:493). Make the Kind (~:489) and Confidence (~:491) header cells and their body cells (~:547, ~:552) conditional on `isObservation` the same way. Adjust column widths if needed; update SignalsPage tests.