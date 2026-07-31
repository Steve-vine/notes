---
id: 01KYVS3FZ8P14WYE5Q8X21WE9Z
created: 2026-07-31T09:46:50.216849Z
updated: 2026-07-31T12:57:32.021411Z
type: task
title: M365 evidence + surface — on-demand queries, summary card, live smoke
project: 01KX671DATY39VW6GWK3M2T3DN
number: 402
order: 2.0
sprint: s10ybrs
blocked_by:
- 01KYVS2Y79HX5NJWFVRGJA6S1D
assignee: steve
label:
- feature
priority: medium
task_status: active
---
**Evidence (3 on-demand queries):** `service_health_issue` — issue detail incl. post-incident report where published; `message_center` — recent Message Center announcements, filterable by service (GET /v1.0/admin/serviceAnnouncement/messages; pull-only v1 — deliberately NOT alerts or Events-screen push, promotion is a later candidate if wanted); `license_detail` — subscribedSkus breakdown.

**Surface (pane-of-glass slice):** `m365-summary` card on System detail — services with open-issue counts, license utilisation bars from the subscribedSkus sweep; the `third-party` service entities render free in estate views. Frontend consumes /api/v1 only; regen api-types (dump_openapi + npm run generate:api) — coordinate the combined-state regen if merged alongside EntraID branches (staging drift gotcha).

**Live smoke (Steve):** register the dedicated M365 read SP (ADR 0066 permission set: ServiceHealth.Read.All + Organization.Read.All, admin-consented), add the integration in Settings, verify: services discovered, card populated, any live service-health advisory lands as a signal, license observations fire against real SKU counts.