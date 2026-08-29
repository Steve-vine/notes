---
id: 01M16ZT8Y3BSRY5AHC9T3T7HA9
created: 2026-08-29T14:47:10.531445Z
updated: 2026-08-29T14:47:15.930776Z
type: task
title: Separate likelihood from impact in the risk scales table
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 515
sprint: s2fcksg
assignee: steve
company: null
label:
- improvement
priority: low
task_status: backlog
---
On Admin ▸ Rubrics ▸ Risk rubric, the *Likelihood & impact scales* block runs the two scales together with nothing to separate them. Add a clear break between the likelihood rows and the impact rows.

## What's actually there

They are not two blocks — they are **ten rows of one table**. `admin/RiskRubricSection.tsx`:

- `ScaleEditor` at `:55-84`; heading `<Title order={4}>Likelihood & impact scales</Title>` at `:59`; one `<Table verticalSpacing="sm">` at `:66`, filled by a flat `levels.map()` at `:77-79`.
- The only thing marking which scale a row belongs to is a per-row `<Badge>{level.dimension}</Badge>` in `ScaleRow` (`:125-129`).
- Likelihood happens to sort above impact because `GET /api/v1/risk-rubric/scale` orders by `(dimension, level)` (`api/v1/risk_rubric.py:51-58`) and the enum declares `likelihood, impact` (`models/risk_scale_level.py:23-25`).

So rows 5 and 6 — the boundary between the two scales — are separated by exactly the same `verticalSpacing="sm"` as every other row. There is no gap to widen; one needs introducing.

## Preferred shape

Split into **two tables, one per dimension**, each with its own `<Title order={5}>` (*Likelihood* / *Impact*), inside a `<Stack gap="lg">`. That gives real separation, names each scale, and lets the per-row dimension badge go — it's only there to disambiguate rows that would no longer need disambiguating.

Prior art for a single-dimension scale table: `admin/MaturityRubricSection.tsx:14-35`.

If two tables prove awkward, the fallback is a `<Table.Tbody>` per dimension with a spanning group-header row — less clean, keeps one table.

Note the outer `<Stack gap="xl">` at `:35-42` already separates *Scales*, *Severity bands* and *Risk appetite*, so whatever gap is chosen inside `ScaleEditor` should sit below `xl` or the three top-level sections stop reading as the coarser grouping.

## Verify
Likelihood 1–5 and Impact 1–5 read as two labelled scales; editing a level still saves; the section still sits correctly against Severity bands and Risk appetite around it.
