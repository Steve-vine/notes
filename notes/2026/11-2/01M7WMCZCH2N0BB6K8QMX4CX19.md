---
id: 01M7WMCZCH2N0BB6K8QMX4CX19
created: 2026-11-20T14:05:08.881922Z
updated: 2026-11-20T15:23:33.294646Z
type: task
title: 'A flowchart''s colours always come from one house style: its document''s, or for a standalone flowchart, its own type''s'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2024
sprint: s6y6p7g
comments:
- id: 01M7WRWEWC3BHRMM21NW7GEXYG
  author: Steve Vine
  at: 2026-11-20T15:23:30.572231Z
  text: |-
    Done — PR #2020, merged f8529974 (building on COM-2023, PR #2018, merged 4f52e136).
    A standalone flowchart now shows in its own content type's house style in every document it's added to, on the Read and Edit tabs. That covers its picture, full screen and PNG/SVG download. The document's own text keeps the document's colours.
    Edit flowchart, from any document or from its own page, opens its own page, and the canvas there is always in its own type's house style. Before, it took the house style of the document you came from.
    In PDF and Word, every document prints the picture kept with the flowchart's version, which is drawn in its own colours.
    A document's own flowchart always shows and edits in its document's house style.
    The flowchart is no longer marked as having unpublished changes just from being opened from another document. That happened when its page re-saved the picture in the other document's colours, and it can't now.
    Assumption: in PDF and Word a flowchart's words print in the document's font, as every flowchart's do (COM-1982), so it reads like the text around it. Its colours are its own.
    Assumption: a flowchart whose picture was saved in the wrong colours before this fix (only during testing on staging) is put right the next time it's edited and published.
    To check on staging: add one standalone flowchart to two documents whose types have different house styles. Check it's in its own type's colours in both. Edit it from each and check the canvas colours. Then print both.
assignee: steve
label:
- bug
priority: high
task_status: review
---
Steve (testing round 3): take two documents with different house styles, create a new standalone flowchart, and add it to both. In each document it shows in the colour scheme it was saved in. Edit it, though, and the editor opens in the colour scheme of whichever document it was opened from.

Steve's rule, which is the simple solution:
- A document's own (embedded) flowchart only ever uses the colour scheme of the document it belongs to.
- A standalone flowchart, wherever it's included, only ever shows in the colour scheme its own content type is mapped to.

**Done when**
- A standalone flowchart shows in its own type's house style in every document it's added to, on the Read and Edit tabs, in print, PDF, Word, its picture and downloads.
- Editing it, from any document or from its own page, opens the canvas in its own type's house style, never the house style of the document it was opened from.
- A document's own flowchart always shows and edits in that document's house style. Assumption: if the document's type, or the house style mapped to it, changes, the flowchart follows the new house style.
- A standalone flowchart in its own house style isn't marked as having unpublished changes just because it's shown inside another document.
- Tests cover one standalone flowchart added to two documents with different house styles, viewed and edited from each.