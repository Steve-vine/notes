---
id: 01M7WXMZ1RRTC5ZNZR877VPV0T
created: 2026-11-20T16:46:47.864941Z
updated: 2026-11-20T17:38:08.374664Z
type: task
title: The "Show an existing flowchart" window describes following the latest version, not keeping one
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2031
sprint: s6y6p7g
comments:
- id: 01M7X0JW1W7JWYW4EYTQ8XQ3TA
  author: Steve Vine
  at: 2026-11-20T17:38:04.98806Z
  text: |-
    Done — PR #2026, merged c29771f8.
    - The "Show an existing flowchart" window (Insert ▸ An existing flowchart…) now reads: "The document shows the flowchart's latest published version, and its draft moves on each time the flowchart is published again. To keep one version, pin it in the flowchart's settings. Readers see a new version only once the document itself is published again."
    - Polaris's own description of how a document shows a standalone flowchart now says the same: it follows the latest published version unless pinned, and the published document keeps its version until it's published again. Its tool descriptions already said this after COM-2027.
    - On the newer-version page (opened from "Take or keep the new version" for a pinned flowchart):
      - Take now confirms "<document>'s draft follows the latest again, version N. Publish it there."
      - Keep now confirms "<document> stays pinned to version M. You'll hear again when a version after N is published."
    - I found no other text describing the old keep-the-version behaviour.
    To check on staging: open a document's Edit tab, choose Insert ▸ An existing flowchart… and read the window.
assignee: steve
label:
- bug
priority: medium
task_status: review
---
Found in Claude's pre-UAT of COM-2027 (staging b65d7ed8, tester C).

The window for adding a standalone flowchart to a document ("Show an existing flowchart") still says it "…keeps that version until you take a newer one". Since COM-2027 that's wrong: the document follows the flowchart's latest published version, and it can be pinned.

**Done when**
- The window's wording says the document shows the flowchart's latest published version, and that it can be pinned to a version in its settings. It also says the published document changes only when the document is published again.
- Any other help text, empty state or Polaris description that still describes the old keep-the-version behaviour is updated too (search for "take a newer", "keeps that version" and similar).