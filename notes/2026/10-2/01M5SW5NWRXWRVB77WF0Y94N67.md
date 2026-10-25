---
id: 01M5SW5NWRXWRVB77WF0Y94N67
created: 2026-10-25T15:51:51.448213Z
updated: 2026-10-25T17:25:14.69952Z
type: task
title: 'DDQ: in Review answers, the Approve / Reject toggles'' text shows through the Save / Cancel / Submit bar when scrolling'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1306
sprint: ssgnel8
assignee: steve
label:
- bug
priority: medium
task_status: active
---
## What Steve saw

Smoke-testing sprint 86 on DDQ-5 (COM-1300): "the text on the Approve and Reject toggle is in front of the Cancel/Save/Submit bar so as you scroll down the text floats over the buttons."

## Behaviour

- The bar at the foot of the Review answers window (the "n of m decided" count, Cancel, Save, Submit) always sits in front of the rows as they scroll under it. Nothing from a row (the Approve / Reject labels, the Add to library switch, the reason box) shows through it.
- The bar has a solid background and a thin top border, so it's clear where the list ends and the bar begins.
- The same applies to the "Discard your review choices?" check, which replaces the bar.

## Cause

`src/ddq/review/ReviewAnswersModal.tsx`: the footer `Group` is `position: sticky; bottom: 0` with a background but **no z-index**. Mantine's `SegmentedControl` puts its labels on their own stacking layer (`position: relative` with a z-index, so they sit above the sliding indicator), so they paint above the sticky footer as they scroll beneath it.

## Implementation notes

- Give the sticky footer (and the discard alert in its place) a z-index above the rows (e.g. `zIndex: 2`, or `var(--mantine-z-index-app)`), keep `background: var(--mantine-color-body)`, and add a top border (`1px solid var(--mantine-color-default-border)`).
- Check the Switch and Textarea also sit beneath it.
- Test: hard to assert stacking in jsdom; assert the footer carries the z-index style, and check it in a real browser (headless Chromium harness) with a DDQ of 30+ rows.
- Independent: frontend only.