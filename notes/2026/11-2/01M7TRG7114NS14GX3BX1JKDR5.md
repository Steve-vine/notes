---
id: 01M7TRG7114NS14GX3BX1JKDR5
created: 2026-11-19T20:38:20.449271Z
updated: 2026-11-20T14:05:05.159332Z
type: task
title: Each document remembers its own "Show as on paper" choice
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2002
sprint: s6y6p7g
comments:
- id: 01M7TWDHW05A5N02BG770TS4WE
  author: Steve Vine
  at: 2026-11-19T21:46:47.552426Z
  text: |-
    Done — PR #1989, merged c6fa1386.
    Each document now remembers its own "Show as on paper" choice, one for the Edit tab and one for the Read tab, for everyone who opens it on any browser.
    Someone who can edit the document flips either switch and it's saved straight away: no draft, no new version, nothing in Compare or the history.
    Someone who can only read the document can flip the Read tab's switch for themselves; it lasts while they're on the page and changes nothing for anyone else.
    A document never set starts as before: Edit off, Read on. The old per-browser choice isn't carried over.
    Polaris's "Read a document" says how the document is shown on each tab.
    Assumption: the choice belongs to the document (as the task assumed). The Library's full-screen reader has no switch and isn't affected; PDF and Word are always on paper.
    To check on staging: set two documents differently, reload each, and open one as a reader to see the flip doesn't stick.
- id: 01M7V39D7QR8Q91YP7VG7Z5H8B
  author: Steve Vine
  at: 2026-11-19T23:46:51.767035Z
  text: |-
    Pre-UAT on staging 7ea67f64 — Passed
    Test documents "E2E pre-UAT COM-2002 paper doc one" and "… paper doc two", both published at v1.
    - Each document remembers its own choice, separately for Edit and Read, on any browser and for anyone: Passed. As E2E Admin A, doc one was set to Edit on / Read off, and doc two to Edit off / Read on (flipped off and back on, so it was set on purpose). E2E Admin B then opened both in a separate browser: doc one Edit on (paper sheet showing) / Read off; doc two Edit off / Read on.
    - An editor's flip is saved straight away, with no publish, no new version and nothing in Compare or the history: Passed. Each flip saved at once, with only the switch changed. The document stayed at v1 with no unpublished changes, the history still lists only v1, and there's nothing to compare.
    - A reader's flip is for them only, while they're on the page: Passed. As E2E Viewer (Read tab only), doc one opened with paper off. Flipped on, it showed the sheet, and nothing was sent to the server (no save of any kind). After a reload it was off again, and the document still read Edit on / Read off.
    - A document never set uses the starting points (Edit off, Read on), and the old browser choice isn't carried over: Passed. I put the old browser settings back into localStorage as "Edit on / Read off", then opened a never-set document ("E2E pre-UAT COM-2001 select a flowchart"). It still opened Edit off / Read on.
    - Applies wherever the document's own Edit and Read tabs show, including from the Library; PDF/Word unchanged: Passed. Library search → the full-screen reader, which has no switch, as the PR says → "Open in Content" → the Read tab off and the Edit tab on, as set. PDF and Word of doc one (Read off) are still A4 on paper, with the flowchart at 672×92 px.
    - Polaris returns the choice: Passed. "Read a document" on doc one returns shown_as_on_paper {edit_tab: true, read_tab: false}.
    - Tests: covered in the PR (backend test_document_paper_choice and ContentDetailPage tests); not re-run here.
    Screenshots: ~/compass-uat/s6y6p7g/COM-2002/
assignee: steve
label:
- improvement
priority: medium
task_status: done
---
Steve's smoke test of round 2: some documents look better with "Show as on paper" on and others with it off, so each document should remember its own choice.

Today the choice is remembered per person, in this browser only, and the same choice applies to every document. The Edit tab and the Read tab each have their own setting: Edit starts off and Read starts on, until the person changes them.

**Done when**
- Each document remembers "Show as on paper" for itself, separately for the Edit tab and the Read tab. Opening the document shows it the way it was last set for that document, on any browser and for anyone.
- Someone who can edit the document changes the document's choice by flipping the switch on either tab. It's saved straight away, with no need to publish and no new version. It's not in Compare or the version history.
- Someone who can only read the document can still flip the switch on the Read tab for themselves while they're on the page. That doesn't change the document's choice for anyone else.
- A document that has never had a choice set uses today's starting points: off on the Edit tab, on on the Read tab. A person's existing browser choice isn't carried over.
- The choice applies wherever the document's own Edit and Read tabs show, including a document opened from the Library. It doesn't change the PDF or Word, which are always on paper.
- Polaris's document tools return the choice but don't need to set it.
- Tests cover two documents with different choices each opening as set, a reader's flip not saving, and a never-set document using the starting points.

Assumption (Claude): the choice belongs to the document and is shared by everyone who opens it, since it's about how that document reads best. If Steve wants it per person instead, each person keeps their own choice for each document.

On the chain: the document keeps a new setting, which the API returns and saves.