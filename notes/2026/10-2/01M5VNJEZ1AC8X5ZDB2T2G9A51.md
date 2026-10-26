---
id: 01M5VNJEZ1AC8X5ZDB2T2G9A51
created: 2026-10-26T08:34:59.169049Z
updated: 2026-10-26T10:52:07.046862Z
type: task
title: 'Admin ▸ Polaris: spend limits — a maximum per hour and per day, and Polaris pauses (saying until when) once one is reached'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1328
sprint: s9ls6e7
blocked_by:
- 01M5VNJ79TGJJBDA8YQAQGZREK
comments:
- id: 01M5VXDH39D1W3NDJ7416F6SQJ
  author: Steve Vine
  at: 2026-10-26T10:52:06.114366Z
  text: |-
    Done — merged to main (PR #1344, migration 0705).

    - **Spending limits card** on Admin ▸ Polaris: Maximum per hour and Maximum per day, in US dollars, saved together. The day's maximum can't be less than the hour's, and the server's message shows on the card.
    - **Both limits are needed before Polaris can be switched on.** Clearing one switches it off.
    - **The card shows where things stand**, e.g. "$3.20 of $10.00 this hour · $14.75 of $50.00 today".
    - **While paused** it says "Hour's limit reached at 13:32 — Polaris is back at 14:00", or "Day's limit reached … back tomorrow", in your own time format.
    - **The window says the same.** A prompt sent while paused is refused with those words and spends nothing.
    - **The hour is the clock hour and the day is the calendar day, on Compass's own clock.** The hour the clocks go back is still an hour long.
    - **The limits are checked before every model call in a turn**, not once per prompt.

    My calls (beyond the task):
    - **The spend ledger was built here, not in the engine task**, because the limits can't be checked without it. Deleting a conversation keeps its spend.
    - **No lock is held across a model call.** That would make one person wait for another's reply. So spend can pass a limit by one call for each conversation answering at that moment.
    - **Raising a limit takes effect at once.** There's no cooldown.
assignee: steve
label:
- feature
priority: high
task_status: review
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
