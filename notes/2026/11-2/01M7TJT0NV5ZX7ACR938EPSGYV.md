---
id: 01M7TJT0NV5ZX7ACR938EPSGYV
created: 2026-11-19T18:58:50.171996Z
updated: 2026-11-19T18:58:52.019735Z
type: task
title: The Library page's width button sits at the far right, directly below the profile icon
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1986
sprint: s2q1gxe
assignee: steve
label:
- improvement
priority: medium
task_status: backlog
---
Steve, testing the Library on staging (19 Nov): move the Library page's width button to the far right-hand side, so it sits directly below the user profile icon.

**Today:** the Page width button (COM-1971) is in the page's header, at the right-hand end of the page's column. On the home it's beside the title. In a folder it's beside New folder. At Normal and Wide the column is centred, so the button floats mid-screen, well left of the profile icon.

**What a person sees**
- The Page width button sits at the far right of the window, just under the top bar, lined up with the profile icon above it. It's in the same place at every page width: Normal, Wide or Full width.
- This applies on the home, in a folder, in "Not in a folder" and in search results.
- The button is unchanged otherwise: the same icon, "Page width" tooltip, menu (Normal / Wide / Full width, with the current one marked) and keyboard use.
- New folder stays where it is, in the folder's header.

**Choices, for Steve to overturn**
- The button scrolls away with the page rather than staying pinned under the top bar.
- On a phone it still sits at the right, under the profile icon. It doesn't move into a menu.

**Done when**
- At 1920 px and at Normal, Wide and Full width, the button's right edge lines up with the profile icon's on the home, in a folder, in Not in a folder and in search results. Nothing else in the header moves except the button.
- On a phone (390 px): no sideways scroll, and the button doesn't overlap the title or New folder.
- Tests are updated, and the e2e Library crawl still passes.

Builds on COM-1971. Frontend only.