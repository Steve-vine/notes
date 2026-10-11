---
id: 01M4N538FJ0E21QXVV0VQGB7CK
created: 2026-10-11T09:35:55.378854Z
updated: 2026-10-11T11:16:26.121975Z
type: task
title: The nightly record keeps every level of a framework, and the days already recorded are rebuilt
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 907
sprint: s4gilxe
blocked_by:
- 01M4N5259GNVX9RR4ZZ24T6HFN
- 01M4N52WKP1BX5VY5NKZMCYQCE
comments:
- id: 01M4NAV6JMNT09B3W3K64F54S9
  author: Steve Vine
  at: 2026-10-11T11:16:22.740106Z
  text: |-
    Merged to main as PR #910 (2026-10-11). Goes to staging with the rest of the sprint. Nothing on screen changes with this task on its own; the level filter (COM-910) reads what it records.

    What is there
    - From tonight, each day's record holds every framework that has levels at each of its levels: how many requirements apply, how many are met, and the percentage.
    - Days already recorded get the same breakdown, worked out from the change history. Those figures are marked as reconstructed, level by level.
    - The figure at the company's own level is copied from what the day already recorded, not worked out again. The line people already see does not move.
    - Nothing else in an existing day is touched, whether it was measured or reconstructed.
    - The trend's read returns each framework's level and its figures at every level.

    What to expect on staging
    - The past is filled in by the deploy's seed job, after the frameworks and the crosswalk. It needs no command from anybody.
    - Every past point at a level other than the company's own will be marked reconstructed until tonight's record is taken. That is correct: those figures were not measured on the day.
    - HITRUST joined the library on 2026-10-10, so it has no earlier points at any level. CIS goes back as far as the record does.

    Decisions I took
    - The fill-in runs on every deploy rather than once by hand. A day that already has its levels is skipped, so once done it reads and writes nothing. That means production needs no manual step, and a framework that gains levels later is filled in on the deploy that brings them.
    - If the fill-in fails, the deploy still succeeds and says so in the job's log. A missing breakdown shortens a level's line; it is not worth a failed deploy.
    - A day recorded before a framework had levels counted everything, so its figures are filed under the framework's highest level.

    Not done
    - CI cannot run this against a populated database. I will check the job's log and the stored rows on staging after the deploy and add what I find here.

    Technical
    - No migration: the breakdown is a `levels` list inside each entry of posture_snapshots.frameworks, each with its own `source`.
    - core/posture.py measures every level and takes the headline from the chosen level's entry. posture_backfill.fill_levels is the fill-in; `fill-posture-levels` is the CLI; chart/templates/job-import.yaml runs it before the reports seed.
    - TimelineFramework gains `level` and `levels`.
assignee: steve
label:
- feature
priority: high
task_status: review
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