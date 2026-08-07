---
id: 01KYVS3FZ8P14WYE5Q8X21WE9Z
created: 2026-07-31T09:46:50.216849Z
updated: 2026-08-07T10:38:10.795853Z
type: task
title: M365 evidence + surface — on-demand queries, summary card, live smoke
project: 01KX671DATY39VW6GWK3M2T3DN
number: 402
order: 2.0
sprint: s10ybrs
blocked_by:
- 01KYVS2Y79HX5NJWFVRGJA6S1D
comments:
- id: 01KYW4H4P95Y57KNFC9MP2VZRY
  author: Steve Vine
  at: 2026-07-31T13:06:31.753223Z
  text: |-
    Built and in review — PR #374 (feature/ise-402-m365-surface, stacked on #373).

    - Evidence: service_health_issue (posts + post-incident report link where published), message_center (pull-only, optional service filter — deliberately not a signal source), license_detail (fullest pool first). Unknown queries refused; Graph failures degrade to ok=False.
    - Surface: hourly `licenses` sync slice; GET /systems/{id}/m365-summary (tenant id, services with per-service open-issue counts via ISE-401 entity attribution, licence bars from the latest slice, firing counts — no Graph call in the read path); M365TenantCard on System detail with utilisation bars and honest empty states. API types regenerated.
    - Tests: test_m365_evidence.py 9 passing (40 M365 backend tests total); frontend build/eslint/prettier clean, vitest 442 passing.

    LIVE SMOKE (Steve, after staging deploy): register the dedicated M365 read SP — ServiceHealth.Read.All + Organization.Read.All, application permissions, admin-consented (separate app registration from EntraID's read SP). Add the integration in Settings → verify services discovered, card populates, advisories land as signals, licence observations fire.
- id: 01KYW7H4FDY774J481B3XJ49JH
  author: Steve Vine
  at: 2026-07-31T13:58:57.260924Z
  text: 'RELEASED to main 2026-07-31: PRs #371→#374 merged in order (each retargeted via gh api + close/reopen to fire CI, all green — #374 ran the frontend suite too), main CI green at e4fec32, feature branches deleted, staging reset to main. Sprint s10ybrs complete.'
assignee: steve
label: null
priority: medium
task_status: done
---
**Evidence (3 on-demand queries):** `service_health_issue` — issue detail incl. post-incident report where published; `message_center` — recent Message Center announcements, filterable by service (GET /v1.0/admin/serviceAnnouncement/messages; pull-only v1 — deliberately NOT alerts or Events-screen push, promotion is a later candidate if wanted); `license_detail` — subscribedSkus breakdown.

**Surface (pane-of-glass slice):** `m365-summary` card on System detail — services with open-issue counts, license utilisation bars from the subscribedSkus sweep; the `third-party` service entities render free in estate views. Frontend consumes /api/v1 only; regen api-types (dump_openapi + npm run generate:api) — coordinate the combined-state regen if merged alongside EntraID branches (staging drift gotcha).

**Live smoke (Steve):** register the dedicated M365 read SP (ADR 0066 permission set: ServiceHealth.Read.All + Organization.Read.All, admin-consented), add the integration in Settings, verify: services discovered, card populated, any live service-health advisory lands as a signal, license observations fire against real SKU counts.