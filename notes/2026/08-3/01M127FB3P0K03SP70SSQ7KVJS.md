---
id: 01M127FB3P0K03SP70SSQ7KVJS
created: 2026-08-27T18:24:48.758629Z
updated: 2026-08-27T18:25:19.207072Z
type: task
title: The vendor risk tier is a rubric of its own
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 472
sprint: sd9gmcq
assignee: steve
company: null
label:
- feature
priority: medium
task_status: backlog
---
ADR 0060 §2. New `vendor_risk_tiers` + `vendor_risk_tier_revisions`: `rank` 0–3, `value` low/medium/high/critical, `name`, `definition`. **Not** `risk_score_bands` — a tier is not a likelihood × impact score, and sharing the table would let someone retuning the register's bands silently re-tier every vendor.

Each row also carries its trigger thresholds, all nullable: `min_sensitivity_rank`, `min_access_rank`, `min_criticality`. Null = that dimension can never reach that tier on its own. Editable in Settings alongside the wording, the way `risk_score_bands` exposes `lower`/`upper`.

Seed per the ADR table. Note Restricted data alone reaches High, not Critical — Critical is reserved for "acts as us" and "we cannot operate without them".

Admin → Settings gets a **Vendor risk tiers** section: definitions plus the three thresholds.