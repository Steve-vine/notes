---
id: 01M5SXS4P17KRBA6HX806G5SRM
created: 2026-10-25T16:20:00.005568Z
updated: 2026-10-25T18:35:03.847456Z
type: task
title: The two download buttons on Completed questionnaire look the same — one style, each as wide as its label
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1311
sprint: ssgnel8
comments:
- id: 01M5T5GCK2YMV34XA5XC64YSFA
  author: Steve Vine
  at: 2026-10-25T18:34:59.554622Z
  text: |-
    Done — PR #1328, merged to main as f8e08efa.

    On the Completed questionnaire card, Download evidence pack now has the same outline style as Download completed file (it was tinted), and so do Download record and Copy reply when they sit beside it. Each button is as wide as its own label, no longer stretched to the filename under it. Captions stay underneath; the pack button is still disabled when there's nothing to include and says "Making the pack…" while it builds.

    Tests check both buttons share the outline style. The width fix (buttons no longer stretched) wasn't checked in a real browser — worth a glance in the smoke test.
assignee: steve
label:
- bug
priority: medium
task_status: review
---
![CleanShot 2026-10-25 at 16.19.37@2x.png](attachments/2026/10/01M5SXS4P17KRBA6HX806G5SRM/CleanShot-2026-10-25-at-16.19.37@2x.png)

Smoke test of sprint 86 round 2 (DDQ-5 on staging, 2026-10-25, fully approved). Found by Steve. Follows COM-1302, which put **Download evidence pack** beside **Download completed file**.

**Chain:** independent (frontend only).

## What's wrong

Once every question is approved, the Completed questionnaire card shows both download buttons side by side, and they look unrelated (screenshot):

- **Download completed file** is an outlined button, stretched to the width of the long filename under it.
- **Download evidence pack** is a tinted (light) button at its natural width.

## What people see after the fix

- Both buttons have the **same style**: the outlined one that Download completed file uses now.
- Each button is **as wide as its own label**, not stretched by the filename or the caption under it.
- They sit side by side on one row, as now. Each keeps its caption underneath:
  - the filename and "31 of 31 questions answered in it" under the completed file;
  - "2 files" (or "No evidence to include") under the pack.
- The same applies to **Download record** (an online questionnaire) and to **Copy reply** (an email DDQ) when either sits beside the pack: one style, natural width.
- Unchanged: the pack button is disabled when there's nothing to include, and shows "Making the pack…" while it builds.

## Notes (technical)

- `completed/CompletedCard.tsx`, `CompletedAction` (~88): the `<Button component="a" size="xs">` takes the default variant. Its wrapping `<Stack gap={2}>` stretches it to the filename's width, since Stack children stretch by default.
- `pack/PackParts.tsx`, `PackAction` (~19): `variant="light"`.
- Fix:
  - give both the same `variant`, and the same on `CopyReply`'s button;
  - stop the stretch with `align="flex-start"` on both Stacks, or `w="fit-content"` on the buttons;
  - use icons at the same size (both 14 already).
- Test: vitest on CompletedCard asserting both buttons share a variant (`data-variant`) would stop the drift coming back. A look in a real browser is needed for the width.
