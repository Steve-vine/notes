---
id: 01M5CMA0Y2ZSBQ32RKARP18D8N
created: 2026-10-20T12:24:17.602314Z
updated: 2026-10-20T16:00:49.354221Z
type: task
title: Content reviews show as Evidence of operation on the policy-review controls
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1156
assignee: steve
label:
- follow_up
priority: low
task_status: active
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