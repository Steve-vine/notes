---
id: 01M5SVGHFGSBAG7ZJG3XKJJVQF
created: 2026-10-25T15:40:18.800533Z
updated: 2026-10-25T22:12:56.257775Z
type: task
title: 'DDQ: "Left out when Polaris set it up" is collapsed by default on the Questions card — it reads as noise under the progress bar'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1304
sprint: ssgnel8
comments:
- id: 01M5T2KYXMCG1CRQK1YKG2WK1K
  author: Steve Vine
  at: 2026-10-25T17:44:30.899673Z
  text: |-
    Done — PR #1322 (with COM-1305), merged to main as 40493738.

    On a DDQ's Questions card, "Left out when Polaris set it up · n" is now one dimmed line under the progress bar with a chevron. A click opens the list of what set-up left out and why; another click folds it. It starts folded every time the page opens. Only people who manage DDQs see it, and only when something was left out — unchanged.

    The fold is a small shared component also used on the Completed questionnaire card (COM-1305), so the three lists behave the same.

    No calls awaiting Steve beyond those already in the task (folded every time, dimmed line).
assignee: steve
label:
- improvement
priority: low
task_status: done
---
## What Steve said

Smoke-testing sprint 86 on DDQ-5: "I notice in the question pane under the question progress bar there's a new section that start 'Left out when Polaris set it up · ...' This just feels like noise, can you raise a task to put that in a collapsed section."

## Behaviour

- On the DDQ's Questions card, the list of what Polaris's reading left out (COM-1293) is **collapsed by default**: one line under the progress bar, **"Left out when Polaris set it up · 6"**, with a chevron.
- Opening it shows the list as now: each part left out and why ("Sheet1, B3: general guidance for the whole form (“The Business Continuity Questionnaire…”)").
- It is only shown to people who manage DDQs, as now, and only when something was left out.
- My call: it starts collapsed every time the page opens (no remembering it open), and the line is dimmed so it sits quietly under the progress bar.

Nothing else changes: what's recorded, Polaris's read of the DDQ, or how a set-up replaces the list.

## Implementation notes

- `src/ddq/questions/QuestionsCard.tsx`: the `role="note" aria-label="Left out at set-up"` block under the progress `Progress.Root`. Wrap the list in Mantine `Collapse` behind an `UnstyledButton` / `Anchor` header showing the count and a `CaretDownIcon`/`CaretRightIcon`; `aria-expanded` on the header.
- Update the COM-1293 test in `Questions.test.tsx` ("there is no Add question on any DDQ; what the reading left out is listed"): the list is hidden until the header is clicked.
- Independent: frontend only, no migration, no API change.