---
id: 01M5CMA0Y2ZSBQ32RKARP18D8N
created: 2026-10-20T12:24:17.602314Z
updated: 2026-10-20T18:09:26.898286Z
type: task
title: Content reviews show as Evidence of operation on the policy-review controls
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1156
comments:
- id: 01M5D4HYNXY34HNE93P50S5D3A
  author: Steve Vine
  at: 2026-10-20T17:08:14.653345Z
  text: |-
    Merged in PR #1159 at 17:07 UTC on 2026-10-20 (main 2e77b1de). Not yet on staging.

    **What changed:** on a company's assessment of **INS.15** and **INS.6**, Evidence of operation has a **Content reviews** line:
    - **Last done:** the most recent review recorded on a published document, who recorded it, and which document (with the review's comment).
    - **Next due:** the earliest review date still ahead, and its document.
    - **Warnings:** how many documents are past their review date, and how many have no review date at all. No published content at all is itself the warning.
    - Content is the shared playbook's, so every company's line reads the same documents. Drafts and deleted documents don't count.
    - INS.15 keeps its Attestations line beside it. Only people who can read the playbook see the line, and nothing about the assessment changes.

    **My calls:**
    - As in the task: fixed controls, found by their library key; not repeated on every control in a policy's domain; one line, not one per document.
    - **"No review date" is a warning too,** because INS.15 asks every policy to have a review cycle.
    - **The line opens the Content library.** The latest review names its document rather than linking to it, since the card's line carries one link.
    - Content is shared by every company, so there is no company-specific content to add.

    **Checks:**
    - Unit tests for every rule: reviewed, overdue, due today, never reviewed, no review date, no content.
    - Integration tests: the controls found by key; other controls show nothing; drafts and deleted documents ignored; readers without the playbook see nothing.
    - The Attestations, vendor (COM-1153) and SAP / assistant evidence tests all pass, plus ruff, ruff format and mypy.
    - No API or migration change.

    **CI:** run 39459565796 took 26.0 min, with backend-test at 24.8. The frontend job was skipped (backend only). I rebased once after COM-1153 merged.
assignee: steve
label:
- follow_up
priority: low
task_status: done
---
Split from COM-1060 (2026-10-20). Builds on COM-1051's Evidence of operation registry (ADR 0115 §10).

## Why

Each policy, standard and procedure has a review cycle, and recording its review is how Compass proves policies are kept current. The policy-review controls' assessments don't show it.

## What people see

On a company's assessment of these controls, Evidence of operation gains a **Content reviews** line:
- **INS.15** (`s42.INS.5`): every policy has an owner, an approval and a review cycle;
- **INS.6** (`INS.13`): management reviews policies at planned intervals.

The line shows:
- **Last done:** the most recent review recorded on published content, by whom, with a link to it.
- **Next due:** the earliest next review date.
- **Warning:** how many published items are past their review date.
- It counts the shared playbook's content plus any content specific to the company, since content is shared by every company.

The line is visible to people who can see the assessment and can view content.

INS.15 already shows an Attestations line (COM-1101). Both appear, each under its own label.

## My calls (to confirm)

- **Fixed controls:** the two above.
- **Not on every control in a policy's domain.** The original note suggested "the domain's policy for every company". A domain policy covers 10–30 controls by membership, so its review would repeat on every one of them, and it proves the policy is current, not that each control operates. If you want it, it can be a second line limited to the domain's policy, on that domain's controls.

## Notes (technical)

- New source module; `CONTROL_EVIDENCE` keyed by control key.
- Reuse COM-1048's content-review calendar adapter (`next_review_at`).
- Tests: reviewed, overdue and never-reviewed content; a reader without content view sees nothing.

**Done when:** on staging, a company's assessment of INS.15 shows a Content reviews line with the last review and the next due.