---
id: 01M0PZA3VSGP8VXASSJF2FZG0F
created: 2026-08-23T09:30:30.137645Z
updated: 2026-08-23T09:30:33.47829Z
type: task
title: Compliance rules tab — conditions over the shared rule kinds, expectations over the Assurance profile
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 385
sprint: sbph5q5
assignee: steve
label:
- feature
priority: medium
task_status: todo
---
A third rules tab in Vendor Management: **Compliance rules**, mirroring Assessment Rules and Approval Rules. A compliance rule states what should be true of a vendor's **Assurance profile** for it to be considered compliant — e.g. *"If Data Sensitivity ≥ Confidential then Data Processing Agreement should be Yes."*

## Shape: condition → expectation

- [ ] **Condition** reuses the shared rule kinds (`always_required`, `min_criticality`, `min_sensitivity`, `min_annual_cost`) and the one `rule_matches` evaluation — three tabs, one matching semantics, zero drift. The example's "Data Sensitivity ≥ Confidential" is `min_sensitivity` as it stands.
- [ ] **Expectation** targets a testable Assurance field: the five booleans (`has_dpa`, `has_security_clauses`, `has_audit_rights`, `has_bcdr_capability`, `has_cyber_insurance`) required **Yes**, and `breach_notification_hours` required **≤ N** (a `null` field fails the expectation — unknown is not compliant). The free-text notes fields are deliberately not offerable: prose can't be tested.
- [ ] Model mirrors the neighbours' shape (per-company rule rows; whether they group into named sets like approval areas or stay a flat list — flat recommended, there's no membership dimension here; keep the card UI consistent anyway).

## What the rules do — advisory, by design

- [ ] Evaluation produces **violations**, not a status write: "Rule: DPA required (sensitivity ≥ Confidential) — has_dpa is No/unset". Consistent with the compliance model (COM-361): **a Review is the only user lever on compliance**, and these rules inform the reviewer, they do not overrule them.
- [ ] Surface the violations where the judgment happens: on the vendor's Assurance card (a violations strip) and beside the record-review form (with the required-assessments context COM-361 put there). A register-level indicator can follow later if wanted.

## Tab & API

- [ ] **Compliance rules** tab beside the other two rule tabs, vendor-write gated, mirrored CRUD API (`approval_areas.py` as the template).
- [ ] Tests: CRUD + gating; condition semantics identical to the sibling tabs for the same inputs; each expectation type incl. null-fails; violation payload on the vendor read; no write to `compliance_status` anywhere in the path.