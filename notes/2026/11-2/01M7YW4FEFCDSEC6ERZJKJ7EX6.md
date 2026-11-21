---
id: 01M7YW4FEFCDSEC6ERZJKJ7EX6
created: 2026-11-21T10:58:47.8872Z
updated: 2026-11-21T13:33:49.109589Z
type: task
title: 'Add evidence window: the Link tab filters to controls just linked, and Cancel after a partial upload clears what wasn''t sent'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2069
sprint: s9hexqn
comments:
- id: 01M7YXH9MA25Q4AY637M1B5Z4E
  author: Steve Vine
  at: 2026-11-21T11:23:16.490596Z
  text: |-
    Done and merged to main (PR #2057). This changes the screen only.

    What changes:
    - Link a control to a schedule entry, then go straight to Mark done ▸ Add evidence ▸ Link existing: it now opens filtered "On RIM.9" without a reload. Linking or unlinking an entry's control used to refresh only its Controls list, not the entry itself. If the controls arrive after the window has opened, the filter takes them up, unless you've already changed it.
    - After a partial upload, Cancel still asks first. Once you confirm, the refused files are gone, and leaving the page brings no "leave this page?" prompt.

    Checked: new tests for the entry refreshing after a control change, controls arriving after the window opened, a changed filter left alone, and Cancel after a partial upload with no leave-page prompt. Two of them fail without the fix.

    Worth re-checking: I couldn't find the exact screen where the recheck saw the leave-page prompt after Cancel. So the fix makes the window empty itself on a confirmed Cancel, whatever screen it's on. I'll check it in the next test pass.
- id: 01M7Z50ANNG8KY0KB590B1M5AW
  author: Steve Vine
  at: 2026-11-21T13:33:49.109329Z
  text: |-
    Pre-UAT (staging 12bd442a5, E2E Test Company): Passed.
    Steps:
    - Filter: on SAP-89, Link controls ▸ RIM.9, then straight away Mark done ▸ Add evidence ▸ Link existing.
    - Cancel on SAP-89 and on RIM.9's Assessment screen: added one good file and two bad ones, which gave a partial upload. Then Cancel ▸ Discard changes ▸ left the page.
    Seen:
    - The Link tab opened filtered "On INS.10, RIM.9" with no reload.
    - Cancel asks "Unsaved changes… Discard changes" on both screens.
    - After a confirmed Cancel, leaving the page brings no browser prompt, while leaving with unsent files still held does prompt.
    - The file that did upload stays: EVD-91 on RIM.9, and e2e-r5-extra-1.txt on SAP-89.
    Screenshots: ~/compass-uat/s9hexqn/COM-2069/
assignee: steve
label:
- bug
priority: low
task_status: review
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