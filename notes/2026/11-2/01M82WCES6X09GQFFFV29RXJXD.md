---
id: 01M82WCES6X09GQFFFV29RXJXD
created: 2026-11-23T00:20:07.078378Z
updated: 2026-11-23T00:20:13.07883Z
type: task
title: 'Registers: archiving or restoring a register or entry updates its buttons straight away, without a reload'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2100
sprint: s64t54m
assignee: steve
label:
- bug
priority: high
task_status: active
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