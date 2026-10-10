---
id: 01M4EDX9CF152R4DRRD0G2QQGE
created: 2026-10-08T18:55:15.855835Z
updated: 2026-10-10T17:42:13.85764Z
type: task
title: A company picks the HITRUST level it is working towards — e1, i1 or r2 — and its coverage, gaps and dashboard figure follow it
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 878
sprint: sfkkkex
blocked_by:
- 01M4EDWB7JZG4NSWXHHX7X6V34
assignee: steve
label:
- feature
priority: high
task_status: active
---
Part of sprint 66, HITRUST Framework (ADR in COM-875; the library is COM-876). Until this lands, HITRUST is measured as r2: everything.

## What people see

- **The HITRUST page has a "Working towards" choice:** e1, i1 or r2. It is the company's own; two companies can choose differently.
- **Until someone chooses, it is r2.**
- **The same people who can write a framework's scope statement can set it.** Everyone else sees which level is chosen.
- **Once a level is chosen, the figures are for that level.**
  - The headline names it, for example "i1".
  - Only controls at that level and below are counted.
  - Controls above the level stay in the list, marked as above the chosen level. They are not gaps, and they are not counted as excluded.
- **The Dashboard's compliance by framework uses the chosen level** and names it.
- **Reports and exports against HITRUST state the level** they were measured at.
- **Changing the level is in the audit trail.**
- **Out of scope is unaffected.** A control ruled out of scope stays ruled out whichever level is chosen.
- **Nothing changes for frameworks without levels,** and CIS is unchanged.

## Notes (technical)

- **Storage.** `company_frameworks.target_level` (small integer, nullable; null = the framework's highest level). The migration stacks on COM-876's, so this branch stacks on that one.
- **API.** Extend the per-company framework endpoints beside `GET` / `PUT /frameworks/{slug}/scope` in `api/v1/frameworks.py`.
  - Same permission as the scope statement (`require_posture_soa`), same 409 for a superseded version.
  - Reject a level the framework does not define, and any level on a framework with none.
- **Derivation.** `core/coverage.derive_framework` takes the target level.
  - A requirement whose level is above it is not counted: a new `above_level` tally, kept apart from `excluded`, overall and per part.
  - The per-requirement row carries a flag so the page can mark it.
- **Every caller of `derive_framework` passes the level:** the coverage endpoint, `core/posture.py` (`_framework_measures`; the company state loads target levels alongside the held frameworks), `posture_backfill.py`, the SoA and the reports catalogue. Grep before assuming the list is complete.
- **Posture over time.** The daily snapshot's framework measure records the level it was taken at, so a jump in the series is explicable. Check whether posture annotations can carry a system-written entry; if they can, a level change writes one, and if not, say so in the PR and leave the audit trail as the record.
- **Audit.** Confirm `company_frameworks` is in the ADR 0023 audit set; add it if not.
- **Page.** The picker sits in the HITRUST page header area beside the scope statement; a segmented choice, not a truncating pill. Rows above the level are dimmed and labelled.
- **Tests.** `derive_framework` with levels (counted, above level, excluded kept apart); the endpoint's permission, validation and 409; a page test for the picker and the marked rows.
- Regenerate `schema.d.ts`.

**Done when:** on staging, choosing i1 for a company changes HITRUST's headline, gap list and Dashboard figure to count only e1 and i1 controls, another company is unaffected, and the change appears in the audit trail.