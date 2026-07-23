---
id: 01KY72TXEHFYB8SM6JQEN54EK2
created: 2026-07-23T08:52:51.793492Z
updated: 2026-07-23T09:18:09.21747Z
type: task
title: Sprint durations
label: null
task_status: done
assignee: steve
priority: medium
project: 01KY6W9951TW0904DT0GGJVGE7
number: 316
comments:
- id: 01KY72V88P9MMJAXQBF35JRBAJ
  author: Steve Vine
  at: 2026-07-23T08:53:02.870368Z
  text: |-
    Steve Vine · 2026-07-12:

    **Plan (agreed scope for this brief):**

    **Data model** — `Sprint` (core `runtime.rs`, mirrored in `notes.ts`) gains two optional fields, stored in the project's frontmatter:
    - `start: Option<String>` (`YYYY-MM-DD`) — `None` means "Linked": the sprint starts the day after the previous one ends; Sprint 1 anchors to the project's first day.
    - `duration_days: Option<u32>` — `None` means "use the Default Sprint Duration setting".

    Both are `serde(default)` + skipped when unset, so existing frontmatter round-trips untouched. `ops::set_project_sprints` / the MCP `SprintEntry` gain the same optional fields (full-replacement semantics, consistent with `description`).

    **Settings** — new `default_sprint_days` field on `AppConfig` (default 7), `default_sprint_duration` / `set_default_sprint_duration` Tauri commands, and a new **Projects** section in Settings with a "Default sprint duration" days input.

    **Scheduling (pure helper in `gantt.ts`, unit-tested)** — `sprintSchedule()`: resolves each listed sprint to a day span by chaining — explicit start wins, otherwise the day after the previous sprint's end; Sprint 1 falls back to the project's first day (project Start, else the dated-task envelope, else today); duration = per-sprint override else the default. Sprint 0 spans the full project envelope.

    **Gantt view** — sprint bands take their position/width from the schedule instead of the member-task envelope; scheduled days join the range computation so bands are always visible.

    **Bar colours (Gantt bands + project-note sprint bars)** — green when all member tasks are done; **red** when (1) today is past the sprint's last day and open tasks remain, or (2) an open member task's bar extends past the sprint's last day (its due — or start when due-less — is later than the sprint end); blue otherwise. Green takes precedence (a fully-done sprint has nothing left to slip). Interpreting "completion dates" as the open tasks' planned dates, since actual completion timestamps aren't stored.

    **Project note page** — each sprint row gains a Start date input (empty = "Linked") and a Duration days input (placeholder shows the default). Sprint 0 stays fixed.

    **Out of scope / follow-up** — the portfolio Timeline still derives its sprint segments from member tasks backend-side; switching it to the schedule is filed as a follow-up.

    Note: overlaps DEV-968 on the same bar markup — DEV-968's PR merges first, this branch rebases over it.
- id: 01KY72VKE7W0V2672QX7JSZKBZ
  author: Steve Vine
  at: 2026-07-23T08:53:14.310769Z
  text: |-
    Steve Vine · 2026-07-12:

    **Done — in review.** PR: https://github.com/Steve-vine/notuvia/pull/302

    **What was done:** the plan as posted — Sprint gains optional `start` / `duration_days` in frontmatter (flowing through `update_note`, `ops::set_project_sprints`, the MCP tool, and the HTTP API spec); a new **Projects** Settings section holds the Default Sprint Duration (`default_sprint_days`, 7); the project note's sprint rows gain Start + Duration inputs with the resolved slot shown alongside (`linked · 2026-07-13 → 2026-07-19`); the Gantt charts bands from the schedule (pure `sprintSchedule`/`sprintState` in `gantt.ts`, unit-tested) with green/red/blue states on both the bands and the note-page bars.

    **Decisions made on the fly:**
    - "Completion dates beyond the sprint" is read as **open** tasks' planned dates (due, else start) — actual completion timestamps aren't stored, and a done task that ran long is history, not slippage. Green (all done) beats red.
    - An **empty listed sprint now charts its band** in the Gantt (it has a plan of its own); previously empty sprints were skipped. Sprint 0 stays skip-when-empty — it's a bucket, not a plan.
    - With no project Start anywhere (no date, no dated tasks), the chain anchors to **today** so an undated project still plans.
    - A malformed hand-edited start falls back to linked rather than erroring (the repo's "files are hand-editable" idiom).

    **Problems encountered:** none. `npm run check` / `npm test` (189, 9 new) / `npm run build` / `cargo test --workspace` / `fmt` / `clippy -D warnings` all clean.

    **Follow-up filed:** DEV-970 — the portfolio Timeline still derives sprint segments from member tasks backend-side.

    **Note for testing:** the notuvia-mcp sidecar is a separate process — an older MCP build calling `set_project_sprints` (full replacement) would silently drop the new fields; rebuild the debug MCP before exercising sprints through Claude.
sprint: segj1dz
---
In settings, add a 'Default Sprint Duration', defaulting to 7 days.

On the Project note page, add a start date and a duration (in days) to sprints.

Start date.  Default to 'Linear', meaning no date, it just starts when the previous one finishes. Or can specify an actual date.

Duration.  Add the 'Default Sprint Duration', but allow this to be changed on each sprint.

Then in Gantt view, show the sprint start point and duration based on this rather than evaluating the contained task.  Unless specified, each sprint starts immediately following the previous one, with the first one (Sprint 1) starting on the first day of the project unless otherwise set.  Sprint 0 - which is any unassigned tasks always starts on the first day of the project and lasts for the same duration as the full project.

Sprint bars show the % complete as they do now but change to red if, 1. the current date has past the last day of the sprint and there are still tasks open or 2. there are tasks in the project which have completion dates beyond the last day of the sprint.

---

Linear DEV-969 · Enhancements · created 2026-07-12 · done 2026-07-12