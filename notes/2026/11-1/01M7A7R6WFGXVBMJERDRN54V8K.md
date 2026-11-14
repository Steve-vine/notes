---
id: 01M7A7R6WFGXVBMJERDRN54V8K
created: 2026-11-13T10:37:45.743592Z
updated: 2026-11-14T10:26:49.564171Z
type: task
title: 'SAP Calendar: a multi-day entry is one bar across its days, not a full chip in every day'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1789
sprint: spsp226
comments:
- id: 01M7B3BRC65RMFBT191P3K598S
  author: Steve Vine
  at: 2026-11-13T18:40:17.798159Z
  text: |-
    Built — PR #1785 (feature/com-1789-calendar-bars), stacked on COM-1788's #1784; I restack it onto main once #1784 merges, then it merges itself. Frontend only.

    What you'll see on the SAP Calendar month view (Outlook/Google style):
    - A multi-day entry is one bar per week row, titled once. Crossing into the next week it carries on as a new bar on the next row, titled again; the continuing ends are squared off with a small arrow.
    - Each item keeps one line across the week; single-day entries fill the free lines beneath, longest first, then by start date. A quarterly recertification is one bar per week.
    - A day still shows 3 items then "+N more", which opens the day as before. A bar counts against the limit on every day it covers.
    - Done, overdue and cancelled styling, the other-review style with COM-1788's tick, hover and click, shaded outside days and the sideways scroll on narrow screens are unchanged. Each bar is one link with its old name.

    Choices: lane order uses each entry's whole length, so a long entry stays on the top line week to week. An item pushed past the three-line limit is hidden on every day it covers in that row and counted in each of those days' "+N more".

    Tests: SapViews.test.tsx — once per week row, crossing a week, quarterly, lane placement beside a bar, "+N more" per covered day then opening the day. Layout checked in headless Chromium, light and dark.
- id: 01M7BK9N3YCTX7DKTW068RJFQZ
  author: Steve Vine
  at: 2026-11-13T23:18:46.141828Z
  text: |-
    Pre-UAT: Passed (staging 2f72416b, E2E Test Company, as E2E Admin A). Screenshots: ~/compass-uat/spsp226/COM-1789/

    November was already full of long E2E entries, so I added mine (SAP-75 to SAP-81) in quiet months:
    - "E2E pre-UAT COM-1789 Tue-Thu", 12–14 Jan 2027 (Testing): one bar from Tue to Thu, titled once.
    - "E2E pre-UAT COM-1789 crosses the weekend", Thu 21 – Tue 26 Jan: two bars, one per week row, each titled. The first has a ">" at its right end and the second a "<" at its left.
    - Single-day entries A, B, C and D on Wed 13 Jan: two sit beneath the Tue–Thu bar without overlapping, and the day shows "+2 more". Clicking it opens the day in place (all four listed, "Show fewer"). Hovering a chip shows the usual card.
    - "E2E pre-UAT COM-1789 overdue", 13–15 Oct 2026, still Planned: one bar with the red overdue outline.
    - Done entries (SAP-70, SAP-71) keep their tick and solid colour. The cancelled one (SAP-74) is faded and struck through, with its continuing arrows.
    - Other reviews: the three COM-1790 recertifications for 13–27 Feb 2027 are one dashed bar per week row, not a chip on every day. In November the completed ones show COM-1788's tick.
    - Each bar is a single link with its title. The crossing entry has one link per week row.

    Note, not a fail (from the "longest first" lane rule): in the week of 9 Nov the top line is empty Monday to Saturday. It is held by "E2E pre-UAT 1754 five controls", which only starts on Sunday 15th. Meanwhile "E2E pre-UAT sprint 80 plan entry" (1–21 Nov) is hidden behind "+1 more" on every one of those days (see calendar-nov-2026.png). Steve may want the bar shown when a line is free for its whole run in that week.
assignee: steve
label:
- improvement
priority: medium
task_status: done
---
## Why

Steve, testing on 2026-11-13: on the SAP **Calendar**, an entry that runs over several days shows as a separate chip, with full details, on every day it covers. It should be a single bar across those days.

## What's wrong

`app/frontend/src/sap/SapCalendar.tsx` builds a 42-cell month grid. For each day it lists every item whose start ≤ day ≤ end (`onDay`) and draws a full chip in that cell.
- A long entry repeats in every cell it covers.
- Recertifications do the same (COM-1048 other reviews). A quarterly access recertification fills every day of its quarter.

## What changes

The month view works like Outlook's or Google Calendar's.

- **One bar per entry, per week row.** A multi-day entry is a single bar from its first to its last day in that week, with the title once.
- **Crossing a week:** the bar carries on as a new bar on the next row. Its ends are squared off (or carry a small arrow) where it continues. The title repeats at the start of each week row so it's readable.
- **Same line all week.** Each item keeps one vertical position (lane) across the days it covers in that row. Single-day items fill the free lanes underneath, longest first, then by start date.
- **Busy days.** Each day shows up to the current per-day limit (`PER_DAY`). Anything more becomes "+N more", which opens that day as it does today. A bar counts against the limit on each day it covers.
- **Looks as today:**
  - plan entries keep their type colour, the tick when done, the red outline when overdue, and faded and struck through when cancelled;
  - other reviews keep the neutral dashed style, plus the completed tick from COM-1788;
  - hovering and clicking anywhere on a bar works as on a chip now.
- Days outside the month are still shaded. A bar that runs into them continues there.
- **Narrow screens:** the grid already scrolls sideways (min width 700px). Leave it as it is.
- **Accessibility:** each bar is one link, with its existing label, and isn't repeated per day. Day cells keep their gridcell labels.

## Independent

Frontend only. No API change and no migration. It touches the same calendar code as COM-1788, so whichever merges second rebases.

## Done when

- On staging, E2E Test Company: a plan entry spanning Tue–Thu shows as one bar across those three days.
- An entry crossing a weekend into the next week shows as two bars, one per week row, each with its title and marked as continuing.
- A quarterly access recertification shows as one bar per week, not a chip in every day.
- Single-day entries sit beneath the bars without overlapping. A day with more than the limit shows "+N more", and that opens the day.
- Done, overdue and cancelled styling is unchanged.
- Tests in `SapViews.test.tsx` cover:
  - a multi-day entry drawn once per week row;
  - an entry crossing a week;
  - lane placement with a single-day entry beside a bar;
  - the "+N more" count.