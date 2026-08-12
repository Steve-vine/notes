---
id: 01KZVESMC33FV1KMMDQCDBP1YJ
created: 2026-08-12T17:02:23.10747Z
updated: 2026-08-12T17:05:04.875145Z
type: task
title: TLS and Certificate Analysis - Findings detail doesn't include the finding
project: 01KZV767QMFTN9CZ3TPGTSAASD
number: 265
sprint: sewyev2
assignee: steve
imported_from: linear
label: null
priority: null
task_status: done
---
## Problem

The TLS finding **detail** page shows the issue (title, e.g. "Expired certificate") and the description, but not *what it's about*: the "Asset" field renders a truncated `asset_id` UUID, the finding's `meta` (which holds `matched_at` = the endpoint) isn't rendered, and the cert details (issuer, `not_after`, fingerprint, expired flag) — which live on the **asset's** `meta` — aren't surfaced. So a triager sees "Expired certificate" wit…

---

*Excerpt — full description in Linear.*

Imported from Linear [DEV-378](https://linear.app/stevevine/issue/DEV-378/tls-and-certificate-analysis-findings-detail-doesnt-include-the)