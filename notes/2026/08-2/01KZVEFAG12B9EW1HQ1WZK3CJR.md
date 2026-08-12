---
id: 01KZVEFAG12B9EW1HQ1WZK3CJR
created: 2026-08-12T16:56:45.31355Z
updated: 2026-08-12T16:57:43.352889Z
type: task
title: 'Workflow composer: warn when a step''s acceptsAssetKinds don''t intersect upstream produced kinds (guaranteed-0 chain)'
project: 01KZV767QMFTN9CZ3TPGTSAASD
number: 238
sprint: sewyev2
assignee: steve
imported_from: linear
label:
- follow_up
priority: medium
task_status: done
---
## Context

Surfaced during M9 testing. A `Cloudflare → Vulnerability Scanner` workflow returned 0 assets/findings because nuclei's `acceptsAssetKinds: [url]` shares nothing with what Cloudflare produces (`subdomain`). The dispatcher routes chain inputs purely on declared kinds, so the vuln-scanner step received `input_count: 0` and no-op'd — **silently**, with a `succeeded` status. The correct chain needs a bridge (`web-probe`: subdomain→url) b…

---

*Excerpt — full description in Linear.*

Imported from Linear [DEV-442](https://linear.app/stevevine/issue/DEV-442/workflow-composer-warn-when-a-steps-acceptsassetkinds-dont-intersect)