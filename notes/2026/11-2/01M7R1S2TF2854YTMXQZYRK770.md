---
id: 01M7R1S2TF2854YTMXQZYRK770
created: 2026-11-18T19:22:44.943218Z
updated: 2026-11-19T00:01:33.814469Z
type: task
title: 'Library: clicking a document opens it to read; a small info icon opens its details'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1972
sprint: s2q1gxe
comments:
- id: 01M7RHQFYB2SAYKHQSG1159352
  author: Steve Vine
  at: 2026-11-19T00:01:30.059682Z
  text: |-
    Merged: PR #1971, sha 38a03c63. No migration, no API change.

    What changed: clicking a document card, a search result row or a Recently viewed tile opens the document in the reader straight away. A small ⓘ at each card's bottom right (and each row's right-hand end) opens the details pane as a click used to. Ctrl/Cmd-click and middle-click open the reader in a new tab. Dragging to a folder and the "…" menu don't open the reader. The e2e Library crawl now opens the pane from the ⓘ.

    For Steve to overturn: none beyond the task's own choices.
assignee: steve
label:
- improvement
priority: medium
task_status: review
---
Steve, testing the Library (18 Nov): "Currently clicking on a document opens the properties windows and then I have the click the Read document button. Add a small info icon to each document tile in the bottom right corner that opens that properties window, and instead when clicking on the main tile open the document directly."

## What changes
- **Clicking a document opens it in the reader** straight away — no stop at the details pane first.
- **A small info icon (ⓘ) sits in the bottom-right corner of every document tile.** Clicking it opens the details pane as a click does today (summary, folders, tags, Read document, etc.). Tooltip/label: "Details".
- Applies everywhere a document is shown in the Library: folder tiles, Not in a folder, Recently viewed (and Pinned once COM-1968 lands), and the search result rows (the icon at the row's right-hand end).
- Ctrl/Cmd-click, middle-click and "Open in new tab" open **the reader** in a new tab (the link itself points at the reader), not the Content page.
- The info icon and the tile's "…" menu don't open the reader; dragging a tile to a folder still works.
- A document the reader can't show (if any — see `readerHref` returning null) falls back to today's behaviour: the click opens the details pane.

## Implementation notes
- `libraryFolders/LibraryCards.tsx` `DocumentCard`: the `Anchor` currently links to `documentHref(doc)` (/content/slug or /decisions/n) and a plain click calls `onOpen` → pane. Change the link to `readerHref(doc, place)` and the plain click to navigate there; add an `onDetails` prop rendering an ActionIcon (Phosphor Info, size ~sm, variant subtle, `data-card-raised` so it sits above the card link) in the footer row, right-aligned beside "In N folders".
- Same for `RecentShelf.tsx` `RecentCard` and `LibrarySearch.tsx` `DocumentRow`.
- `LibraryPage.tsx`: pass `onDetails` = the current open-pane handler; reader opens with the current place (folder/search) so the reader's Back returns to it.
- Accessible name: "Details for <title>"; keyboard: tile link Enter → reader, info icon is its own tab stop.
- Frontend only; **independent** (no migration, no API change). Plays alongside COM-1967/1968 (unpin icon is top right; info is bottom right — no clash).

## Done when
- A plain click on any document tile or search row opens that document in the reader; Back returns to where you were.
- The ⓘ on each tile/row opens the details pane, and its Read document still works.
- Ctrl/Cmd-click opens the reader in a new tab.
- Drag-to-folder and the "…" menu still work and don't open the reader.
- Tests cover click → reader, info → pane, modifier-click left to the browser.