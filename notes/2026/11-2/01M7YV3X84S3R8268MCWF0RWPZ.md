---
id: 01M7YV3X84S3R8268MCWF0RWPZ
created: 2026-11-21T10:41:00.676576Z
updated: 2026-11-22T08:13:22.37063Z
type: task
title: 'Add evidence window ▸ Add new evidence: adding files and links, and editing their details, sit in two separate boxes, as the access request window lays out its sections'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2064
sprint: s9hexqn
comments:
- id: 01M7YXH2K2GMF6XJAEKZ75MHRR
  author: Steve Vine
  at: 2026-11-21T11:23:09.282833Z
  text: |-
    Done and merged to main (PR #2052). This changes the screen only.

    What changes:
    - The Add new evidence tab is now two boxes with numbered headings, laid out like the access request window's sections (it uses the same building blocks):
      1. Add files and links: the drop box and the Web address box.
      2. Check each one's details: the list, the preview and the selected item's properties.
    - On Audit ▸ Evidence, the Supports controls sit in box 1, and so does a testing entry's "Is this a pen test report?" tick.
    - Before anything is added, box 2 says "Files and links you add appear here", so nothing jumps when the first file goes in.
    - Adding, editing, clicking through and Upload work as before.

    Checked in headless Chromium at desktop and phone width, light and dark. At desktop width the preview still fits in box 2 with all three columns on one row. At phone width the boxes stack, with no sideways scrolling. With files listed, the area under the tabs now scrolls by about 90px on a 900px-tall screen, because the box headings take a little room.

    Calls for you to overturn:
    - The task mentioned a shaded background, but the access request window itself has none: its boxes are bordered on the window's own colour. I matched the real window.
    - Supports and the pen-test tick are in box 1.
- id: 01M7Z504X8K3EBFPSXBTQGFZSA
  author: Steve Vine
  at: 2026-11-21T13:33:43.207824Z
  text: |-
    Pre-UAT (staging 12bd442a5, E2E Test Company): Passed.
    Steps: On RIM.9, opened Add evidence and looked at the window empty, then with two files added and filled in, then uploaded them. Repeated at 390 wide with a web address.
    Seen:
    - Box "1 Add files and links" holds the drop box and web address. Box "2 Check each one's details" says "Files and links you add appear here" until something is added, then shows the list, the preview and the properties side by side.
    - Upload worked (EVD-87, EVD-88).
    - At 390 the boxes stack, with no sideways scroll.
    Screenshots: ~/compass-uat/s9hexqn/COM-2064/
assignee: steve
label:
- improvement
priority: medium
task_status: done
---
Raised by Steve while testing sprint 120 (2026-11-21).

**Today.** On the Add new evidence tab, two parts run together in one area with nothing marking where one ends and the next begins:
- the drop box and the Web address box at the top;
- the list of what's been added, with the selected item's properties beside it.

**What people see after this.** The tab is laid out the way the access request window lays out its sections (Access ▸ Requests ▸ New request): each part in its own box, with a numbered heading, on the window's shaded background.
1. **Add files and links:** the drop box ("Drop files here, or click to choose") and the Web address box.
2. **Check each one's details:** the list of added items on the left and the selected item's properties on the right (name, type, classification, description, dates), with the missing-details warnings as now.

- My call (Steve to overturn): those two headings.
- Nothing else changes: what can be added, what's required, clicking through each item, and the Upload button in the bottom bar.
- Before anything has been added, box 2 shows a short line ("Files and links you add appear here") rather than disappearing, so the layout doesn't jump when the first file goes in. That's my call too.

**Implementation notes**
- The window is `evidence/AddEvidenceWindow.tsx` (`AddNewEvidence`: `DropBox`, `WebAddressBox`, `RowList`, `RowProperties`).
- The access request window's boxed, numbered sections are `RequestSection` / `RequestSections` in `components/requestWindow.tsx`. They already live in `components/` so other windows can use them (a data subject request's page does). Reuse them rather than copying the styling.
- Check the preview inside box 2 (COM-2047) still fits, and that the narrow layout stacks cleanly.
- Frontend only. Independent: no migration or API change.

**Done when**
- The Add new evidence tab shows two separate numbered boxes, Add files and links and Check each one's details, styled like the access request window's sections.
- Adding, editing and uploading work exactly as before.