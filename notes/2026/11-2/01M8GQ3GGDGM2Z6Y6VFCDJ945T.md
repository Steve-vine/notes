---
id: 01M8GQ3GGDGM2Z6Y6VFCDJ945T
created: 2026-11-28T09:17:13.101638Z
updated: 2026-11-28T09:17:13.101638Z
type: task
title: 'Workflow action Raise Alert: free text with values picked from the workflow; creates an Action, a notification and a log entry'
priority: medium
assignee: steve
task_status: todo
label: feature
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2233
---
**On the chain.** After the Scripting phase 2 ADR, which settles where the log entry goes and who the Action is for. Raised by Steve on 28 Nov 2026.

## What people see
- **A new action, Raise Alert**, available to every workflow (access and evidence alike).
- Its settings:
  - **the alert's text**: free text with **values picked from the workflow** inserted where the cursor is. A picker lists the trigger's values and earlier steps' outputs by their labels, the same list a script's inputs choose from. For example: "CRM account {CRM user ID from Create CRM user} made for {Display name} ({Request})".
  - **who it's for** (per the ADR: the workflow's owner, a named person, or a business role's holders);
  - **severity** (if the ADR keeps one).
- **When it runs**, it creates:
  - **an Action** for that person, with the alert's text, linking to the workflow run;
  - **a notification** to them, by the person's own notification settings;
  - **a log entry**: in the Activity log, or in a new Event log, as the ADR decides. Compass has no event log today: the Activity log records changes people make to records.
- A value the run doesn't have (a step that didn't run) reads "(not known)" rather than failing the alert.
- The workflow run shows "Raised alert: …" with the text as sent. Test shows "Would raise alert: …" without raising it.
- Polaris can add the action when drafting a workflow, and say what it would send.

**Done when:** on staging, an After a joiner workflow with Raise Alert inserting the display name and a script's output raises one Action, one notification and one log entry per joiner, each with the values filled in, and Test shows the text without raising anything.