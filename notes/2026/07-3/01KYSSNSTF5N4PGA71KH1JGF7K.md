---
id: 01KYSSNSTF5N4PGA71KH1JGF7K
created: 2026-07-30T15:18:21.263118Z
updated: 2026-07-30T15:54:29.06444Z
type: task
title: Propose-action panel — operator-initiated changes from the UI
project: 01KX671DATY39VW6GWK3M2T3DN
number: 376
order: 1.5
sprint: sv6hnwj
blocked_by:
- 01KYSSN42K1D6H33R6AX3A0RPR
assignee: steve
label:
- feature
priority: medium
task_status: active
---
The sprint's pane-of-glass slice: today no UI can *propose* an action — `POST /api/v1/proposed-changes` (`api/v1/proposed_changes.py:104`, OperatorUser) has zero frontend callers; only AI and playbooks initiate. Build a **connector-generic Actions panel** on SystemDetailPage:

- Lists the system's `action_catalogue` (already served by `GET /api/v1/connectors/{type}`) with tier pills; schema-driven param form generated from each action's JSON Schema; submit → `POST /proposed-changes` → the normal approval flow (tier is never client-supplied).
- Post-submit messaging per `lib/approvalRules.ts`: T2+ "queued for approval" with a link to the Approvals queue; T1 explains default-deny (still queues unless policy allows auto-apply).
- Write-status surfaced: panel disabled with a "read-only — grant a write credential in Settings" explainer when the system has no `write_credential_ref`; show write status on the AwsAccountCard.
- Replaces/augments the "No action catalogue" placeholder branch (`SystemDetailPage.tsx:418`).
- api-types regen (`dump_openapi` + `npm run generate:api`) if the proposed-changes schema shifts; Vitest coverage for form generation, gating, and submit.

Acceptance: an operator can reboot a sick EC2 instance entirely from the app — pick the action on the System page, submit, approve in the queue, see the execution result + `before` snapshot on the audit trail.