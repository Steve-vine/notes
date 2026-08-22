---
id: 01M0MFZ5YKBJZ84F0MV1FX8CJC
created: 2026-08-22T10:23:54.323534Z
updated: 2026-08-22T15:50:00.589479Z
type: task
title: Assessment Rules tab — approval-area machinery that assigns assessments instead of people
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 354
sprint: sbph5q5
comments:
- id: 01M0MQYDXQ0QQ5QCZM5X17BYH7
  author: Steve Vine
  at: 2026-08-22T12:43:18.327298Z
  text: |-
    Done — PR #356, merged to main.

    The same question about the same inputs: given a vendor's engagement, what does it need? Approval areas answer with **people**, assessment rule sets with **forms**. So it is the same triple, because two shapes for one question is how the two tabs would come to disagree.

    ## Nothing is copied where it matters

    - **One kind enum**, Python *and* Postgres. `assessment_rules.kind` takes the existing `approval_rule_kind` type — declared with `postgresql.ENUM(create_type=False)`, or it would pass on a fresh CI database and fail on every incremental deploy.
    - **One matcher.** `rule_matches` now reads a `TypedRule` **Protocol** instead of `ApprovalRule`. That is not "a second implementation is discouraged" — there is nowhere to put one. `test_rule_semantics_are_identical_to_the_approval_evaluation` asserts it directly: every kind × every engagement shape, both rule types, same verdict.
    - **One rule editor** on the frontend (`RuleEditor.tsx`), shared by both tabs. A copied editor would undo the shared matcher from the other end — the two surfaces evaluating identically while *offering* different thresholds is the same disagreement, one step earlier.

    `required_form_ids` returns the **union** across matching sets: "everything critical" and "anything touching personal data" are separate policies an engagement often trips at once, and a form both name is required once. Retired sets contribute nothing.

    ## Two deviations from the task, both deliberate

    **1. `form_id` is RESTRICT, not CASCADE.** The task sketched "CASCADE both ways" from the approver join. `vendor_approvers` cascades from `users` because a deleted user cannot approve anything and the row is then meaningless. A form is the *content* the rule requires — dropping the membership silently would leave the rule set quietly requiring one assessment fewer than whoever configured it believes. This is also what the task's own "a form referenced by a rule set cannot be deleted (RESTRICT)" bullet asked for; the two bullets conflicted and RESTRICT is the one that matches the behaviour.

    **2. A rule set is hard-deletable**, unlike an approval area. An area accumulates decisions; a rule set holds only its own configuration, and both children cascade. `active` still turns one off without losing the setup.

    Retired forms are listed on the card and offered in the picker, marked — a set requiring a since-retired form is a misconfiguration worth *seeing*, not one to hide behind a correct-looking card.

    Tab rename Approvals → **Approval Rules**; **Assessment Rules** before it. Nothing consumes the evaluation yet, and the tab's copy says so.
assignee: steve
label:
- feature
priority: medium
task_status: done
---
On the admin Vendors page: rename the **Approvals** tab to **Approval Rules**, and add a new **Assessment Rules** tab *before* it (between Vendor Assessments and Approval Rules). The new tab duplicates the approval-area functionality — same typed rules, same OR semantics — but a matching rule set assigns **assessments** (vendor forms), not approvers. Multiple assessments per rule set.

## Backend

- [ ] New model mirroring the approval-area triple: an **assessment rule set** (named, per-company), a link table to `vendor_forms` (many — the `vendor_approvers` shape, CASCADE both ways), and typed rules using the **same kinds** as `ApprovalRuleKind` (`always_required`, `min_criticality`, `min_sensitivity`, `min_annual_cost`; `data_types_any` stays dead). Share the kind enum and the `rule_matches` evaluation in `core/vendor_approval.py` rather than copying them — the matching logic must never drift between the two tabs; if that means hoisting `rule_matches`/`ProjectedEngagement` into a neutral module, do that.
- [ ] Evaluation function analogous to `required_area_ids()`: given a vendor/engagement (or projection), the set of assessment (form) ids the rule sets require.
- [ ] CRUD API mirroring `approval_areas.py`, gated the same (`require_vendor_write` admin-side read+write; the assessment picker lists the company's forms).
- [ ] A form referenced by a rule set cannot be deleted (RESTRICT, matching "a form with assessments cannot be deleted").

## Frontend

- [ ] Tab rename Approvals → **Approval Rules** (`VendorsPage.tsx`); new **Assessment Rules** tab before it, `canEdit`-gated like its neighbours.
- [ ] Duplicate the Approval Rules tab's UI: rule-set cards with name, the rules editor (same kind pickers/thresholds), and a multi-select of assessments from the forms list in place of the approver picker.

## Explicitly out of scope (the next piece)

What *happens* when rules match — when the required assessments get attached to a vendor and who is assigned to complete them — is the assignment design still to be specified. This task builds the rules surface and the evaluation function; nothing consumes the evaluation yet. (COM-190 already anticipated "auto-attach at onboarding comes later" — that wiring belongs to the follow-up, alongside the assignee question.)

- [ ] Tests: CRUD + gating; evaluation returns the union of matching sets' forms; rule semantics identical to the approval evaluation for the same inputs; RESTRICT on referenced forms.