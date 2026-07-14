---
id: 01KXGSNCSWQESAKD8532THRWZF
created: 2026-07-14T17:09:16.220860293Z
updated: 2026-07-14T18:33:01.475105993Z
type: task
title: Components & tables refresh
task_status: done
label:
- brief
priority: medium
assignee: steve
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 54
sprint: s9nk96f
blocked_by:
- 01KXGSM2NNE1H46XS5NAP87QDD
---
Visual consistency + vibrant look across the building blocks, on the M7 theme. (Deploy to view.)

**Agreed approach (planned 2026-06-18).**

- [ ] **Tables + cards globally via** `theme.ts` `components`: `Table.defaultProps` (highlightOnHover, striped, stickyHeader, verticalSpacing 'sm') and `Card`/`Paper.defaultProps` (withBorder, radius md, subtle shadow) — consistent everywhere without per-page edits; spot-fix redundant props.
- [ ] **Shared** `StatusPill` (`src/components/StatusPill.tsx`): status/band → theme colour + label, covering assessment / gap / risk status + residual band / decision / content status + source / treatment. Replace scattered inline `Badge`s (Content, Decisions, Gaps, Risks, AssessmentPanel, LinkedDecisions); fold in `decisions/status.ts` `statusColor`. Labels unchanged.
- [ ] **Dashboard vibrant pass**: accent/gradient headline + coloured stat cards (compliance ring, maturity, open gaps), `StatusPill` usage, on the new card surface.
- [ ] Tests: `StatusPill` unit test; keep page tests green; light Dashboard assertion.

Refs: ADR 0022 (design), 0017, 0003. Depends on: <issue id="b5ce177b-1a3d-4b63-a107-7def7eaef133" href="https://linear.app/stevevine/issue/DEV-469/theme-foundation-lightdark-toggle">DEV-469</issue> (done).

---
*Migrated from Linear [DEV-471](https://linear.app/stevevine/issue/DEV-471/components-and-tables-refresh) · created 2026-06-18 · completed 2026-06-18*  
*Related to (Linear): DEV-473, DEV-472*