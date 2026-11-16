---
id: 01M7HWT5Q2NETHCSTWXDTERT42
created: 2026-11-16T10:00:31.202877Z
updated: 2026-11-16T15:06:31.878701Z
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
- id: 01M7JEAG26P4HK929J4AF4HK4K
  author: Steve Vine
  at: 2026-11-16T15:06:31.878453Z
  text: |-
    **Pre-UAT: Passed** (staging 43d03f09, E2E Test Company, E2E Admin A)

    Steps and what I saw:
    - On a new blank workflow with no name, Save was clickable. Pressing it saved nothing: the Name box turned red with "Name it to save it" and the cursor was in it.
    - Made changes, then clicked the top-bar "Workflows" link. The prompt said "Unsaved changes… Keep editing / Discard changes / Save and continue". I chose Save and continue. I stayed on the page, the Name box was marked required and focused, and all four blocks were still there.
    - Named it and saved: WF-7, Disabled, Version 1.
    - On the existing WF-7, I cleared the name, switched to the Runs tab and pressed Save. It switched back to the Workflow tab and marked and focused the Name box, saving nothing.
    - Named it again and saved: Version 2, still Disabled.

    Screenshots: ~/compass-uat/s7nqsy0/COM-1861/ (save-no-name-new.png, leave-prompt.png, after-save-and-continue-no-name.png, saved-with-name.png, existing-cleared-name-save-from-runs.png)
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