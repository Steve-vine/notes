---
id: 01M00JX0RFGYJA4H0GD5KC1J4B
created: 2026-08-14T16:50:20.559934Z
updated: 2026-08-25T18:43:21.178492Z
type: task
title: 'ADR 0042 — the Data Rubric: sensitivity levels, data types, sensitivity-driven approvals'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 205
sprint: sbph5q5
comments:
- id: 01M00QJ3MF7V3VY7CG1XY4SY9S
  author: Steve Vine
  at: 2026-08-14T18:11:45.935795Z
  text: |-
    ADR 0042 written and merged to main (PR #200, decisions/0042-data-rubric.md). Documentation only — no code.

    The three open points listed here are all settled in the ADR:
    - Engagements carry data types as a join table (integrity + a cheap "in use" guard); onboarding requests keep proposed ids in JSONB, since a proposal is a snapshot rather than a relation.
    - data_types_any is retained as an inert enum value. Postgres cannot drop one and migrations are append-only, so the API stops offering it and rule evaluation stops honouring it.
    - An engagement with no data types matches no min_sensitivity rule, mirroring how min_criticality treats a null criticality. Matching everything would make an unfilled field trip every approval area.

    Two things worth carrying forward: the argument for abandoning data_types_any is that it fails open (a typo on either side means no set intersection, so an approval area is silently not required — a control that reports success while doing nothing), and the migration destroys existing free-text values and data_types_any rules, which is recorded in §5 and the Consequences with a requirement to log everything dropped.

    Also settled during implementation: sensitivity is stored on approval rules as a rank int rather than an FK, matching how maturity levels are addressed by their level number — the scale is fixed and rows are never deleted, so the rank is a stable natural key.
assignee: steve
company: null
label:
- brief
priority: medium
task_status: done
---
Inception + decision record for replacing free-text engagement `data_types` with a governed **Data Rubric**, and re-pointing the approval criteria at **sensitivity** rather than at the data types themselves.

**Why an ADR:** this amends ADR 0039 §5–6 — the shape of `VendorEngagement.data_types` and the `ApprovalRuleKind` set are both decided there. ADR 0039 stays as accepted; 0042 amends it (append-only, supersede-never-rewrite).

**The decision to record**

* **Sensitivity is a rubric, not an enum.** A fixed, ordered 4-level scale — Public / Internal / Confidential / Restricted — as *editable reference data*, exactly like the 0–5 maturity rubric (`models/maturity_level.py`, ADR 0018): the scale is fixed, only the wording is edited, and every edit is kept as a revision so a sensitivity recorded against past data stays interpretable. Organisation-wide, not company-scoped, matching the maturity and risk rubrics.
* **Data types are a governed vocabulary** — name, definition, and a sensitivity level — managed on the same Admin tab, **starting empty** (no seeded list; each deployment defines its own).
* **Approval rules key off sensitivity, not data types.** `data_types_any` gives way to a `min_sensitivity` threshold, mirroring the existing `min_criticality` rule kind: an engagement's *effective sensitivity* is the highest sensitivity across its data types, and the rule fires at or above the threshold. This is the point of the redesign — the sensitivity of the data is the thing approvals actually care about, and encoding it once in the rubric stops it being restated in every rule.
* **Migration position:** existing free-text values on engagements are **cleared**, not adopted — a deliberate choice (the vocabulary starts empty). Any existing `data_types_any` rules can no longer match and go with them. Both must be **logged by the migration** so an admin can re-create them, and the live data checked before the migration runs.

**Open points to settle in the ADR**
* Whether an engagement carries data types as a join table or a JSONB id list — a join table makes the "in use, disable instead" guard cheap; `proposed_data_types` on onboarding requests probably stays JSONB alongside the other `proposed_*` columns.
* Whether `data_types_any` is removed from the `approval_rule_kind` enum or retained as an inert legacy value (Postgres cannot drop an enum value; append-only migrations point at retaining it).
* Whether an engagement with no data types can ever match a `min_sensitivity` rule (proposal: no, mirroring how `min_criticality` handles a null criticality).

**Done when:** `decisions/0042-*.md` is merged, records the above with alternatives considered, and notes the ADR 0039 amendment.

Refs: ADR 0039 §5–6, 0018 (rubrics as versioned reference data), 0011, 0026, 0015.