---
id: 01M5SWNPTNZEC8XRP8PFJ445KE
created: 2026-10-25T16:00:36.693169Z
updated: 2026-10-25T17:32:00.911817Z
type: task
title: 'DDQ: the "Sent back: …" line in the questions list is unreadable in dark mode — fixed dark-orange text; use colours that follow the theme'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1308
sprint: ssgnel8
assignee: steve
label:
- bug
priority: medium
task_status: active
---
## What Steve saw

Smoke-testing sprint 86 on DDQ-5: "When an answer is rejected and a comment is added, the comment appears on the question list E.g. 'Sent back: Left out when Polaris set it up · 6'. The text is in dark red which is impossible to read in dark mode, OK in light though."

## Behaviour

- **"Sent back: <reason>"** under a question's status in the questions list reads clearly in **both light and dark mode**. It's still in a warning colour, so it stands out from the dimmed lines around it.
- The same goes for every other coloured line added in sprint 86, which use the same fixed shades:
  - **"Last time we said this (DDQ-n) — confirm it's still true"**, in the questions list, the question window and the Review box (COM-1292);
  - the **warnings on each row of Review answers** (COM-1300): held back, no longer citable, no source in Compass, last time.
- Nothing else changes: the words and when they show.

## Cause

The lines use fixed Mantine shades, picked for a light background:
- `c="orange.8"` for Sent back, in `src/ddq/questions/QuestionsCard.tsx` and in `ReviewAnswersModal.tsx` for warnings that don't block approval;
- `c="blue.7"` for the last-time line, in `QuestionsCard.tsx` and `answers/AnswerForm.tsx`.

A fixed shade doesn't change with the colour scheme, so dark orange on the dark background has almost no contrast.

## Implementation notes

- Use the scheme-aware text colours instead: `c="var(--mantine-color-orange-text)"` and `c="var(--mantine-color-blue-text)"`, or a `light-dark()` pair. This is the pattern the screen-conventions brief uses (`brief/information-architecture.md` → *Screen conventions*, fixed palette from sprint 65).
- Grep `src/ddq` for any other `c="<colour>.<shade>"` on text added this sprint.
- Test: assert the Sent back and last-time lines use the theme-aware colour variable, not a fixed shade. Check both schemes in a real browser.
- Independent: frontend only.