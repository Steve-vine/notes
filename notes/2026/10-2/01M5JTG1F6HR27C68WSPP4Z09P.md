---
id: 01M5JTG1F6HR27C68WSPP4Z09P
created: 2026-10-22T22:07:52.806856Z
updated: 2026-10-22T22:10:31.421575Z
type: task
title: The sensitivity scale gains Sensitive, between Internal and Confidential — and everything already classified keeps the level it has today
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1246
sprint: s5uw2fz
blocked_by:
- 01M5JTFQD2BJZX66XZ7CDYARXT
assignee: steve
label:
- feature
priority: high
task_status: todo
---
Sprint 84, DDQ-1 (ADR in COM-1245). Amends ADR 0042 §1.

**Chain:** on the chain — migration + API

## What people see

**Admin ▸ Rubrics ▸ Data sensitivity** lists five levels: Public, Internal, **Sensitive**, Confidential, Restricted. Sensitive's definition starts from the wording in COM-1245 call 4, and Steve edits it there.

Everything already classified stays where it is: a Confidential policy is still Confidential, a data type marked Restricted is still Restricted, and a vendor approval rule for "Confidential and above" still means Confidential and Restricted. Every picker that offers a sensitivity (content Classification, data types, approval rules, risk tiers, compliance rules) offers Sensitive in its place in the order.

One consequence, stated in the rubric's help text: a "Confidential and above" rule does not fire for something classified Sensitive.

## Notes (technical)

- Insert rank 2 and shift every stored rank ≥ 2 up by one, in one migration: data_sensitivity_levels (+ revisions), content_items.classification_rank, data types, approval_rule / assessment_rule / compliance_rule thresholds, vendor risk tier rules, and anything else that stores a rank (grep `SENSITIVITY_SCALE`, `classification_rank`, `min_sensitivity`). Update SENSITIVITY_SCALE.
- Rank is the natural key, so shift top-down (or via a temporary offset) to avoid unique clashes.
- Downgrade: map Sensitive back to Confidential.
- Migration test on a populated DB (the fresh-DB blind spot): seed every rank-bearing table at the old revision with raw SQL, upgrade, and assert that each one still names the same level.
- Frontend: any hard-coded "0–3" or four-level assumptions; house-style Classification still shows the right words.

**Done when:** a staging copy with existing classifications upgrades and every item shows the same level name as before; Sensitive can be chosen everywhere a level can.