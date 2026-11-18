---
id: 01M7PVGENDYMKMQK9S97BYPNXH
created: 2026-11-18T08:13:56.269826Z
updated: 2026-11-18T08:14:16.164026Z
type: task
title: Ask Polaris offers Draft from this document and Draft from a description on a new flowchart that only has its Start shape
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1930
sprint: s6y6p7g
assignee: steve
label:
- bug
priority: high
task_status: todo
---
Pre-UAT, 2026-11-18 (COM-1909):
- In a procedure with text, Insert ▸ Flowchart… then Ask Polaris. The canvas starts with a Start shape, so the panel offers only "Ask Polaris": neither Draft from this document nor Draft from a description appears.
- They only appear after the Start shape is deleted.
- The imports already treat a Start-only canvas as empty; Ask Polaris doesn't.
Screenshots: ~/compass-uat/s6y6p7g/COM-1909/11-draft-from-document-panel.png, 12-start-removed.png.

Also from the same pass:
- The section to draft from was labelled "main": it should use the section's own heading.
- A link Polaris left out (a made-up control, ZZZ.99) showed only in its chat summary. The panel's "Left out" line should list it.

**Done when**
- A new flowchart with only its Start shape offers Draft from this document (in a document) and Draft from a description, exactly as an empty canvas does. The rule for "empty" is the same one the imports use.
- The sections to draft from are listed by their headings.
- A link Polaris couldn't match is shown in the panel's Left out line.

Independent: frontend (plus the screen event if needed).