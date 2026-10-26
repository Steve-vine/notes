---
id: 01M5VNJEZ1AC8X5ZDB2T2G9A51
created: 2026-10-26T08:34:59.169049Z
updated: 2026-10-26T09:06:14.617543Z
type: task
title: 'Admin ▸ Polaris: spend limits — a maximum per hour and per day, and Polaris pauses (saying until when) once one is reached'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1328
sprint: s9ls6e7
blocked_by:
- 01M5VNJ79TGJJBDA8YQAQGZREK
assignee: steve
label:
- feature
priority: high
task_status: active
---
## Behaviour

- **Spend limits card** on Admin ▸ Polaris:
  - **Maximum per hour** and **Maximum per day**, in US dollars. Both are required.
  - The day's maximum can't be less than the hour's.
- **The limits cover the whole organisation.** They add up everyone's use of Polaris, whichever provider was used.
- **The hour is the clock hour and the day is the calendar day**, in Compass's time zone (ADR 0121).
- **When a limit is reached:**
  - Polaris finishes the step it's on, then stops.
  - It says in the window: "Polaris has reached this hour's spending limit — it'll be back at 15:00" (or "tomorrow" for the day's limit).
  - New prompts get the same message until then, and spend nothing.
  - The card shows "Hour's limit reached at 14:32" or "Day's limit reached at 14:32".
- **The card shows where today stands:** "$3.20 of $10 this hour · $14.75 of $50 today".
- Lowering a limit below what's already been spent pauses Polaris at once.

## My calls (awaiting Steve)

- The step in progress finishes rather than being cut off mid-reply. This can overshoot the limit by one model call.
- No email or to-do when a limit is hit. The card and the window say it.

## Notes

- **On the chain:**
  - migration: hour and day limit columns on `polaris_settings` (numeric, USD);
  - API: limits in the settings schema plus a `usage` read-out, regenerate schema.d.ts.
- Check the limits before **every** model call in a turn, not once per prompt. A turn is a loop of model calls and tools.
- The check sums the spend ledger (engine task). Run it under a row lock or an advisory lock so two people at once can't both slip under.
