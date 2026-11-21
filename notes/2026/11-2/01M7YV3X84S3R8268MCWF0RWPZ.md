---
id: 01M7YV3X84S3R8268MCWF0RWPZ
created: 2026-11-21T10:41:00.676576Z
updated: 2026-11-21T10:46:52.404336Z
type: task
title: 'Add evidence window ▸ Add new evidence: adding files and links, and editing their details, sit in two separate boxes, as the access request window lays out its sections'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2064
sprint: s9hexqn
assignee: steve
label:
- improvement
priority: medium
task_status: active
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