---
id: 01M7RPB9EYMR1EF1NQH3YZBNXK
created: 2026-11-19T01:22:13.086857Z
updated: 2026-11-19T01:46:29.923715Z
type: task
title: 'Leaving the Library reader returns to exactly where you were: no stray details pane, and a search keeps its results'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1984
sprint: s2q1gxe
comments:
- id: 01M7RQQK8VVK0KT5T2CG8SDMMB
  author: Steve Vine
  at: 2026-11-19T01:46:24.922959Z
  text: |-
    Fixed in PR #1978, merged to main as 649ffa3b.

    What changes for a person:
    - Open a document from a folder, Not in a folder, the home, Recently viewed or Pinned. Then Esc, "Library" in the bar, or "Back to the Library" goes back to that page with no details pane, scrolled where you were. It's the same as the browser's Back.
    - Open one from a search: the way back goes to the search results, with the words and the "This folder / Everywhere" choice kept. A type chip is kept too.
    - Open one from the pane's "Read document": the way back reopens the pane on the document, as before.
    - A reader link opened in a new tab, or pasted, also goes back to the right page, because the reader's address now carries the search and chip as well as the folder. Its way back doesn't reopen the pane unless the link came from the pane.

    Assumption: the type chip travels with the search, so you come back to the same filtered page.

    Tests cover each case above, including round trips through the real reader from a Not in a folder card, a search row and a Pinned tile.
assignee: steve
label:
- bug
priority: high
task_status: review
---
Found at pre-UAT of COM-1972 (staging 25f02b9c, 19 Nov). Since COM-1972, clicking a document opens the reader directly rather than the details pane, but the reader's own ways back still assume you came from the pane.

**Defect 1: a details pane that was never opened reappears.**
- Reproduce: Library > Not in a folder > click the "E2E pre-UAT COM-1960 fit to page" card. In the reader, press Escape, or click "Library" in the bar, or "Back to the Library".
- Seen: /library/unfiled?doc=content:e2e-pre-uat-com-1960-fit-to-page, with the details pane open. The same happens from the home and from a folder.
- Expected: back to the folder as it was, with no pane.

**Defect 2: coming from a search, the reader's ways back drop the search.**
- Reproduce: on the Library home, search "Access Control Policy" (the address becomes ?q=…) and click the first row. In the reader, press Escape or "Back to the Library".
- Seen: /library?doc=content:access-control-policy, with an empty search box and the pane open. The search row's link carries no place: /library/read/content/access-control-policy.
- Expected: back to the search results, as the browser's Back already does.

**Fix:** the reader's way back goes to the place the document was opened from (folder, Not in a folder, home, or search with its query and "everywhere/this folder" choice), and reopens the pane only if the reader was opened from the pane's Read document. Search rows, Recently viewed tiles and Pinned tiles pass their place, the way folder cards do.

**Done when**
- From a folder, Not in a folder, the home, Recently viewed or Pinned: click a document, then Escape, "Library" or "Back to the Library" returns to that page with no pane open, scrolled where you were if practical.
- From a search: the same returns to the search results with the query (and its scope) intact.
- From the pane's Read document: the way back returns with that pane open, as before.
- The browser's Back keeps working as now. Tests cover each case.

Independent: frontend only (libraryFolders/reader.ts readerHref/place, ReaderPage/ReaderBar back actions, LibrarySearch/RecentShelf/pinned tiles).