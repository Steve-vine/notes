---
id: 01M7HWT5Q2NETHCSTWXDTERT42
created: 2026-11-16T10:00:31.202877Z
updated: 2026-11-16T13:04:07.84896Z
type: task
title: 'Workflow builder: Save stays greyed out until the workflow has a name, with nothing saying so, while the leave prompt offers a Save that can''t work'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1861
sprint: s7nqsy0
comments:
- id: 01M7J7AC580E80GXGK9A8JYGRF
  author: Steve Vine
  at: 2026-11-16T13:04:07.848599Z
  text: |-
    Done — PR #1856, merged to main (1ab932c7). Not on staging yet.

    - Save is no longer greyed out without a name. Pressing it saves nothing, marks the Name box as required with "Name it to save it", and puts the cursor there.
    - The leave prompt's "Save and continue" does the same: you stay on the page with every change kept.
    - This works for a new workflow and for an existing one whose name was cleared. On the Runs or Versions tab, it switches back to the Workflow tab first.
    - With a name, Save works as before: a new workflow is version 1, disabled.

    To check on staging:
    - New workflow with no name: press Save, then try leaving and choosing "Save and continue".
    - Existing workflow: clear the name and save, then name it and save.
assignee: steve
label:
- bug
priority: medium
task_status: review
---
Found by Steve while testing sprint "Automation - Workflows" on staging (a new CHK-26 workflow in Test Company). He built it and tested it, but couldn't save it.

## What was seen

- Save stays disabled until the Name box above the canvas has text. The only clue is the box's placeholder, "Name it to save it", which sits away from the button and is easy to miss once the canvas is full.
- Leaving the page asks "save, discard or keep editing" and offers Save. With no name, that save is refused, so the prompt offers a choice that can't succeed.
- The same applies on an existing workflow's page when the name is cleared.

## Done when

- With no name, Save is still clickable. Pressing it marks the Name box as required ("Name it to save it") and moves focus there, without saving.
- Save from the leave prompt does the same: it stays on the page, shows the Name box as required, and keeps every change.
- With a name, Save works as now: version 1, disabled.
- Tests cover Save with no name on a new workflow and on an existing one, and Save from the leave prompt with no name.

Independent (frontend only).