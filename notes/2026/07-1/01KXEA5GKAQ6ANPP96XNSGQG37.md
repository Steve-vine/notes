---
id: 01KXEA5GKAQ6ANPP96XNSGQG37
created: 2026-07-13T17:59:58.314774588Z
updated: 2026-07-21T16:39:21.566595Z
type: task
title: Spend ceiling blocks operator-triggered runs — ISE stops answering humans
project: 01KX671DATY39VW6GWK3M2T3DN
number: 57
sprint: sdcd2jr
assignee: steve
priority: high
task_status: done
---
Found during the ISE-53 exit test (2026-07-13). The code does not do what its own design says.

`settings.py:63` describes the intended behaviour:

> "Per-provider daily spend ceiling (USD). Crossed -> **scheduled AI tasks pause** and the UI surfaces a banner; **operator-triggered runs prompt to confirm** (enforced by the engine, ISE-36)."

But `ai/engine.py:68` checks `_daily_ceiling_reached()` **unconditionally, for every task type**. There is no distinction between scheduled and operator-triggered work, no confirm path in the engine, and no banner or confirm dialog in the UI. An operator-triggered run is hard-refused exactly like a scheduled one:

```
{"error": "daily spend ceiling reached"}
```

Live consequence: scheduled `analyse` runs burned 98.5% of the day's ceiling re-analysing unchanged state ([[ise-44]]), and then `propose-remediation` — the action a human explicitly clicked, the whole point of Phase 4 — was refused. **The busywork starved the request.** ISE stops answering humans precisely when it is busiest, which is exactly when they need it.

The asymmetry matters: a scheduled run nobody asked for is the right thing to sacrifice under a budget. A run a human is sitting there waiting for is the last thing you should sacrifice, and it is also the one whose cost a human has implicitly accepted by asking.

Fix:
- Split the check: scheduled task types (dispatch_summaries / dispatch_analyses) pause at the ceiling; operator-triggered ones (diagnose, propose-remediation) do not.
- Give operator-triggered runs the confirm path the setting already promises: over-ceiling, the API returns a "would exceed ceiling" state and the UI asks the operator to confirm, then proceeds with `confirmed=true`. Audited as a deliberate over-budget run.
- Surface the ceiling in the UI (banner + the AI-spend panel from ISE-42) so it is visible BEFORE someone clicks and gets refused.
- Consider a reserve: e.g. scheduled work may only consume N% of the ceiling, leaving headroom for humans by construction.