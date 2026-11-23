---
id: 01M82WCES6X09GQFFFV29RXJXD
created: 2026-11-23T00:20:07.078378Z
updated: 2026-11-23T19:36:19.436336Z
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
- id: 01M82ZWKZRAE2EBM8WR0QWDYRH
  author: Steve Vine
  at: 2026-11-23T01:21:22.424327Z
  text: |-
    Re-test on staging 29d0849fc: Passed.

    As E2E Admin A, each sequence on one open page, with no reload between steps.

    - Archiving a register removes Add entry and Import at once, and restoring brings them back, with no reload: Passed. On ZMA I chose Restore, Archive, Restore. After Restore, Import and Add entry appeared. After Archive, both went and the "read-only until it's restored" notice appeared. After the second Restore, both came back. COM-2100/retest-02-restored-buttons.png, retest-03-archived-buttons-gone.png
    - Archiving an entry removes Add link, Unlink, Take off and Add evidence at once, and restoring brings them back, with no reload: Passed. On ZMA-1, which has both a link and evidence, I chose Restore, Archive, Restore. All four were there after Restore. After Archive, all four went and the card read "ZMA-1 is archived: it keeps its evidence as it is." After the second Restore, all four came back. COM-2100/retest-04-entry-restored-buttons.png, retest-05-entry-archived-buttons-gone.png, retest-06-entry-restored-again.png

    Screenshots are under ~/compass-uat/s64t54m/.
assignee: steve
label:
- bug
priority: high
task_status: done
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