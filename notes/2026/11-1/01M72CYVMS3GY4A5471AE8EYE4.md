---
id: 01M72CYVMS3GY4A5471AE8EYE4
created: 2026-11-10T09:34:51.033118Z
updated: 2026-11-11T08:10:33.109908Z
type: task
title: Content house style upload
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1665
sprint: s0mep0u
comments:
- id: 01M74BR78Q3AZX36369337ZSG6
  author: Steve Vine
  at: 2026-11-11T03:52:13.847047Z
  text: |-
    Built in PR #1713. Loading a style file now always adds a new style. If the name is taken it becomes "Name (2)", "Name (3)" and so on, and the style already there is never written over. The note under the styles list says so too.

    Pre-UAT (Claude, 2026-11-11, staging 305de68a): **Passed.**
    Steps: as E2E Admin A, Content ▸ House styles. I downloaded A4-Standards-Internal (v2) and loaded the file back through the Load button.
    Seen: a new row, "A4-Standards-Internal (2)" (v1), appeared beside the original. The original is byte-for-byte unchanged and still v2. I then deleted the "(2)" copy so staging's list is as it was. Screenshot: ~/compass-uat/s0mep0u/COM-1665/
assignee: steve
label:
- bug
priority: medium
task_status: done
---
When uploading a house style, any existing style is deleted rather than kept. Loading a previously downloaded style should add that to the list not wipe it out.