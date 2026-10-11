---
id: 01M4N538FJ0E21QXVV0VQGB7CK
created: 2026-10-11T09:35:55.378854Z
updated: 2026-10-11T09:56:06.623143Z
type: task
title: The nightly record keeps every level of a framework, and the days already recorded are rebuilt
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 907
sprint: s4gilxe
blocked_by:
- 01M4N5259GNVX9RR4ZZ24T6HFN
- 01M4N52WKP1BX5VY5NKZMCYQCE
assignee: steve
label:
- feature
priority: high
task_status: active
---
Part of sprint 68, Compliance (ADR in COM-904). The trend can only draw what was recorded. Today each night records a framework at the level the company was working towards and no other, so "HITRUST at e1" has no past for a company aiming at r2. Nothing on screen changes in this task; the level filter on the Compliance page depends on it.

## What changes

- **Each night records every level** of every framework that has levels: how many requirements apply at that level, how many are met, and the percentage.
- **The days already recorded get the same figures,** rebuilt from the change history. They are marked as rebuilt, so the page can shade them as it shades the reconstructed past today.
- **The figure at the company's own level is untouched.** The line people already see does not move.
- **The trend's read returns the per-level figures** with each point.

## Notes (technical)

- **Shape as decided in COM-904.** Recommended: a `levels` list inside each framework entry of `posture_snapshots.frameworks` (JSONB, so no migration for the column), each with level name, applicable, met, excluded, percent, and whether it was observed or rebuilt.
- **Measure.** `core/posture._framework_measures` calls `derive_framework` once at the effective level; call it per level for frameworks with levels. `FrameworkMeasure` gains the list; `from_dict` must read snapshots that have none.
- **Rebuild.** `posture_backfill.py` writes only days with no row and never touches an observed one. This needs a second, narrower pass that adds the per-level breakdown to existing rows without altering anything else in them, labelled per ADR 0070 §3. Idempotent; a CLI command like the existing backfill; run once per environment after deploy. It replays through today's mappings, exclusions and level tags, the known inaccuracy the backfill already documents.
- **Order.** Run the rebuild after the CIS levels task is on the environment, or CIS gets no past. The nightly task needs no ordering.
- **API.** `TimelineFramework` gains `levels`; regenerate `schema.d.ts` (the drift check is on main, not the PR).
- **Tests.** `compute` with a levelled framework; the rebuild leaves observed scalars byte-identical and is a no-op the second time; a snapshot without `levels` still reads. Migration-style tests on evolving tables use raw SQL, not the models.
- CI never runs this against a populated database: reproduce on a copy of staging data before deploying.

**Done when:** on staging, the trend's read returns e1, i1 and r2 figures for HITRUST on every point, earlier points are marked rebuilt, and the existing HITRUST line is unchanged.