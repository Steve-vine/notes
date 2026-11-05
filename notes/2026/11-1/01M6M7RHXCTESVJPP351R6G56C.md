---
id: 01M6M7RHXCTESVJPP351R6G56C
created: 2026-11-04T21:34:39.532665Z
updated: 2026-11-05T00:57:28.330716Z
type: task
title: 'Red menu items read in dark mode: "Remove from the initiative" and the other destructive menu entries'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1586
sprint: srkxswe
comments:
- id: 01M6MDY8FE8VS8MBFJ0XJ3G9RR
  author: Steve Vine
  at: 2026-11-04T23:22:37.933902Z
  text: |-
    Done: PR #1603, merged to main as 540ddaed.

    What changed: red menu entries now use Compass's readable red, which holds 4.5:1 in both light and dark mode. Seven entries, not the five listed; the new check found two more:
    - Remove from the initiative (initiative Controls tab)
    - Purge (vendor page)
    - the control page's red entry
    - Delete (DDQ)
    - Stop (attestation assignment)
    - Remove (DDQ question)
    - Delete table (rich-text editor)

    The DDQ question's Remove is red only while it can be used, so a disabled one keeps its grey. One visible difference: hovering a red entry now shows the normal menu hover, not a faint red tint.

    Guard: screen-conventions.test.ts now fails any Menu.Item written with color=. The rule is in brief/information-architecture.md → Text reads in both schemes.

    Tested: InitiativeTabs.test.tsx asserts the item's colour is var(--mantine-color-red-text).

    Check in dark mode on staging: an initiative's Controls tab → row menu → Remove from the initiative.
- id: 01M6MKBXGA4NE4N626SQ7NHCD3
  author: Steve Vine
  at: 2026-11-05T00:57:28.330521Z
  text: |-
    Pre-UAT: Passed (staging b69117dc, E2E Admin A).

    Steps: switched the colour scheme to Dark, then opened INI-1, the Controls tab, and the INS.10 row menu.

    Seen: "Remove from the initiative" in a light red, rgb(245,139,136), on the menu's rgb(35,37,50), which is 6.46:1 contrast. The other entries are 12.55:1. Switched back to Light afterwards.

    Screenshot: ~/compass-uat/initiatives-improvements/COM-1586/dark-remove.png
assignee: steve
label:
- bug
priority: medium
task_status: review
---
On an initiative's **Controls** tab, the row menu's "Remove from the initiative" is in a dark red that's hard to read on a dark background. Steve: "that dark red colour again" (COM-1395 fixed the same thing for error and warning text).

**Same problem, same fix, elsewhere:** every red (destructive) menu entry is drawn the same way.
- Initiative Controls tab: Remove from the initiative
- Attestations, role content card: Stop
- DDQ: Delete
- Control page: the red menu entry
- Vendor page: Purge

**Wanted behaviour:** destructive menu entries stay red, but a red that reads clearly in both light and dark mode, like the error text after COM-1395. A check stops new ones coming back dark.

**Done when:** in dark mode, each of the five menu entries above is clearly readable (about 4.5:1 or better against the menu) and still red. Light mode looks as it does now, or better. The screen-conventions test fails if a new `Menu.Item color="red"` (or any other bare colour on a menu item) is added without the readable form.

**Implementation:** `Menu.Item color="red"` sets the item's colour to the family's fixed filled shade, not the scheme-aware `--mantine-color-red-text`. On staging these are `initiatives/ControlsTab.tsx:161`, `attestations/RoleContentCard.tsx:265`, `ddq/deletion/DeleteDdq.tsx:36`, `pages/ControlDetailPage.tsx:311` and `pages/VendorDetailPage.tsx:302`. Prefer one fix in the theme (a `Menu` `item` style or `vars` override that maps a coloured item to `var(--mantine-color-<c>-text)`), so call sites stay as they are. Then extend `screen-conventions.test.ts`. If the theme route doesn't work, use a shared `DangerMenuItem`. Assert the resolved colour in a test, because of the jsdom/Menu quirks memory. Check the Items tab's "Remove from the initiative" / "Leave out" (uncoloured) still look right.

**Independent:** frontend only.

Found by Steve while testing Initiatives (2026-11-04).