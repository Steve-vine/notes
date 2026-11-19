---
id: 01M7TKDS686F4DZJAZ4KSP3PWG
created: 2026-11-19T19:09:37.864277Z
updated: 2026-11-19T20:31:33.233564Z
type: task
title: 'Library tiles: folders a shade darker, documents a shade lighter, in light and dark mode'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1988
sprint: s2q1gxe
comments:
- id: 01M7TR3NV7PAPRJHAWKXK19H51
  author: Steve Vine
  at: 2026-11-19T20:31:29.639Z
  text: |-
    Merged: PR #1981, sha 6e8da3d6. No migration, no API change.

    What changed: every Library tile now has a background that says what it is.
    - **Folder tiles are a shade darker.** That's folder and domain cards, folder cards inside a folder, Not in a folder, and a pinned folder.
    - **Document tiles are lighter.** That's document cards, search results, Recently viewed and a pinned document.
    - **Light mode:** folders are pale grey and documents stay white.
    - **Dark mode:** folders are a shade darker than the page and documents a shade lighter.
    - Borders, folder colours, icons, text, hover and focus rings, the dragged card and the drop highlight are unchanged.
    - Measured contrast of text and dimmed text: light folder 14.3 / 4.8, light document 16.0 / 5.3, dark folder 15.1 / 6.3, dark document 11.6 / 4.9. All pass AA.

    For Steve to overturn: the document rows in search results had no background of their own before (the page showed through). They now take the document background too.

    Also in this PR: a test that pins and unpins from Pinned sometimes failed under load. It now waits for the card's menu to close.
assignee: steve
label:
- improvement
priority: medium
task_status: review
---
Steve, testing the Library on staging (19 Nov): change the tile background colours slightly, so folder tiles are slightly darker and document tiles slightly lighter, in both modes.

**Today:** every Library tile has the page's own background colour, with a thin border. That includes folder cards, domain folder cards, document cards, Recently viewed tiles and Pinned tiles. Folders and documents look the same apart from their contents.

**What a person sees**
- **Folder tiles are a shade darker than today.** That's folder cards under Folders and Domains, the folder cards inside a folder, "Not in a folder", and a pinned folder's tile in Pinned.
- **Document tiles are a shade lighter than folder tiles.** That's document cards in a folder and in search results, the Recently viewed tiles, and a pinned document's tile in Pinned.
- The change is slight. It's enough to tell a folder from a document at a glance, not a block of colour. Borders, folder colours and icons, text, the hover lift and drag-and-drop highlighting stay as now.
- The same on every page width, and on a phone.

**Light mode, dark mode**
- **Dark mode:** folders go a shade darker than the page and documents a shade lighter than the page, so both move apart from it.
- **Light mode:** the page is already white, so a document can't be lighter than it. Folders go a shade darker (a pale grey) and documents stay white. The difference between the two is what tells them apart.

**Choices, for Steve to overturn**
- In light mode documents stay white rather than tinting the whole Library page grey so they can stand out lighter. Say if you'd rather have the grey page.
- The colours come from the app's own light/dark palette, not fixed colours, so each mode keeps enough contrast for the text and dimmed text on the tile.

**Done when**
- In light and dark mode, side by side on the home (Pinned with a folder and a document, Recently viewed, Folders, Domains) and in a folder: folder tiles are visibly a shade darker than document tiles. Text, dimmed text and icons on both meet contrast (AA) in both modes.
- Hover, keyboard focus, a dragged card and a drop target still show clearly on both kinds.
- Tests are updated (a folder card and a document card carry their own background), and the e2e Library crawl still passes.

Frontend only.