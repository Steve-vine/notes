---
id: 01M16ZT8Y3BSRY5AHC9T3T7HA9
created: 2026-08-29T14:47:10.531445Z
updated: 2026-08-29T17:40:32.257263Z
type: task
title: Split the risk scales into a Likelihood section and an Impact section
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 515
sprint: s2fcksg
comments:
- id: 01M179QHBNZAESX9ARAB41BT02
  author: Steve Vine
  at: 2026-08-29T17:40:26.613618Z
  text: |-
    Done — PR #519, merged to main as 70aae6a.

    Likelihood and Impact are peer sections at Title order={4} now, alongside Severity bands and Risk appetite — so the Risk rubric card reads as four sections rather than three with a hidden pair inside one. ScaleEditor takes a dimension and filters the same useRiskScaleLevels() result; the hook is cached, so the second section costs no extra request. The per-row dimension badge is gone, which gives its column width back to the descriptors.

    Copy decision: a line each rather than one line repeated. "The 1–5 descriptors used to score how likely a risk is" / "...how bad a risk would be". The headings do the naming now, so the sub-copy says what each scale measures. Both keep the "every change is kept in the history" note, so nothing is lost.

    Test note: the fixture only ever had a likelihood row, so an impact row was added — and two existing tests picked their Save button by index across the whole card, which the split would have made brittle. They now find the row's own Save through the field being edited. New tests cover the four headings, each level landing in its own table, the dimension column being gone, and an impact edit PATCHing /scale/impact/1 (both scales share one endpoint keyed by dimension, so the split has to keep each row pointed at the right one).

    COM-517 unblocked — it needs these two headings to exist before it can give them descriptions.

    Ready for smoke test on staging.
assignee: steve
company: null
label:
- improvement
priority: low
task_status: review
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
