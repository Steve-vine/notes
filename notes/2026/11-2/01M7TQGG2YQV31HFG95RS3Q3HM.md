---
id: 01M7TQGG2YQV31HFG95RS3Q3HM
created: 2026-11-19T20:21:01.150801Z
updated: 2026-11-19T20:35:00.490127Z
type: task
title: The document editor shows flowcharts, diagrams and images at the same size as the Read tab and print, with "Show as on paper" on or off
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2000
sprint: s6y6p7g
comments:
- id: 01M7TRA3RA8Y6PVXFMR6XRCWH8
  author: Steve Vine
  at: 2026-11-19T20:35:00.489913Z
  text: 'Steve added (19 Nov 20:35): a standalone flowchart added to a document already shows at a sensible size in the Edit tab. Only the document''s own flowchart is stretched there. So the document''s own flowchart should be shown the same way the standalone one is (COM-1998 covers the details). The same goes for any other picture kind that differs between the Edit tab and the Read tab.'
assignee: steve
label:
- bug
priority: high
task_status: todo
---
Steve's smoke test of round 2: flowcharts, diagrams and images change size in the document editor when "Show as on paper" is switched on or off. They should stay the same size.

Steve added: the Read tab and print preview already get it right. The 3-box flowchart shows at a sensible size, and images and diagrams show at the size he resized them to. Only the editor differs. The editor should look like the finished product.

**The finished product is the reference.** The Read tab and print preview / PDF show the size to match, and the editor follows them, not the other way round.

Likely cause: in the editor, a picture's width is kept as a share of the column it sits in. With "Show as on paper" off, that column is the editor's full width. With it on, it's the page's text width (e.g. 166 mm on the built-in A4 style). So the same 50% is a different size in each mode. And in the editor a flowchart always fills the column, while the Read tab sizes it sensibly.

**Done when**
- In the editor, with "Show as on paper" on or off, an image, drawing, text diagram or flowchart is the same size and shape as in the Read tab and print preview, at the same browser zoom. Switching mode, or between Edit and Read, doesn't change its size.
- A flowchart in the editor is the size the Read tab gives it (e.g. a 3-box flowchart is small, not full width), not stretched to the column.
- A picture's size means the same everywhere: the editor, the Read tab, print preview, the PDF and Word.
- With "Show as on paper" off, a picture is never wider than the editor column. On a narrow window it shrinks to fit, keeping its proportions, as the Read tab does.
- With "Show as on paper" on and the sheet shrunk to fit a narrow window, pictures shrink with the sheet as now.
- Resizing a picture in the editor, in either mode, shows that size straight away in the Read tab and print preview.
- The Read tab, print preview, PDF and Word don't change. Pictures already in documents keep their saved size.
- Tests cover a picture with a set width, one with no width, and a small flowchart: the same size in the editor (both modes) as in the Read tab.

Relates to:
- COM-1997 (corner resize handle);
- COM-1998 (flowchart sizing);
- COM-1999 (settings panel).

Independent: frontend document editor only.