---
id: 01M127FB3P0K03SP70SSQ7KVJS
created: 2026-08-27T18:24:48.758629Z
updated: 2026-09-01T13:55:52.084643Z
type: task
title: The vendor risk tier is a rubric of its own
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 472
sprint: sd9gmcq
blocked_by:
- 01M127F2FRFN8ANFHZ1P7VWX7M
comments:
- id: 01M159F0VD1P5RR0MC43JDB6ES
  author: Steve Vine
  at: 2026-08-28T22:57:18.701369Z
  text: |-
    Done — PR #487, merged to main 2026-08-28.

    What landed:

    - `vendor_risk_tiers` + `vendor_risk_tier_revisions`: fixed rank 0–3, fixed names, editable definitions, every edit preserved. The contract the criticality, sensitivity and access rubrics already share.
    - **Not `risk_score_bands`**, as the task asked. A tier is the worst of three ordinal facts, none of which is a likelihood; sharing that table would let someone retuning the risk register's Medium/High boundary silently re-tier the whole vendor estate.
    - **Its own enum too** — `vendor_risk_tier` spells the same four words as `vendor_criticality`, which is a coincidence of English rather than a shared vocabulary. A column typed as the wrong one would read fine, mean something else, and nothing downstream would ever complain.
    - The three thresholds per tier, all nullable, seeded exactly per the ADR table. **Null is the meaningful setting** — it says this dimension can never reach this tier on its own, which is what keeps Restricted data at High while "acts as us" reaches Critical. That has its own test.
    - Thresholds editable in Settings alongside the wording, because "Legal looks at anything that can act as us" is a policy rather than a constant. The control offers **Never** explicitly: a threshold nobody can clear is a policy nobody can express.
    - Revisions snapshot the **thresholds as well as the prose**. Explaining why a past engagement was tiered as it was — and so why an approval was required — means reading the thresholds in force at the time.
    - Admin → Rubrics gains a *Vendor risk tiers* card, last, after the three scales it reads from.

    Tests: `tests/test_vendor_risk_tiers.py` (14) including Restricted-stops-at-High as its own assertion, clearing a threshold as a real edit, a no-op edit writing no revision, and the two-tables/two-enums separation. Frontend `RiskTierRubricSection.test.tsx` (5).

    Note: CI's `deps-scan` flaked repeatedly on this branch — npm's audit endpoint returned "Bad Request" — not a real finding. `npm audit --omit=dev --audit-level=high` (CI's exact command) reports 0 vulnerabilities locally. Cleared on a rerun.
assignee: steve
label:
- feature
priority: medium
task_status: done
---
ADR 0060 §2. New `vendor_risk_tiers` + `vendor_risk_tier_revisions`: `rank` 0–3, `value` low/medium/high/critical, `name`, `definition`. **Not** `risk_score_bands` — a tier is not a likelihood × impact score, and sharing the table would let someone retuning the register's bands silently re-tier every vendor.

Each row also carries its trigger thresholds, all nullable: `min_sensitivity_rank`, `min_access_rank`, `min_criticality`. Null = that dimension can never reach that tier on its own. Editable in Settings alongside the wording, the way `risk_score_bands` exposes `lower`/`upper`.

Seed per the ADR table. Note Restricted data alone reaches High, not Critical — Critical is reserved for "acts as us" and "we cannot operate without them".

Admin → Settings gets a **Vendor risk tiers** section: definitions plus the three thresholds.