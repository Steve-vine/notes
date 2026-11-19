---
id: 01M7TJT0NV5ZX7ACR938EPSGYV
created: 2026-11-19T18:58:50.171996Z
updated: 2026-11-19T20:31:40.582765Z
type: task
title: The Library page's width button sits at the far right, directly below the profile icon
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1986
sprint: s2q1gxe
comments:
- id: 01M7TR3YJADE4Z5VEW78P984KW
  author: Steve Vine
  at: 2026-11-19T20:31:38.570714Z
  text: |-
    Merged: PR #1982, sha 4ad4e855. No migration, no API change.

    What changed: the Library's Page width button now sits at the far right of the window, just under the top bar, its right edge lined up with the profile icon's.
    - **Same place everywhere:** the home, every folder (ones you made, domain folders, Not in a folder) and search results, at Normal, Wide and Full width.
    - **Stays put as the page scrolls.**
    - **Folder pages:** it's no longer beside New folder, which stays alone at the right of the folder's header.
    - **Nothing scrolls under it:** the page keeps a strip clear beneath the button, so nothing passes under it at Full width or on a phone.
    - **Layering:** the reading pane, dialogs and the Compass menu open over it.
    - **Measured** (headless Chromium): at 1920 px the button's right edge and the profile icon's are both at 1900 px in every case. At 390 px there's no sideways scroll and it clears New folder.

    For Steve to overturn:
    - On a phone the clear strip is 48 px wide, so the page's content sits a little left of centre there.
    - When the "restored company" notice shows above a page, the button can overlap it.
assignee: steve
label:
- improvement
priority: medium
task_status: review
---
Steve, testing the Library on staging (19 Nov): move the Library page's width button to the far right-hand side, so it sits directly below the user profile icon. Steve (19 Nov): it stays in view as the page scrolls, as in the reader (COM-1987). Steve (19 Nov): the same on folder pages. The button there, beside New folder, moves to the same position and doesn't scroll.

**Today:** the Page width button (COM-1971) is in the page's header, at the right-hand end of the page's column. On the home it's beside the title. On a folder page (any folder, a domain folder, "Not in a folder") it's beside New folder. At Normal and Wide the column is centred, so the button floats mid-screen, well left of the profile icon.

**What a person sees**
- The Page width button sits at the far right of the window, just under the top bar, lined up with the profile icon above it. It's in the same place at every page width: Normal, Wide or Full width.
- **It stays there as you scroll.** The page moves beneath it and the button doesn't move.
- **The home and every folder page alike**, plus search results: a folder you made, a domain folder, "Not in a folder". It's one button in one place, so it doesn't jump when you open a folder or go back to the home.
- **On a folder page it leaves New folder's side.** New folder stays where it is, alone at the right of the folder's header, and scrolls with the page as before. Where New folder isn't shown (a viewer, a domain folder), the header has nothing on its right.
- The button is unchanged otherwise: the same icon, "Page width" tooltip, menu (Normal / Wide / Full width, with the current one marked) and keyboard use.

**Choices, for Steve to overturn**
- At Full width the button can sit over the right-hand end of whatever scrolls beneath it: New folder, a section's sort icons, the rightmost card. To prevent that, the page keeps a strip clear for it on the right, the button's width, so nothing passes under it. At Normal and Wide the column is narrower than the window, so there's room already.
- It stays over the page but under the reading pane, dialogs and menus. With the reading pane open, the pane covers it.
- On a phone it still sits at the right, under the profile icon, and stays put as you scroll. It doesn't move into a menu.

**Done when**
- At 1920 px and at Normal, Wide and Full width, the button's right edge lines up with the profile icon's on the home, in a folder you made, in a domain folder, in Not in a folder and in search results. It's in the identical spot on each.
- On a folder page the button is no longer beside New folder. New folder is still in the header and works as before, for an editor.
- Scrolling a long page (search results, a big folder) leaves the button where it is, and nothing is hidden under it at any width, New folder included.
- The reading pane, dialogs and the Compass menu all open in front of it.
- On a phone (390 px): no sideways scroll, and the button doesn't overlap the title or New folder.
- Tests are updated, and the e2e Library crawl still passes.

Builds on COM-1971. Frontend only.