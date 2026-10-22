---
id: 01M5G0Y8EETEVC34RKEFHCH612
created: 2026-10-21T20:02:46.862389Z
updated: 2026-10-22T03:42:52.830642Z
type: task
title: An assessment's history shows the evidence each version rested on — adding, replacing or archiving evidence is part of its history — and Evidence of operation sits beside the assessment in the Assessments queue
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1212
sprint: sno3i7m
blocked_by:
- 01M5G0XX177RTDXHNDWTVG613R
comments:
- id: 01M5GV8PNF5Q7KDV16PA09B3DP
  author: Steve Vine
  at: 2026-10-22T03:42:52.079071Z
  text: |-
    Done — merged in PR #1226.

    - Each save of an assessment now records the evidence it rested on: its own files and links, each at its version, and any evidence linked to the control from elsewhere.
    - **History**, on the control page and on the card, shows each version's status, maturity, who and when, plus its notes and its evidence. For example: "Evidence: access-q3.pdf (v2) · joiners.pdf — linked from elsewhere". So "what did we have when we said Implemented in March?" can now be answered.
    - Versions saved before this change show their links and say "Saved before Compass kept each version's files, so its files weren't recorded."
    - **Evidence changes** appear between the versions as lighter entries, with who and when: "New version of access-q3.pdf (v2)", "Archived … — Superseded", "Linked from elsewhere: …", "Unlinked …". They aren't versions and don't count as a review, so the review dates don't move.
    - **The Assessments queue's focus view** shows the control's Evidence of operation above Gaps, so the assessor sees what the modules have done before judging.
    - The assistant's history gives each version's evidence and the evidence changes too.

    My calls (beyond the task):
    - **Each version keeps its own record of its evidence.** It isn't worked out from dates, so it survives the files moving on, including archived files being deleted for good later (COM-1215).
    - **Linked evidence is included.** A restricted incident's or data subject request's file is named the way Activity names it ("evidence file on INC-12").
    - **Nothing is guessed for older versions.** Working out from upload dates which files they rested on would claim something that was never recorded.
    - **On the card,** evidence changes show what changed and when. Who made them is on the control's History tab.
assignee: steve
label:
- feature
priority: medium
task_status: review
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