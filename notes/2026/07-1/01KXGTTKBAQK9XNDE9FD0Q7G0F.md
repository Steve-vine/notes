---
id: 01KXGTTKBAQK9XNDE9FD0Q7G0F
created: 2026-07-14T17:29:35.338989079Z
updated: 2026-07-14T17:29:46.111836384Z
type: task
title: Add a new Content tab in Setting
label:
- feature
task_status: done
priority: medium
assignee: steve
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 99
sprint: sg31rps
comments:
- id: 01KXGTTXVZR9QG0QR8E8G0THVA
  author: Steve Vine
  at: 2026-07-14T17:29:46.111743189Z
  text: |-
    [Migrated from Linear — Steve Vine, 2026-06-29 20:35 UTC]
    PR open: https://github.com/Steve-vine/compass/pull/102

    First brief of M22. Adds a nullable `review_cadence_months` to `content_types`, edited on a new **Admin → "Content reviews"** tab (mirrors `RiskRubricSection`). Foundation for DEV-717 (review records) and DEV-716 (publish-modal wiring) — when set, those flows schedule `next_review_at` N months out, which the existing M5 reminder scan already consumes (no Beat change).

    Design recorded in **ADR 0032** (covers the whole milestone: cadence, the append-only `content_reviews` entity, `User.job_title`, publish/review stamping). Migration `0026` (append-only, nullable column).

    Green: ruff + ruff format + mypy src · backend cadence round-trip test (testcontainers) · tsc + eslint · full frontend suite 123/123 · migration verified up/down.
---
In the Content tab add a section for reviews.  For each content type set a cadence for reviews - a number of months before a review is required.  E.g.
Type                      Review Period
Policies                 [ 12 ] months

---
*Migrated from Linear [DEV-715](https://linear.app/stevevine/issue/DEV-715/add-a-new-content-tab-in-setting) · created 2026-06-29 · completed 2026-06-29*  
*Related to (Linear): DEV-716, DEV-717*