---
id: 01M7WXMV77PD0FN42DZBZZRK6V
created: 2026-11-20T16:46:43.94332Z
updated: 2026-11-20T17:20:25.810533Z
type: task
title: A flowchart someone chose to Keep on an older version stays pinned to it when documents switch to following the latest
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2030
sprint: s6y6p7g
comments:
- id: 01M7WZJEP5PESQP4C880BA08MR
  author: Steve Vine
  at: 2026-11-20T17:20:22.72525Z
  text: |-
    Done — PR #2024, merged ff32e394.
    - A document where someone chose Keep on an older flowchart version is now "Pinned to version N" in its draft, N being the version they kept. Its Edit tab, print preview and settings panel show that version again.
    - When the pinned draft then shows exactly what the published document shows, it no longer reads "draft changes", there's no "Publish … to include" action, and it can be reviewed. More generally, pinning a flowchart to the version the published document already shows isn't an unpublished change, because a published document never moves on anyway. Pinning to any other version still is.
    - If a newer version than the one kept through has been published since, the owner gets "Take or keep the new version" for it, as they would have before COM-2027.
    - Documents that took a newer version, or never had a decision, keep following the latest. Published versions are untouched.
    Assumptions:
    - Compass recorded that someone chose Keep, but not which version they kept. That version is read from the document's last published version, and only where it is certainly what the draft showed: older than the version kept through, and the draft not saved since that publish. A Keep that fails that check keeps following the latest; a person can pin it in the settings panel. On staging the one Keep passes the check.
    - Production has no flowcharts yet, so there it changes nothing. It's tested for the case where both migrations run together.
    To check on staging (after the next deploy): "E2E pre-UAT COM-1908 Document B (Keep)" should show version 3 on its Edit tab, with "Pinned to version 3" in the panel and the note "Pinned to version 3. Version 5 is published. Use latest". It should have no draft changes and no "Publish … to include" action, and its owner should have a "Take or keep" action for version 5.
assignee: steve
label:
- bug
priority: high
task_status: review
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