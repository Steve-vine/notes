---
id: 01M7R2AB39XV1HNE7E3XH0RN29
created: 2026-11-18T19:32:10.473722Z
updated: 2026-11-18T21:43:34.463429Z
type: task
title: 'Library reader: an info icon in the top bar opens the document''s details pane'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1974
sprint: s2q1gxe
assignee: steve
label:
- improvement
priority: medium
task_status: active
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