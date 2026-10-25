---
id: 01M5SVRTZQGKVMEBEFB4APZW9C
created: 2026-10-25T15:44:50.679869Z
updated: 2026-10-25T22:12:56.272887Z
type: task
title: 'DDQ: the Completed questionnaire card''s "Left blank" list is collapsed by default — on a fresh DDQ it lists every question'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1305
sprint: ssgnel8
comments:
- id: 01M5T2M527BBATFV143YFHH802
  author: Steve Vine
  at: 2026-10-25T17:44:37.191301Z
  text: |-
    Done — PR #1322 (with COM-1304), merged to main as 40493738.

    On the Completed questionnaire card, "Left blank · n" and "Left out of the evidence pack · n" are each one line with a chevron and their count. A click opens the list as before (each question and why; each pack item, the questions it's on and why); another folds it. Both start folded every time the page opens, so the card reads as the two download buttons and two counts. The DRAFT note, the buttons and "Written with a note" are unchanged (that last list is short and stays open).

    My calls, as in the task: both lists get the same treatment; folded every time.
assignee: steve
label:
- improvement
priority: low
task_status: done
---
## What Steve said

Smoke-testing sprint 86 on DDQ-5, after COM-1304: "Same for the Completed questionnaire section, there's a huge list of 'Left blank...' collapse these as well."

On a DDQ still being answered, the card lists every question not yet approved (31 on DDQ-5), pushing the download buttons' context off the screen.

## Behaviour

- On the **Completed questionnaire** card, **"Left blank · n"** is one line, collapsed by default, with a chevron. Opening it shows the list as now: each question and why ("Not answered yet", "Not approved yet", "Held back — …").
- **"Left out of the evidence pack · n"** (COM-1302) collapses the same way, so the card reads as two buttons and two counts. (My call: the same treatment for both lists, as they sit together.)
- The counts stay visible when collapsed, so it's still clear at a glance that something will be left out.
- Collapsed every time the page opens, as in COM-1304. The "DRAFT" note and the download buttons are unchanged.

## Implementation notes

- `src/ddq/completed/CompletedCard.tsx`: the `Listed` blocks for left blank and left out of the pack (`LeftOutLine`). Wrap each list in Mantine `Collapse` behind a header button with the count and a caret; `aria-expanded` on it. Share one small `CollapsedList` component with COM-1304's Questions card block.
- Update `Completed.test.tsx` and `Pack.test.tsx`: the entries are hidden until the header is clicked; the count line is visible.
- Independent: frontend only, no migration, no API change. Pairs naturally with COM-1304 in one PR.