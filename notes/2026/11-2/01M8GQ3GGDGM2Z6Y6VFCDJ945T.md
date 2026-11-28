---
id: 01M8GQ3GGDGM2Z6Y6VFCDJ945T
created: 2026-11-28T09:17:13.101638Z
updated: 2026-11-28T14:27:40.419986Z
type: task
title: 'Workflow action Log Event: free text with values picked from the workflow, and a type the person chooses (Info, Warning, Alert), written to the Event log'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2233
sprint: s09wwd3
comments:
- id: 01M8H8VPBFE1E7FBDK7M73DFSW
  author: Steve Vine
  at: 2026-11-28T14:27:31.310957Z
  text: |-
    Done in PR #2243 (merged). Any workflow, in every family (evidence, access and the rest), can now use a new action, Log Event. You pick a type (Info, Warning or Alert) and write the text. The text is a box where you can insert the values the trigger hands on, and an earlier Run script step's outputs, as named tokens: they show as chips in the editor and are filled in when the workflow runs.
    When the step runs, it adds one entry to Admin ▸ Event log: its type, the filled-in text, the workflow as what it's about and what caused it, and the company. A value the run doesn't have reads "(not known)" rather than failing. A hidden script input can never be inserted.
    As decided, the type is only a label. An Alert raises no Action and notifies nobody.
    The builder's Test drawer says "Would log Warning: …" with the filled-in text, and nothing is written. Checked in tests for both a run and a test, including a value that isn't known.
- id: 01M8H8VZ83967BWYAYH2W5QB7Z
  author: Steve Vine
  at: 2026-11-28T14:27:40.419789Z
  text: 'Correction to my comment above: the entry is about the person and their request for an access workflow, or the piece of evidence for an evidence workflow, as the task asks. The workflow and its run are recorded as what caused it.'
assignee: steve
label:
- feature
priority: medium
task_status: review
---
**On the chain.** After the Event log (COM-2234) and the Scripting phase 2 ADR (COM-2225). Steve, 28 Nov 2026: "Log Event", replacing the "Raise Alert" first suggested, with the person deciding the type.

## What people see
- **A new action, Log Event**, available to every workflow (access and evidence alike).
- Its settings:
  - **Type**: **Info, Warning or Alert**, chosen by the person writing the workflow.
  - **Text**: free text with **values picked from the workflow** inserted where the cursor is. The picker lists the trigger's values and earlier steps' outputs by their labels, the same list a script's inputs choose from. For example: "CRM account {CRM user ID from Create CRM user} made for {Display name} ({Request})".
- **When it runs**, it writes one entry to the **Event log**, and nothing else:
  - the chosen type;
  - the text with the values filled in;
  - the entity it's about (the person and request for an access workflow, the piece of evidence for an evidence one);
  - the workflow and run that wrote it.
- **The type is a label only** (Steve, 28 Nov 2026). An Alert doesn't raise an Action or send a notification to anyone; it's an Event log entry like any other, which a person, a filter or (later) an outside service watches.
- A value the run doesn't have (a step that didn't run) reads "(not known)" rather than failing the step.
- The workflow run shows "Logged an Info event: …" with the text as written. Test shows "Would log an Alert event: …" without writing it.
- Polaris can add the action when drafting a workflow.

**Done when:** on staging, an After a joiner workflow with Log Event (Alert) inserting the display name and a script's output writes one Event log entry per joiner, with the values filled in, the type chosen and the person as its entity; it raises no Action and sends no notification; and Test shows the text without writing anything.