---
id: 01M7PVGXJ48CQ5DWT233SJ3JMQ
created: 2026-11-18T08:14:11.524044Z
updated: 2026-11-18T08:14:18.128067Z
type: task
title: 'Flowchart loose ends from pre-UAT: search snippets in words, links named as flowcharts, no Hand-off to itself, Delete disabled when refused'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1932
sprint: s6y6p7g
assignee: steve
label:
- bug
priority: medium
task_status: todo
---
Pre-UAT, 2026-11-18 (testers' observations on COM-1904/1906/1908):
- **Search:** a result for a document with a flowchart shows raw markup and JSON in its snippet. It should show the steps in words, as the plain-text form does.
- **Links list:** in PDF and Word, and on screen, the Links list calls a link to a standalone flowchart "Document …". It should say "Flowchart …".
- **Hand-off picker:** on a standalone flowchart, the picker offers the flowchart itself. A flowchart can't hand off to itself.
- **Delete:** when the delete dialog already says deleting is refused (a published document shows the flowchart), its Delete button stays enabled, and pressing it repeats the refusal. It should be disabled, with the reason beside it.
- **Compare versions:** a document's raw Compare diff shows `{{flowchart: <id> version 3}}`. It should read "Flowchart <title>, version 3".

**Done when**
- All five read as described above, each covered by a test.

Independent unless the snippet fix needs an API change.