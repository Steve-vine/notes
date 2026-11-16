---
id: 01M7HWFGPQJHE5CNZ2775J3HV4
created: 2026-11-16T09:54:42.007745Z
updated: 2026-11-16T15:06:27.721596Z
type: task
title: 'Workflow builder: a new condition''s "If yes, goes on to" and "Otherwise, goes on to" lists are empty, with nothing to say why or what to do'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1860
sprint: s7nqsy0
comments:
- id: 01M7J7A9QN2RFJW9BQG2FDDWE3
  author: Steve Vine
  at: 2026-11-16T13:04:05.365183Z
  text: |-
    Done — PR #1855, merged to main (29735732). Not on staging yet; it goes with the rest of sprint 117 round 2.

    - When a block is open, each of its paths ("If yes, goes on to", "Otherwise, goes on to", "Then goes on to") now offers "Add one here: A new action / A new condition". Picking one adds the block on that path and opens its settings.
    - The other blocks on the canvas are still listed as before. "Nothing: it stops here" still stops the path.
    - A new block starts empty and is marked as needing "What to do" or "What to check" until you choose.
    - A read-only workflow, or one already at 40 steps, offers nothing to add.

    To check on staging: build a workflow from one condition using only the side panel. Add Compliant on Yes and Non-compliant on Otherwise; the sentences should read both paths.
- id: 01M7JEAC094432YFNKNPH42CKQ
  author: Steve Vine
  at: 2026-11-16T15:06:27.721348Z
  text: |-
    **Pre-UAT: Passed** (staging 43d03f09, E2E Test Company, E2E Admin A)

    Steps and what I saw:
    - New workflow ▸ Blank. Added one condition ("The evidence's check" = CHK-2) from the palette, using only the side panel from then on.
    - With nothing else on the canvas, "If yes, goes on to" opened with "Add one here: A new action / A new condition". Both paths' placeholders read "Nothing: it stops here".
    - Chose A new action on Yes. It was added, joined to Yes and opened, marked as needing "What to do". Set it to "Set this evidence's status: Compliant".
    - On Otherwise, the list showed "Blocks on the canvas: Set its status to Compliant" with the add choices beneath it. Added a new action there and set it to Non-compliant.
    - An action's "Then goes on to" offers the same: the canvas blocks, then "Add one here".
    - Clearing a path with its clear button empties it, shows "Nothing: it stops here" again, and removes the line.
    - The Sentences view reads: When evidence is collected → If the evidence was collected by CHK-2 → Then: Set its status to Compliant → Otherwise: Set its status to Non-compliant. Saved as WF-7.

    Minor, not a failure: until "What to do" is chosen, a new action's block title reads "Do something Compass doesn't know".

    Screenshots: ~/compass-uat/s7nqsy0/COM-1860/ (yes-path-dropdown-empty-canvas.png, new-action-on-yes.png, otherwise-dropdown-with-blocks.png, action-then-goes-on-to.png, sentences-both-paths.png)
assignee: steve
label:
- bug
priority: medium
task_status: review
---
Found by Steve while testing sprint "Automation - Workflows" on staging (building a CHK-26 workflow in Test Company).

## What was seen

Someone adds a trigger and one condition, then opens the condition. Both "If yes, goes on to" and "Otherwise, goes on to" open empty: there's nothing to pick and no explanation. They read as broken.

The cause is the lists offer only blocks already on the canvas. Until an action is added there is nothing to go on to. Adding a block from the palette while the condition is selected joins it to the first free path (Yes, then Otherwise), but nothing on screen says so. The canvas works; the keyboard and panel route is a dead end.

## Done when

- With no other block to go to, each path's list offers to add one there: a new action or a new condition. Choosing one adds the block, joins it to that path and opens it.
- When other blocks exist, they're still listed as now, with the add choices beneath them.
- The placeholder still reads "Nothing: it stops here", and clearing a path still stops there.
- The same applies to an action's "Then goes on to".
- A test covers an empty canvas: from a lone condition, add a Set status action on Yes and another on Otherwise. The sentence view then reads both.

Independent (frontend only).