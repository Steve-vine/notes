---
id: 01M7WMCZCH2N0BB6K8QMX4CX19
created: 2026-11-20T14:05:08.881922Z
updated: 2026-11-20T14:05:29.751943Z
type: task
title: 'A flowchart''s colours always come from one house style: its document''s, or for a standalone flowchart, its own type''s'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2024
sprint: s6y6p7g
assignee: steve
label:
- bug
priority: high
task_status: todo
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