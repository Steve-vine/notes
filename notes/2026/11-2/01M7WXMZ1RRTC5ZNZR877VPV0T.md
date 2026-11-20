---
id: 01M7WXMZ1RRTC5ZNZR877VPV0T
created: 2026-11-20T16:46:47.864941Z
updated: 2026-11-20T17:03:28.499372Z
type: task
title: The "Show an existing flowchart" window describes following the latest version, not keeping one
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2031
sprint: s6y6p7g
assignee: steve
label:
- bug
priority: medium
task_status: active
---
Found in Claude's pre-UAT of COM-2027 (staging b65d7ed8, tester C).

The window for adding a standalone flowchart to a document ("Show an existing flowchart") still says it "…keeps that version until you take a newer one". Since COM-2027 that's wrong: the document follows the flowchart's latest published version, and it can be pinned.

**Done when**
- The window's wording says the document shows the flowchart's latest published version, and that it can be pinned to a version in its settings. It also says the published document changes only when the document is published again.
- Any other help text, empty state or Polaris description that still describes the old keep-the-version behaviour is updated too (search for "take a newer", "keeps that version" and similar).