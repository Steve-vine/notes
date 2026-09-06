---
id: 01M1V2GXVM4CMDS9SS64XF155S
created: 2026-09-06T09:59:18.644357Z
updated: 2026-09-06T10:11:05.936609Z
type: task
title: the status picker stays put when a maturity definition appears
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 580
sprint: s2fcksg
comments:
- id: 01M1V36G33DNJ9VXYW6ASZ1P63
  author: Steve Vine
  at: 2026-09-06T10:11:05.443875Z
  text: |-
    Done — PR #584, merged to main and deployed to staging.

    One prop: the row aligns to the top instead of centring. The field that grows now grows downward into space and its neighbour does not move.

    COM-568's comment is corrected where it claimed the reorder is what stops the field jumping. On its own it was not — it kept the *maturity* input still and left the status picker moving, which is the whole of this ticket. The reorder still earns its place, for the other reason: the definition reads after the choice rather than before it.

    The test asserts the resolved alignment that lands on the element rather than the prop, and is not a measurement — jsdom has no layout, so every offsetTop is zero and the jump itself is not observable there. What is observable is its cause. Verified it fails without the change (`expected 'center' to be 'flex-start'`).

    Frontend suite green at 1013.
assignee: steve
label:
- bug
priority: medium
task_status: review
---
Found by Steve on staging, 2026-09-06, smoke-testing COM-568.

COM-568 moved the maturity definition below its picker so that choosing a level no longer pushed the maturity box down. It did that — but the **status** picker beside it still moves.

## Why COM-568 only fixed half of it

Status and Maturity share a row, and the row centres its children. So the two were never held in line by their tops; they were held in line by their middles. Moving the definition from above the input to below it changed which way the maturity field grows and nothing else — the field is still taller once a level is chosen, the row is still taller, and centring still pushes everything in it down by half the difference.

So picking a maturity level nudges the status box down, and clearing it pulls the box back up: the same jump COM-568 was reported for, one field to the left.

## What changes

The row aligns its children to the **top**, so a field that grows grows downward into space and its neighbour does not move.

Correct COM-568's comment too, where it claims the reorder is what stops the field jumping. On its own it is not — the alignment is.

## Related

- COM-568 — the reorder this completes.
