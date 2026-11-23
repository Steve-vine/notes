---
id: 01M82WCES6X09GQFFFV29RXJXD
created: 2026-11-23T00:20:07.078378Z
updated: 2026-11-23T00:48:00.865753Z
type: task
title: 'Registers: archiving or restoring a register or entry updates its buttons straight away, without a reload'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2100
sprint: s64t54m
comments:
- id: 01M82XZFP9FTVFRQYRY4JF5W4Q
  author: Steve Vine
  at: 2026-11-23T00:47:59.17774Z
  text: |-
    Fixed and merged to main (PR #2084, 4d66b8859).

    What changed for people
    - Archiving a register takes Add entry and Import off the page at once, and restoring brings them back, with no reload.
    - Archiving an entry takes Add link, Unlink, Take off and Add evidence off its page at once, and restoring brings them back.

    Cause: the entries list, an entry's Links and its Evidence each say whether they can be changed, and archiving didn't refresh them. The server was always right: nothing could be saved to an archived register.

    Checked by automated tests so far. I'll re-test it in the browser once it's on staging.
assignee: steve
label:
- bug
priority: high
task_status: review
---
Found in the pre-UAT pass of sprint "Registers" on staging f73af7daf. Fix-forward for COM-2077 and COM-2078.

## What's wrong
- After **Archive** on a register, Add entry and Import stay on screen. Add entry then fails with "This register is archived, so it can't be changed. Restore it first". Nothing is saved.
- After **Restore**, Add entry and Import stay missing until the page is reloaded.
- An entry behaves the same way: after Archive, Add link, Unlink, Take off and Add evidence stay until a reload.

Screenshots: `~/compass-uat/s64t54m/COM-2077/archived-readonly.png`, `archived-add-entry-refused.png`, `restored-no-add-until-reload.png`.

## Done when
- Archiving a register removes Add entry and Import at once, and restoring brings them back, with no reload.
- Archiving an entry removes Add link, Unlink, Take off and Add evidence at once, and restoring brings them back, with no reload.

Independent: no migration, no API change.