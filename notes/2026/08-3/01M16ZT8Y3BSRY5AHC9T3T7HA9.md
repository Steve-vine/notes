---
id: 01M16ZT8Y3BSRY5AHC9T3T7HA9
created: 2026-08-29T14:47:10.531445Z
updated: 2026-08-29T17:26:45.178428Z
type: task
title: Split the risk scales into a Likelihood section and an Impact section
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 515
sprint: s2fcksg
assignee: steve
company: null
label:
- improvement
priority: low
task_status: active
---
On Admin ▸ Rubrics ▸ Risk rubric, one heading — *Likelihood & impact scales* — sits above what is really two different scales. Replace it with **two sections, "Likelihood" and "Impact"**, each with its own heading and its own table. The heading is what makes it read clearly; the separation follows from it.

## What's actually there

They are not two blocks today — they are **ten rows of one table**. `admin/RiskRubricSection.tsx`:

- `ScaleEditor` at `:55-84`; heading `<Title order={4}>Likelihood & impact scales</Title>` at `:59`; sub-copy at `:60-62`; one `<Table verticalSpacing="sm">` at `:66` filled by a flat `levels.map()` at `:77-79`.
- The only thing marking which scale a row belongs to is a per-row `<Badge>{level.dimension}</Badge>` in `ScaleRow` (`:125-129`).
- Likelihood sorts above impact because `GET /api/v1/risk-rubric/scale` orders by `(dimension, level)` (`api/v1/risk_rubric.py:51-58`) and the enum declares `likelihood, impact` (`models/risk_scale_level.py:23-25`).

## The change

The combined heading **goes**. `Likelihood` and `Impact` become **peer sections at `Title order={4}`**, the same level as `Severity bands` (`:195`) and `Risk appetite` (`:335`), so the Risk rubric card reads as four sections rather than three with a hidden pair inside one.

- Split `ScaleEditor` so it renders per dimension — one heading and one table each, filtered from the same `useRiskScaleLevels()` result. No new API call.
- They sit directly in the existing outer `<Stack gap="xl">` (`:35-42`), which then supplies the separation for free. No new spacing values needed.
- **Drop the per-row dimension badge** (`ScaleRow:125-129`) — it exists only to disambiguate rows that will no longer need disambiguating, and it's taking column width from the descriptors.

Prior art for a single-dimension scale table: `admin/MaturityRubricSection.tsx:14-35`.

## One copy decision

The sub-copy at `:60-62` — *"The 1–5 descriptors used to score each risk. Every change is kept in the history."* — currently covers both scales. Repeating it verbatim under each heading would read as duplication. Either give each section a line of its own saying what that scale measures (how likely / how bad), or keep one line under the first section only. A line each is probably better now that the headings are doing the naming.

## Verify
The Risk rubric card shows four sections — Likelihood, Impact, Severity bands, Risk appetite — each scale showing levels 1–5 with no dimension badge. Editing a level still saves and still appears in that level's history.
