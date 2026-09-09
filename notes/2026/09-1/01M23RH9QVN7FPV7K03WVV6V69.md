---
id: 01M23RH9QVN7FPV7K03WVV6V69
created: 2026-09-09T18:57:54.939136Z
updated: 2026-09-09T19:37:12.673772Z
type: task
title: The timeline read API — series over a range, at a chosen grain, with the events that explain them
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 638
sprint: srtvjyn
blocked_by:
- 01M23RGHGFYCEGX43F5JPJHDE4
assignee: steve
label:
- feature
priority: high
task_status: active
---
One read, gated `require_posture_view`, that the Timeline page draws from: `GET /api/v1/posture-timeline?company=&from=&to=&grain=day|week|month`.

- **Series**: one point per grain bucket, each carrying the six measures — headline compliance, tiers, avg maturity (and per-domain), per-framework percent, gaps (open, overdue), risks (total, bands, over appetite) — plus `source` so the page can shade reconstructed days. A bucket is the **last** snapshot in it (week ending, month end): "where we stood at the end of March", not an average nobody stood at. Buckets with no row are absent, not interpolated (the `membership_coverage_snapshots` rule: don't draw a line over a period nothing measured).
- **Defaults**: `to` = today, `from` = 12 months back, `grain` = month over 12 months, week for anything ≤ 90 days. The page can override; the API just needs sane defaults.
- **Events** (annotations, read-only, derived — the ADR 0070 list): framework adopted by the company, framework version superseded, maturity rubric edited (`maturity_level_revisions`), risk appetite changed (`risk_appetite_revisions`), and the first observed day (the reconstructed→observed boundary). Each is `{on, kind, label}`; labels are sentences a person reads ("ISO 27001 adopted", "Maturity rubric changed"). Authored notes are a later task and will join the same list.
- **Company 404s** like every other posture read; an unknown grain 422s.
- `posture_view` permission, `tags=["dashboard"]` alongside the Dashboard in OpenAPI. Regenerate `schema.d.ts` (the drift script — the PR suite does not).

Not in this task: any change to what the snapshot stores, and CSV export of the series (worth a follow-up if the board wants the numbers).