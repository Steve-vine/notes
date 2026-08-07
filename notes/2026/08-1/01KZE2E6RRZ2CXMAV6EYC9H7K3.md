---
id: 01KZE2E6RRZ2CXMAV6EYC9H7K3
created: 2026-08-07T12:16:18.200298Z
updated: 2026-08-07T13:11:38.197379Z
type: task
title: 'Wallboard rotation: one TV cycling boards'
project: 01KX671DATY39VW6GWK3M2T3DN
number: 610
sprint: srhh7w7
blocked_by:
- 01KZE2E0R6J5S3214F0G80ACCJ
assignee: steve
label:
- feature
priority: medium
task_status: review
---
One token can cycle several boards on a single TV: new `dashboard_board_token_board` join (per-entry `display_order`; existing FK rows become single-entry joins) + `rotation_seconds` on the token (NULL = static). Public grid gains a rotation manifest; WallboardPage cycles per-board fetches with per-board stale indicator, drill-in pauses rotation. Mint UI: multi-board select + dwell seconds. Stacks on ISE-609; migration must rebase-stack on ISE-608's; OpenAPI regen in-branch.

Acceptance: an operator can mint one URL that cycles the Prod and Infra boards on a single TV at a chosen dwell time; a single-board token behaves exactly as before.