---
id: 01M7R2AB39XV1HNE7E3XH0RN29
created: 2026-11-18T19:32:10.473722Z
updated: 2026-11-19T01:23:18.91873Z
type: task
title: 'Library reader: an info icon in the top bar opens the document''s details pane'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1974
sprint: s2q1gxe
comments:
- id: 01M7RDPYDV1VYHFXPG42GTSMXR
  author: Steve Vine
  at: 2026-11-18T22:51:17.819175Z
  text: |-
    Merged: PR #1967, merge 5c42b1cb. No migration.

    What changed for a reader: the reader's top bar has a ⓘ Details button (on phones too). It opens the same details pane the Library shows, sliding in over the document being read: summary, facts, every folder it's in, contents, tags, Copy link and Download PDF. Someone who can arrange the Library also gets Add to another folder. The pane has no Read document button, because you're already reading it. Copy link copies the reader's own address. Closing the pane (×, Escape or a click outside) returns you to the same place in the document. Escape closes only the pane; a second Escape leaves the reader as before. It works for documents and decision records alike.

    Layering: the reader now sits just above Compass's own top bar and menu, and below anything opened over a document. So this pane, its Add to another folder dialog and a flowchart's Full screen all open in front of it, which also fixes the cause of COM-1964. The reader's own menus and tooltips, and Compass's pop-up messages, still show above it. I checked the rest of the app for anything that could now show through or over the reader, and found nothing. One small change: pressing M in the reader now always opens the Compass menu in front of it, where before it could open hidden behind.

    Assumption you may want to overturn: the ⓘ sits just left of Contents in the bar.
- id: 01M7RPD9R68YZKW9DS75T41136
  author: Steve Vine
  at: 2026-11-19T01:23:18.918498Z
  text: |-
    Pre-UAT (staging 25f02b9c, E2E Admin A and E2E Viewer): **Passed**.
    - ⓘ opens the details pane over the reader for Access Control Policy, Test process and decision DEC-10, in light and dark and at 390 px (full width, no sideways scroll). There's no Read document button.
    - Escape, × or a click outside closes only the pane, and the scroll stayed at 3059 px. A second Escape leaves the reader.
    - Add to another folder from the pane opens in front and files the document. The Viewer's pane has no Add to another folder.
    - M in the reader opens the Compass menu in front.
    - Minor, fixed in COM-1985: focus returns to the page body rather than ⓘ. With the mouse still resting on ⓘ, its tooltip reappears and takes an extra Escape.
    Screenshots: ~/compass-uat/library/COM-1974/.
assignee: steve
label:
- improvement
priority: medium
task_status: review
---
Steve, testing the Library (18 Nov): "Also on the read screen add an info icon in the heading to show the properties panel for the document."

## What changes
- The reader's top bar gains an ⓘ icon button ("Details") beside Contents / Export / More.
- Clicking it opens the same details pane the Library shows (summary, type, owner, review dates, folders, tags…), sliding in from the right **over the reader**, and the document stays open underneath. Escape or close returns to the page exactly where you were reading.
- In the reader the pane's **Read document** button is left out, because you're already reading it. Everything else in the pane works as it does in the Library (e.g. Open in Content, filing into folders for those allowed).
- The same icon and words as the tile's ⓘ from COM-1972, so it reads as one control.

## Implementation notes
- `libraryFolders/ReaderBar.tsx`: add an ActionIcon (Phosphor Info, `variant="default" size={34}`, aria-label "Details", Tooltip) alongside the Contents/Export/More controls; it goes into the narrow-width overflow the same way the others do, if any.
- `ReaderPage.tsx`: hold pane-open state; render `DocumentPane` for the current doc with a prop that hides the Read document action (e.g. `inReader`).
- **Stacking**: the reader is a portal layer at z-index 200 (reader.css), and Mantine's Drawer defaults to 200 as well. Give the pane a higher zIndex when opened from the reader (or a shared constant), and make sure focus is trapped in the pane and returns to the ⓘ on close. COM-1964 is the same class of bug, with the flowchart Full screen opening behind the reader, so use the same approach.
- Escape closes the pane first, not the reader; check the reader's own Escape handler doesn't also fire.
- Frontend only; **independent**. It touches ReaderBar/ReaderPage, as COM-1962 (width menu) and COM-1968 (Pin in the bar) do, so build it after them or rebase onto them.

## Done when
- In the reader, the ⓘ in the top bar opens the document's details pane on top of the reader; it shows the right document with no Read document button.
- Closing it (×, Escape, clicking outside) returns to the reader at the same scroll position; Escape doesn't also close the reader.
- Works for content and decision records, as Viewer and admin, at narrow width, in light and dark mode.