---
id: 01M6M7RHXCTESVJPP351R6G56C
created: 2026-11-04T21:34:39.532665Z
updated: 2026-11-04T21:34:44.866944Z
type: task
title: 'Red menu items read in dark mode: "Remove from the initiative" and the other destructive menu entries'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1586
sprint: srkxswe
assignee: steve
label:
- bug
priority: medium
task_status: todo
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