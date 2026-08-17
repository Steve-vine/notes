---
id: 01M0886SDBKXYMPE9M8VY9V83J
created: 2026-08-17T16:17:21.835909Z
updated: 2026-08-17T22:17:18.899232Z
type: task
title: Recertification UI — reviewer queue, campaign progress, evidence
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 242
sprint: s5gwx0s
blocked_by:
- 01M0886MJ9QC97MCZXG824T3MP
comments:
- id: 01M08WSVKCWJ75HYABPZMEHSJ1
  author: Steve Vine
  at: 2026-08-17T22:17:18.188088Z
  text: 'Done — merged to main (PR #243, squash dd722bb). /access/recert with header stats (open campaigns, overdue reviews — the visibility that makes cadences get met): the "My reviews" queue grouped per campaign (name, UPN, group, snapshot date; certify / flag / bulk-certify; flagged rows say they await second-person approval), campaign management (cadence settings — monthly/quarterly/yearly + review window; hand-open by business role or mirror-fed group; list with progress and overdue badges), and the campaign page with the flagged-removal approval queue mirroring the JML approve pattern — the approve affordance is never offered to the attester ("needs another approver" badge instead), retry for failed removals, and the frozen completion-record banner once closed. Evidence CSV: GET /recert-campaigns/{id}/evidence (ADR 0024 derive-and-stream), one row per item naming reviewer, attester, approver, outcome and timestamps — the auditor artefact; the integration test asserts the maker-checker pair is named in it. Deliberate deviation: the open/overdue stats live on the Recert page, not the Company dashboard — Access is invisible to viewer/assessor by design (ADR 0045 §9), so the company dashboard is the wrong surface; the bell notifications deep-link here instead.'
assignee: steve
label:
- feature
priority: medium
task_status: review
---
The recertification screens in the Access section.

* **Reviewer queue**: "my reviews" — per-campaign groups with member rows (name, UPN, group, when membership was snapshotted, last sign-in from the mirror if cheap to carry); certify / flag-for-removal per row plus bulk-certify for the common case; a flagged row shows it awaits second-person approval before anything executes.
* **Campaign management**: cadence/scope configuration; campaign list with progress (certified / flagged / pending / overdue), open items by reviewer; the approval queue for flagged removals (mirrors the JML approve pattern — same mental model, same components where possible).
* **Evidence**: closed-campaign view — the frozen completion record, per-item attestations (who/when/decision/outcome), executed removals with their Graph results. **CSV export** of a campaign's evidence via the ADR 0024 report service pattern (reuse the derivation, stream, persist nothing) — this is the artefact handed to an auditor.
* Dashboard presence: an "open recert campaigns / overdue reviews" tile can ride the existing dashboard patterns — small, but it's what makes cadences actually get met.

Refs: ADR 0045, 0024, 0022, 0017.