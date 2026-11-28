---
id: 01M8GQ3GGDGM2Z6Y6VFCDJ945T
created: 2026-11-28T09:17:13.101638Z
updated: 2026-11-28T09:49:30.35724Z
type: task
title: 'Workflow action Log Event: free text with values picked from the workflow, and a type the person chooses (Info, Warning, Alert), written to the Event log'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2233
sprint: s09wwd3
assignee: steve
label:
- feature
priority: medium
task_status: todo
---
**On the chain.** After the Event log (its own task) and the Scripting phase 2 ADR (COM-2225). Steve, 28 Nov 2026: "Log Event", replacing the "Raise Alert" first suggested, with the person deciding the type.

## What people see
- **A new action, Log Event**, available to every workflow (access and evidence alike).
- Its settings:
  - **Type**: **Info, Warning or Alert**, chosen by the person writing the workflow.
  - **Text**: free text with **values picked from the workflow** inserted where the cursor is. The picker lists the trigger's values and earlier steps' outputs by their labels, the same list a script's inputs choose from. For example: "CRM account {CRM user ID from Create CRM user} made for {Display name} ({Request})".
- **When it runs**, it writes one entry to the **Event log**:
  - the chosen type;
  - the text with the values filled in;
  - the entity it's about (the person and request for an access workflow, the piece of evidence for an evidence one);
  - the workflow and run that wrote it.
- **An Alert** also raises an Action and a notification for the workflow's owner, if the ADR settles that (suggested).
- A value the run doesn't have (a step that didn't run) reads "(not known)" rather than failing the step.
- The workflow run shows "Logged an Info event: …" with the text as written. Test shows "Would log an Alert event: …" without writing it.
- Polaris can add the action when drafting a workflow.

**Done when:** on staging, an After a joiner workflow with Log Event (Alert) inserting the display name and a script's output writes one Event log entry per joiner, with the values filled in, the type chosen and the person as its entity; and Test shows the text without writing anything.