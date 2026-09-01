---
id: 01M0PZA3VSGP8VXASSJF2FZG0F
created: 2026-08-23T09:30:30.137645Z
updated: 2026-09-01T13:55:50.667239Z
type: task
title: Compliance rules tab — conditions over the shared rule kinds, expectations over the Assurance profile
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 385
sprint: sbph5q5
comments:
- id: 01M0QAZ40YQY798W0KYDZ4Q5T2
  author: Steve Vine
  at: 2026-08-23T12:54:12.76598Z
  text: |-
    Done — PR #387, merged to main as 8bca710.

    Built as specified. The condition half takes `approval_rule_kind` — the same Postgres type — and the same threshold columns, judged by the one `rule_matches`; the frontend shares one `RuleEditor` for the same anti-drift reason, gaining `before`/`after` slots rather than a second modal that would let two tabs *offer* different thresholds while the backend evaluated them identically. Flat, as you recommended. Expectations are the five booleans plus `breach_notification_hours ≤ N`, with null failing.

    Advisory as designed: violations only, no write to `compliance_status` anywhere in the path — and a test asserts the vendor does not move, rather than a comment promising it. They surface on the Assurance card and beside the record-review form.

    One deviation from the note: it asked for the **violation payload on the vendor read**. I gave it its own endpoint, `GET /vendors/{id}/compliance-violations`, for the reason `required-assessments` has one — evaluating costs a query per vendor, and the register would pay for an answer only the detail page asks for. There is a second reason I think is the stronger one: an empty list on a row nobody evaluated reads as "nothing wrong", which is a worse thing for a governance tool to say than nothing at all. The register-level indicator you left for later can be built on the same endpoint.

    ADR 0039 has the amendment. Migration 0104 owns only the new `compliance_expectation` type and reuses the two existing ones with `create_type=False` — the COM-354 lesson about `sa.Enum` passing on a fresh CI database and failing on every incremental deploy.

    Tests: the shared matcher, every expectation including its null case, the boundary on hours, retired rules, ordering, and the any-matching-engagement rule; CRUD, both halves' validation (including a `data_types_any` rule being refused), gating, the endpoint, and the no-status-write guarantee. Frontend covers the tab and the strip — including that it stays silent when there is nothing to say, rather than congratulating a company for configuring no rules.
assignee: steve
label:
- feature
priority: medium
task_status: done
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