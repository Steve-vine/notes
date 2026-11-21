---
id: 01M7YW4FEFCDSEC6ERZJKJ7EX6
created: 2026-11-21T10:58:47.8872Z
updated: 2026-11-21T10:58:57.138395Z
type: task
title: 'Add evidence window: the Link tab filters to controls just linked, and Cancel after a partial upload clears what wasn''t sent'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2069
sprint: s9hexqn
assignee: steve
label:
- bug
priority: low
task_status: active
---
Found in Claude's pre-UAT recheck (staging d4a5f0b5a, 2026-11-21).

**1. Link existing opens unfiltered after the record's controls change**
- **Steps:** link RIM.9 to schedule entry SAP-73, then straight away choose Mark done ▸ Add evidence ▸ Link existing.
- **Expected:** it opens filtered "On RIM.9".
- **Seen:** it opened unfiltered (67 pieces). After a reload it opened "On RIM.9" (7 pieces). The window was given the entry's controls from before the change.

**2. Cancel after a partial upload leaves unsent files behind**
- **Steps:** upload several files where some are refused (three were), then press Cancel and leave the page.
- **Expected:** Cancel asks before discarding, then clears what wasn't sent, and leaving the page doesn't prompt.
- **Seen:** leaving the page brought up the browser's "leave this page?" prompt, as if unsent files were still held.

**Done when**
- The Link tab always starts filtered to the record's current controls, including ones linked moments before.
- After Cancel (confirmed), no unsent files remain, and leaving the page doesn't prompt.
- Tests cover both.

Frontend only. Independent.