---
id: 01M23RH9QVN7FPV7K03WVV6V69
created: 2026-09-09T18:57:54.939136Z
updated: 2026-09-10T08:57:47.895538Z
type: task
title: The timeline read API — series over a range, at a chosen grain, with the events that explain them
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 638
sprint: srtvjyn
blocked_by:
- 01M23RGHGFYCEGX43F5JPJHDE4
comments:
- id: 01M23Z98Y1PWNY4RQVZ1TE8CAZ
  author: Steve Vine
  at: 2026-09-09T20:55:52.001588Z
  text: |-
    Done — PR #647 merged to main, full suite green (one sast rerun for a runner out-of-memory flake).

    GET /api/v1/posture-timeline?company=&from=&to=&grain=day|week|month, gated require_posture_view like the Dashboard, tagged with it in OpenAPI. One point per bucket that has a snapshot — the last row in the bucket (week ending, month end), never an average — carrying the whole measure (headline, tiers, per-domain, per-framework with held, gaps open/overdue, risks total/bands/over appetite) plus source. Buckets nothing measured are absent, never interpolated. Defaults: to = today, from = 12 months back, grain month, or week when the range is 90 days or less.

    Events, derived at read time, in date order, clipped to the range: framework_adopted, framework_superseded (only for a version the company holds; dated by the newer version's effective date, else the day it entered the library), maturity_rubric_changed and risk_appetite_changed (one per day, seed revisions excluded), first_observed (only where a reconstructed past precedes it). Unknown company 404s; an unknown grain or from after to 422s. schema.d.ts regenerated.

    Tests on real Postgres: last-row-per-bucket at each grain with an empty week absent, a point's shape and source, the defaults and the 90-day grain switch, the five event kinds in order and clipped, 404/422/401.
assignee: steve
label:
- feature
priority: high
task_status: done
---
One read, gated `require_posture_view`, that the Timeline page draws from: `GET /api/v1/posture-timeline?company=&from=&to=&grain=day|week|month`.

- **Series**: one point per grain bucket, each carrying the six measures — headline compliance, tiers, avg maturity (and per-domain), per-framework percent, gaps (open, overdue), risks (total, bands, over appetite) — plus `source` so the page can shade reconstructed days. A bucket is the **last** snapshot in it (week ending, month end): "where we stood at the end of March", not an average nobody stood at. Buckets with no row are absent, not interpolated (the `membership_coverage_snapshots` rule: don't draw a line over a period nothing measured).
- **Defaults**: `to` = today, `from` = 12 months back, `grain` = month over 12 months, week for anything ≤ 90 days. The page can override; the API just needs sane defaults.
- **Events** (annotations, read-only, derived — the ADR 0070 list): framework adopted by the company, framework version superseded, maturity rubric edited (`maturity_level_revisions`), risk appetite changed (`risk_appetite_revisions`), and the first observed day (the reconstructed→observed boundary). Each is `{on, kind, label}`; labels are sentences a person reads ("ISO 27001 adopted", "Maturity rubric changed"). Authored notes are a later task and will join the same list.
- **Company 404s** like every other posture read; an unknown grain 422s.
- `posture_view` permission, `tags=["dashboard"]` alongside the Dashboard in OpenAPI. Regenerate `schema.d.ts` (the drift script — the PR suite does not).

Not in this task: any change to what the snapshot stores, and CSV export of the series (worth a follow-up if the board wants the numbers).