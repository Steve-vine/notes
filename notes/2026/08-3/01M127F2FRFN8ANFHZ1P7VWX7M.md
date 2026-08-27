---
id: 01M127F2FRFN8ANFHZ1P7VWX7M
created: 2026-08-27T18:24:39.928101Z
updated: 2026-08-27T18:25:29.949645Z
type: task
title: How far in a vendor can reach is a rung on a ladder, not a sentence
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 470
sprint: sd9gmcq
blocked_by:
- 01M127EWZ226VXDEESHY7799T9
assignee: steve
company: null
label:
- feature
priority: medium
task_status: backlog
---
ADR 0060 §1. New `vendor_access_levels` — the `vendor_criticality_levels` shape exactly: `rank` 0–3 unique, `value` (enum, `StatusPill`), `name`, `definition`; organisation-wide, not company-scoped; fixed scale and fixed names, definition editable; every edit preserved as `vendor_access_level_revisions`.

Seed: 0 `none` "No access" · 1 `hosted` "Holds our data" · 2 `connected` "Reaches our systems" · 3 `privileged` "Acts as us". Definitions verbatim from the ADR table.

Also: `ACCESS_RANK` as the single source of severity order (the pattern `CRITICALITY_RANK` sets), the admin read/edit API, and an **Access rubric** section in Admin → Settings beside `CriticalityRubricSection` / `DataRubricSection`.

Migration note: reuse the enum with `postgresql.ENUM(create_type=False)` where it is referenced a second time.