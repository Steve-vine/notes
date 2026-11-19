---
id: 01M7TRG7114NS14GX3BX1JKDR5
created: 2026-11-19T20:38:20.449271Z
updated: 2026-11-19T21:46:49.889526Z
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
assignee: steve
label:
- improvement
priority: medium
task_status: review
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