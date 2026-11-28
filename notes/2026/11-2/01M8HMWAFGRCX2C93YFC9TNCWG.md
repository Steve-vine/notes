---
id: 01M8HMWAFGRCX2C93YFC9TNCWG
created: 2026-11-28T17:57:34.832222Z
updated: 2026-11-28T17:57:54.724403Z
type: task
title: 'Log Event''s type is lost when the step is saved, so no workflow with Log Event can be enabled: its setting gets a name of its own'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2241
sprint: s09wwd3
assignee: steve
label:
- bug
priority: high
task_status: active
---
**Defect from the sprint 132 pre-UAT pass (COM-2233).** Independent: no migration, no API change.

## What was seen
On staging, testing an After a joiner workflow with a Log Event (Alert) step against a past person gave "The workflow has a problem: Choose the event's type: Info, Warning or Alert", even though the type was set.

A Log Event step's setting for Info/Warning/Alert shares its name with the part of every step that says it's an action. So the setting is lost the moment it's saved: on the canvas, through Polaris, and in the API. The task's own test checked the action on its own, not as a saved step, so it didn't catch this.

## What changes
- The setting gets a name of its own. On screen it's still **Type: Info, Warning or Alert**, and nothing else changes.
- A test saves, reloads, enables and runs a workflow with Log Event, and checks the Event log entry.
- Polaris's workflow format names the setting correctly.

**Done when:** on staging, an After a joiner workflow with Log Event (Alert), inserting the display name and a script's output, saves, tests against a past person showing "Would log Alert: …" with the values filled in, and enables.