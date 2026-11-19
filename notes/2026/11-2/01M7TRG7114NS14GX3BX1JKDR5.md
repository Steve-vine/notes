---
id: 01M7TRG7114NS14GX3BX1JKDR5
created: 2026-11-19T20:38:20.449271Z
updated: 2026-11-19T20:38:23.058036Z
type: task
title: Each document remembers its own "Show as on paper" choice
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2002
sprint: s6y6p7g
assignee: steve
label:
- improvement
priority: medium
task_status: todo
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