---
id: 01M0886SDBKXYMPE9M8VY9V83J
created: 2026-08-17T16:17:21.835909Z
updated: 2026-08-17T16:17:44.720612Z
type: task
title: Recertification UI — reviewer queue, campaign progress, evidence
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 242
sprint: s5gwx0s
assignee: steve
label:
- feature
priority: medium
task_status: todo
---
The recertification screens in the Access section.

* **Reviewer queue**: "my reviews" — per-campaign groups with member rows (name, UPN, group, when membership was snapshotted, last sign-in from the mirror if cheap to carry); certify / flag-for-removal per row plus bulk-certify for the common case; a flagged row shows it awaits second-person approval before anything executes.
* **Campaign management**: cadence/scope configuration; campaign list with progress (certified / flagged / pending / overdue), open items by reviewer; the approval queue for flagged removals (mirrors the JML approve pattern — same mental model, same components where possible).
* **Evidence**: closed-campaign view — the frozen completion record, per-item attestations (who/when/decision/outcome), executed removals with their Graph results. **CSV export** of a campaign's evidence via the ADR 0024 report service pattern (reuse the derivation, stream, persist nothing) — this is the artefact handed to an auditor.
* Dashboard presence: an "open recert campaigns / overdue reviews" tile can ride the existing dashboard patterns — small, but it's what makes cadences actually get met.

Refs: ADR 0045, 0024, 0022, 0017.