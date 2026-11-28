---
id: 01M8HMWGE5EGVX2SMP34DZGMZM
created: 2026-11-28T17:57:40.933074Z
updated: 2026-11-28T17:57:54.966898Z
type: task
title: Polaris names a workflow's Run script step by the script's name, which Compass doesn't recognise; and its workflow test shows labels instead of the person's values
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2242
sprint: s09wwd3
assignee: steve
label:
- bug
priority: medium
task_status: active
---
**Defect from the sprint 132 pre-UAT pass (COM-2237).** Independent: no migration, no API change.

## What was seen
1. Polaris's workflow format tells it to name the script in a Run script step (`"script": "Create CRM user"`), but Compass keeps a step's script by its ID and nothing turns a name into one. A workflow Polaris drafts would show "Choose a script" and couldn't be enabled. Controls, checks, documents and assets are already matched by name or reference; scripts were missed.
2. Testing a workflow against a past person through Polaris listed what the trigger hands on by **label only** ("display_name: Display name"), not the person's values ("Display name: Compass Test"), so Polaris couldn't say what would be passed.

## What changes
- A script named in a drafted workflow is matched to the script of that name, as controls are. An unknown name still shows as a problem ("There's no script called …").
- Polaris's workflow test answer gives each value the trigger would hand on, with its label.

**Done when:** on staging, Polaris drafts an After a joiner workflow naming "Set CRM display name" with its inputs mapped; it opens on the canvas with the script chosen; and testing it against a past person shows the person's display name and sign-in name as values and "Would run Set CRM display name …".