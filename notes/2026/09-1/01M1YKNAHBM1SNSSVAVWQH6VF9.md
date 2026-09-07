---
id: 01M1YKNAHBM1SNSSVAVWQH6VF9
created: 2026-09-07T18:56:31.787553Z
updated: 2026-09-07T19:38:29.857059Z
type: task
title: Source the CIS Implementation Group tags into the framework data
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 603
sprint: sqc2gdq
assignee: steve
label:
- chore
priority: high
task_status: active
---
The tiering rule leans on CIS Implementation Group 1 as one of its two "this is the floor" signals, but **we don't hold the IG tags**. Without them the rule can't be computed.

`app/backend/src/compass_api/data/frameworks/cis-controls-v8-1.csv` carries `ref, title, description, security_function, asset_class` — no implementation group. Same for the v8 file. CIS publishes IG1/IG2/IG3 per safeguard; it is part of the framework, not something we should infer.

**What this needs**

- Add an `implementation_group` column to the CIS framework CSVs, sourced from CIS (v8.1 has 153 safeguards: IG1 56, IG2 +74, IG3 +23). v8 needs the same treatment or an explicit decision to tier only from v8.1.
- Carry it through the framework requirement import and expose it on the requirement, so it can be read by whatever computes the tier and shown on the CIS framework screen.
- Then re-run the tiering analysis for real. The counts quoted in the sprint description (157 / 101 / 125) were produced with the published IG1 list applied by hand as a test, not from our data — they will shift.

**Why it's first**

Everything else in the sprint is downstream of it: the rule can't be validated, the boundary can't be reviewed, and the split can't be seeded until the IG data is in the repo.

Coverage note: the CIS mapping reaches 186 of the 383 Core controls, so IG alone never tiers the other ~200 — that's why the rule pairs it with Cyber Essentials and framework breadth.