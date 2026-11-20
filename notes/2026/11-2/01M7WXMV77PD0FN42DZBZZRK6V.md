---
id: 01M7WXMV77PD0FN42DZBZZRK6V
created: 2026-11-20T16:46:43.94332Z
updated: 2026-11-20T16:47:23.855771Z
type: task
title: A flowchart someone chose to Keep on an older version stays pinned to it when documents switch to following the latest
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2030
sprint: s6y6p7g
assignee: steve
label:
- bug
priority: high
task_status: active
---
Found in Claude's pre-UAT of COM-2027 (staging b65d7ed8, tester C).

COM-2027's migration moved every existing standalone flowchart in a document's draft on to the flowchart's latest published version, on the assumption that "none was deliberately pinned". But before COM-2027, a person could answer the "take or keep the new version" action with **Keep**, and that is a deliberate choice. On staging, "E2E pre-UAT COM-1908 Document B (Keep)" had been kept on version 3, and the migration moved its draft to version 5 anyway.

**Done when**
- A flowchart in a document where someone chose Keep becomes "Pinned to version N" in the draft, N being the version they kept. This applies to the latest Keep decision for that flowchart in that document.
- On staging, where the earlier migration has already run, the kept documents' drafts are put back to pinned on their kept version. Their "draft changes" and "Publish … to include" actions clear if the draft then matches the published version again.
- On production, where neither migration has run yet, the end result is the same: Keep → pinned, everything else → follows latest.
- Published versions are untouched.
- Tested against a populated database, including a Take, a Keep, and a document with no decision.

**Technical:** 0883 is merged, so don't edit it. This needs a new data migration, **0885**, with down_revision 0884_flowchart_custom_colours. First find where a Keep decision was recorded (the action's resolution, the activity log, or the ref's own stored version versus the latest at decision time). If a Keep can't be told apart reliably, say so on the task and stop.