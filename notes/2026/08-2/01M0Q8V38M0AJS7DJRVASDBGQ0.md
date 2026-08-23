---
id: 01M0Q8V38M0AJS7DJRVASDBGQ0
created: 2026-08-23T12:17:03.764441Z
updated: 2026-08-23T12:17:03.764441Z
type: task
title: The Validation tab says who made the change — user and app actors rendered distinctly
label: feature
priority: medium
assignee: steve
task_status: todo
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 391
---
Surface COM-390's actor on each unrequested-change item (`ValidationPage.tsx`) — validation stops being "someone did this" and becomes "Jane did this at 14:02", which is the actual basis for validate-or-reverse.

- [ ] Item card + detail: **"Changed by {actor} · {performed_at}"**. A user actor shows display name + UPN, linking to the View Users modal when the account is in the mirror.
- [ ] An **app actor** renders distinctly (a "service" badge, no UPN pretence) — "Directory Synchronization Accounts" tells the validator the change came from on-prem AD, not a rogue admin; that reading must be effortless.
- [ ] The two null states stay apart, per the backend's degraded reason: **"actor not yet available"** (enrichment pending — audit ingestion lags) vs **"actor unavailable — {reason}"** (grant missing, retention passed, no match). Never silently blank.
- [ ] Schema additions ride the existing items endpoint (additive; `schema.d.ts` regen).

Refs: COM-390 (the data), COM-255 (user-modal linking pattern), ADR 0045 §7.