---
id: 01M5G0Y8EETEVC34RKEFHCH612
created: 2026-10-21T20:02:46.862389Z
updated: 2026-10-21T20:05:17.250914Z
type: task
title: An assessment's history shows the evidence each version rested on — adding, replacing or archiving evidence is part of its history — and Evidence of operation sits beside the assessment in the Assessments queue
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1212
sprint: sno3i7m
blocked_by:
- 01M5G0XX177RTDXHNDWTVG613R
assignee: steve
label:
- feature
priority: medium
task_status: todo
---
Sprint 82, Evidence (ADR in COM-1198). Builds on COM-1211.

**Chain:** on the chain — migration + API

## What people see

- **Each saved version of an assessment records the evidence that was current when it was saved**: files and links, with their versions.
- **History** (on the control's page and on the assessment card) shows, for each version: status, maturity, notes and its evidence. So "what did we have when we said Implemented in March?" can be answered. Today History shows only status and maturity.
- **Evidence changes are part of the history.**
  - Adding, replacing, archiving and linking evidence each appear as an entry ("Added firewall-review-2026.pdf", "Replaced v1 with v2").
  - These don't count as a review, so the review dates stay as they are. *(My call.)*
- **Assessments queue:** the focus view shows the control's **Evidence of operation** beside the assessment, so the assessor sees what the modules have done before judging. Today it's only on the control's page.

## Notes (technical)

- An `assessment_revision_evidence` snapshot (revision id → evidence id + version) written on every save. The old `evidence_links` JSONB in past revisions is read as their link list. Retire the JSONB writes (COM-1200 kept it read-only).
- Evidence events in the history come from the evidence rows' own dates, merged into the revision list. They aren't new revisions.
- `EvidenceOfOperationCard` reused in `AssessmentsQueuePage` focus view.

**Done when:** saving an assessment, replacing one of its files and saving again shows two versions in History, each with the file version it had; the queue's focus view shows Evidence of operation.