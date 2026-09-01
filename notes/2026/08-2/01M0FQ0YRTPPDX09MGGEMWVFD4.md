---
id: 01M0FQ0YRTPPDX09MGGEMWVFD4
created: 2026-08-20T13:51:00.378204Z
updated: 2026-09-01T13:55:50.356474Z
type: task
title: 'Approval rule: "Annual cost at or above…" — spend pulls in an approver'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 320
sprint: sbph5q5
blocked_by:
- 01M0FNYJRZE6WTWDEGAYGFD96B
comments:
- id: 01M0K7NQH1BE3YDFHHBPZXS67X
  author: Steve Vine
  at: 2026-08-21T22:39:41.601218Z
  text: |-
    Shipped — PR #334, merged to main (7aff874), migration 0090_min_annual_cost_rule.

    `ApprovalRuleKind.min_annual_cost` joins `ACTIVE_RULE_KINDS`, with a `Numeric(14, 2)` threshold column matching COM-318's storage exactly — same type both sides, so the boundary comparison is exact decimal rather than a float that is right except at the one value anybody tests. **At or above** holds: £50,000 matches a £50,000 threshold, £49,999.99 does not.

    Migration adds the enum value in an autocommit block and writes no row with it (a new value cannot be used in the transaction that added it). Existing rows unaffected — every rule has a null threshold and a kind that never reads it.

    **One thing done slightly differently from the brief.** Rather than mirror `min_sensitivity`'s two-step shape, the three threshold kinds in `rule_matches()` were made to read identically — every part of the comparison present, then the bar met — under one comment covering all three. So "a null threshold matches nothing, and so does a null value" is now visibly the same rule in all three places rather than three separately-argued ones. Ruff's return-count limit forced the question; this was the better answer to it.

    Tests: at / above / a penny under; null cost and null threshold each match nothing; an amendment raising the cost past a threshold pulls in the area and lands the figure; a new engagement exactly at the threshold needs the area and one under does not; an unpriced engagement trips nothing; **lowering the cost afterwards leaves an approval already given standing**; the rule round-trips through the API with its threshold intact and is refused without one. Frontend: the badge reads `Annual cost ≥ £50,000` through COM-318's money helper, and the modal will not save a threshold-less rule.

    Note for COM-319: this task is what decided its shape, and the reconciliation is recorded there.
assignee: steve
label:
- feature
priority: medium
task_status: done
---
A fourth active approval rule kind: **`min_annual_cost`** — "Annual cost at or above…". Spend joins criticality and data sensitivity as something that can require an approval area.

Depends on COM-318, which adds the engagement's estimated annual cost. This is the rule that judges it.

The name and label follow the two that already exist rather than inventing a phrasing: `RULE_KIND_OPTIONS` reads *"Vendor criticality at or above…"* and *"Data sensitivity at or above…"*, so this reads *"Annual cost at or above…"* and the summary line reads `Annual cost ≥ £50,000` beside `Criticality ≥ High`.

## Backend

- [ ] **`ApprovalRuleKind.min_annual_cost`**, added to `ACTIVE_RULE_KINDS`. Note the existing comment on `data_types_any`: an enum value cannot be dropped, so adding one is a one-way door — the name wants to be right first time.
- [ ] **Migration.** Two parts: `ALTER TYPE approval_rule_kind ADD VALUE` and a nullable `min_annual_cost` threshold column on `approval_rules`, matching COM-318's storage type exactly (`Numeric(14, 2)` if that is where it lands — the threshold and the value being compared must be the same type, or the comparison is a decimal-versus-float trap). **Postgres will not let a newly added enum value be *used* in the same transaction that adds it**, and Alembic runs migrations in one — so if anything in this migration writes a row with the new value, it has to be split. Adding the value and the column alone is fine.
- [ ] **`rule_matches()`** gains the branch. Mirror the two beside it exactly, including the null handling: **a null threshold does not match, and a null cost on the engagement does not match.** That is the established answer (ADR 0042 §4) — an unfilled field must not trip every approval area, and the honest fix for missing data is to require the field, which COM-318 does on both request forms. Say so in a comment, as `min_sensitivity` does, so nobody later "fixes" it into matching everything.
- [ ] **`ProjectedEngagement` must carry the cost, and `_PROPOSABLE` must list it** — COM-318 covers both, and this task is the reason they matter. Without them an amendment that raises the spend is judged on the old number, which is the whole failure this rule exists to prevent.
- [ ] **Existing rows are unaffected**: every current rule has a null `min_annual_cost` and a kind that never reads it.

## Frontend — the rule builder

- [ ] `RULE_KIND_OPTIONS` in `vendors/ApprovalAreas.tsx` gains `{ value: 'min_annual_cost', label: 'Annual cost at or above…' }`.
- [ ] The threshold input, conditional on the kind, beside the existing criticality and sensitivity ones — and the same submit guard (`kind === 'min_annual_cost' && cost !== null`), so a rule cannot be saved with no threshold.
- [ ] `ruleLabel()` renders `Annual cost ≥ £50,000`, formatted through COM-318's single money helper rather than a second one.

## The interaction that makes this worth doing carefully

**This is the task that decides COM-319.** An owner who can edit the cost directly on the portal can drop it below a threshold and walk the engagement out from under an approver — COM-208's bug with a different column, and precisely why criticality moved onto the engagement in the first place. COM-319 has to be reconciled with this, not merely sequenced after it. The reconciliation is recorded there.

- [ ] Tests: a rule at £50,000 requires its area for an engagement at £50,000 (**at or above** — the boundary is the label's whole claim) and not at £49,999; a null cost matches nothing; a null threshold matches nothing; an **amendment raising the cost past a threshold pulls in the area it now needs**, judged on the projection rather than the stored value; lowering the cost does not retroactively remove an approval already given; a rule of this kind survives a round trip through the admin UI with its threshold intact.
