---
id: 01M16ZSV0QE99PYNPBGER8B1DS
created: 2026-08-29T14:46:56.279724Z
updated: 2026-08-29T14:47:13.394045Z
type: task
title: Risk category dropdown is a hardcoded list and has drifted from the appetite categories
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 514
sprint: s2fcksg
assignee: steve
company: null
label:
- bug
priority: high
task_status: backlog
---
**Reported:** Risk appetite on Admin ▸ Rubrics lists an **AI** category, but AI isn't offered when raising a risk.

## Why

Two unrelated lists.

**Appetite categories** are rows in `risk_appetites`, read over `GET /api/v1/risk-rubric/appetite`. `ai` was seeded by COM-482 (`1cebb0a`, 2026-08-28) — `seed/risk_rubric.py:72-74`, at the default threshold. That commit was backend-only: seed, CLI, tests, import job. No frontend change.

**The raise-a-risk dropdown** is a hardcoded constant that never learned about it:

```ts
// pages/RisksPage.tsx:44-51
const CATEGORY_OPTIONS = [
  'default','security','regulatory','operational','financial','reputational',
].map((c) => ({ value: c, label: c }))
```

It is **byte-identical in two files** — `pages/RisksPage.tsx:44-51` (new-risk modal `Select`, `:253-258`) and `pages/RiskDetailPage.tsx:61-68` (edit form `Select`, `:299-305`). So AI can't be set on a new risk *or* an existing one.

**The backend is fine.** `RiskCreate.category` is `str` (`schemas.py:2889`), `create_risk` (`api/v1/risks.py:123-141`) does no category check, and `appetite_for()` resolves it against `risk_appetites`. `POST /api/v1/risks` with `category: "ai"` works today and is correctly scored against the AI tolerance. This is a UI gap only.

## Fix

The hook already exists and is already used by the admin screen: `useRiskAppetite()` in `risk/rubric.ts:26-32`. Derive the options from it in both places.

**Hoist the shared option list into `risk/rubric.ts`** rather than fixing the constant twice — two byte-identical copies drifting together is what caused this, and fixing them in place leaves the same trap for the next category.

Label handling: the values are lowercase slugs rendered raw today (`label: c`), so the dropdown reads "ai" rather than "AI". Since the list becomes data-driven, take the label from the appetite row and title-case it — "AI" needs an explicit case, not a naive capitalise.

## Two things worth settling while in here

**Category isn't validated anywhere.** `Risk.category` is free text (`models/risk.py:56-58`, `String(64)`, default `"default"`), with no FK to `risk_appetites`. `core/risk_scoring.py:31-40` falls back to the `default` appetite for any unrecognised value — silently. So a typo, or a category later removed from the seed, doesn't error; the risk is just judged against the wrong tolerance with nothing on screen to say so. Worth either validating on write or surfacing "no matching appetite — judged at default" on the risk.

**Admins can't create appetite categories.** `api/v1/risk_rubric.py:176-231` exposes only `GET`, `PATCH` and revisions — no POST, no DELETE. The admin screen (`RiskRubricSection.tsx:331-359`) edits `max_residual_score` and `statement` on existing rows only. New categories arrive by seed change and redeploy, which is exactly how AI appeared unannounced. Whether that taxonomy should be admin-owned is a separate product decision — noted here, not assumed.

## Verify
AI appears in the dropdown on both the new-risk modal and the risk detail edit form; a risk saved as AI is scored against the AI appetite; existing risks in categories with no appetite row still resolve to default without error.
