---
id: 01M54K5M5TJ48FR4MDKQN96EW7
created: 2026-10-17T09:30:29.434248Z
updated: 2026-10-17T15:25:48.417218Z
type: task
title: The SAP schedule can be seen as a timeline or a calendar as well as a list — colour-coded by type, filtered the same way, click an entry to open it
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1047
sprint: sxflvhs
blocked_by:
- 01M54K5437P988KP93SHQ78073
comments:
- id: 01M557G6MN143DFPR4SM83WX7E
  author: Steve Vine
  at: 2026-10-17T15:25:47.541362Z
  text: |-
    Done: merged in PR #1047.

    - The Schedule tab has a List / Timeline / Calendar switch. The choice is kept in the address, so a link opens the same view.
    - Timeline: a quarter or a year across, with Previous, Next and Today. Each entry has its own row, and a repeating entry's occurrences share one row. Bars are coloured by type: a done bar is solid with a tick, an overdue bar has a red outline, and a cancelled bar is faded and struck through. A red line marks today. At phone width the timeline scrolls sideways inside its frame, not the whole page.
    - Calendar: a month grid starting on Monday, with Previous, Next and Today. An entry appears on every day it covers. A full day shows "+N more", which opens the rest.
    - Both views have a legend, and the list's filters apply to all three views. Clicking an entry opens it; hovering shows its title, owner, dates and status.
    - Not yet checked in a real browser. Please look at a busy month during the smoke test.
assignee: steve
label:
- feature
priority: high
task_status: review
---
Sprint 75, SAP - Schedule (ADR in COM-1041). Built on COM-1046, so repeating entries show a whole year.

## What people see

- The Schedule tab gets a **List / Timeline / Calendar** switch. The choice is remembered in the URL, like the list filters (COM-792), so a link opens the same view.
- **Timeline:** one row per entry. Entries in a series sit on one row, so a quarterly review reads as four bars on one line. Each bar runs from the entry's start to its end date.
  - Zoom: Quarter / Year. Previous and next buttons, and **Today**.
  - Bars are coloured by **type**. A done bar is solid with a tick, an overdue bar has a red outline, and a cancelled bar is faded and struck through.
  - A line marks today.
- **Calendar:** a month grid. Entries span the days they cover, coloured by type, with "+3 more" when a day is full. Previous and next month, and **Today**.
- **Legend** of the five type colours, in both views.
- **The list's filters apply to all three views:** type, status, owner, and "overdue only".
- **Click an entry** in any view to open its page. Hovering shows the title, owner, dates and status.
- Readable in dark mode, and at phone width the timeline scrolls sideways inside its card, never the page.

## Rules

- The views only read. Dates are changed on the entry, not by dragging. Dragging could be a later improvement.

## Notes (technical)

- `@mantine/dates` (8.3.18) is installed. Check whether its calendar can draw multi-day spans before building one. The timeline is likely a small custom CSS-grid component. Don't add a Gantt library without a reason in the PR.
- Type colours come from the fixed palette (sprint 65; `tokens.ts`). Assert the resolved colour, not the name (memory: Mantine autoContrast needs a shade).
- Many bars and a dense month need a real-browser look before merge (memory: headless Chromium layout harness).
- URL state through the `useQueryState` hooks (memory: URL-backed filters / flushSync).

**Done when:** the three views show the same filtered entries, colour-coded by type with done, overdue and cancelled distinguishable, and each opens the entry.