---
id: 01KY72VVXV7VGQ99T999HNHKX3
created: 2026-07-23T08:53:23.003301Z
updated: 2026-07-23T09:08:58.825468Z
type: task
title: Timeline sprint segments follow the sprint schedule
task_status: done
comments:
- id: 01KY72W4RDCWGT889S77241JV1
  author: Steve Vine
  at: 2026-07-23T08:53:32.045371Z
  text: |-
    Steve Vine · 2026-07-12:

    **Plan (agreed scope for this brief):**

    Keep the scheduling logic in one place — the frontend's `sprintSchedule`/`sprintState` (gantt.ts, unit-tested, already driving the per-project Gantt) — and have the backend carry the raw facts the Timeline payload is missing:

    **Core (`runtime::timeline_projects`)** — `TimelineSprint` gains:
    - `plan_start` / `plan_days` — the sprint's own DEV-969 fields, verbatim, for the schedule chain;
    - `latest_open` — the latest planned day (due, else start) among the segment's *open* members, so the frontend can evaluate the "open task planned beyond the sprint" red rule without per-task data;
    - empty listed sprints now **emit segments** (previously skipped): a planned sprint occupies calendar time, the linked chain needs it, and it should chart — mirroring the DEV-969 Gantt decision. (Side benefit: segment numbering now always matches the note's sprint positions.) Sprint 0 stays skip-when-empty.

    The derived `start`/`due` (member-task envelope) stay — they still anchor the project's fallback envelope.

    **gantt.ts** — extract the counts-based core of `sprintState` as `sprintStateFrom(done, total, latestOpen, end, today)`; `sprintState` delegates to it. Unit tests for the new entry point.

    **TimelineChart** — fetch the Default Sprint Duration; per project: anchor = explicit Start, else the task-derived envelope start, else today; run `sprintSchedule` over the listed segments; Sprint 0's slot = the effective envelope. Segments chart their scheduled slots; the project envelope and the day range extend over the slots so planned sprints are always visible; segments take the Gantt bands' green (all done) / red (slipping) / accent states.

    No Tauri command signature changes (the frontend already has `default_sprint_duration`), no MCP/API surface changes.
- id: 01KY72WBQR2H9THR92V0180YV5
  author: Steve Vine
  at: 2026-07-23T08:53:39.192308Z
  text: |-
    Steve Vine · 2026-07-12:

    **Done — in review.** PR: https://github.com/Steve-vine/notuvia/pull/303

    **What was done:** the plan as posted — `TimelineSprint` gained `plan_start` / `plan_days` / `latest_open` and empty listed sprints now emit segments; `sprintState`'s counts-based core extracted as `sprintStateFrom` (gantt.ts, tested); TimelineChart computes each project's slots with the shared `sprintSchedule`, charts segments on them (Sprint 0 = the effective envelope), extends the envelope/day-range over the slots, and colours segments green/red/accent to match the Gantt bands, with slot tooltips.

    **Decisions made on the fly:**
    - The **drag origin** (DEV-956) is now the slot-extended effective envelope — dragging a project whose dates were derived from its sprint plan stamps those dates explicit, same as the task-derived case before.
    - A project with sprints but no dates anywhere now charts (anchored at today) rather than sitting in Unscheduled — its slots make it dated, consistent with the Gantt.
    - Segment numbering now always matches the note's sprint positions (previously an empty sprint's absence shifted later numbers down).

    **Problems encountered:** none. All checks clean (`npm run check`/`test` 190/`build`, `cargo test`/`fmt`/`clippy -D warnings`).

    **Testing note:** as with DEV-969 — restart the app after merging so the new bundle loads.
assignee: steve
label: follow_up
priority: medium
project: 01KY6W9951TW0904DT0GGJVGE7
number: 317
---
DEV-969 gave sprints a scheduled slot (start + duration, chained when linked) and the per-project Gantt view charts bands from it. The portfolio **Timeline** still derives its sprint segments from member-task dates, backend-side (`runtime::timeline_projects` → `TimelineSprint`), so the two views can disagree about when a sprint runs.

Move the Timeline's segment spans onto the same schedule:

* compute the slot chain in `timeline_projects` (the Default Sprint Duration needs passing into core, or the chain computed frontend-side from the sprints the row already carries),
* Sprint 0 spans the project envelope,
* Carry the done/late/normal state through for segment colouring, matching the Gantt bands.

---

Linear DEV-970 · created 2026-07-12 · done 2026-07-12