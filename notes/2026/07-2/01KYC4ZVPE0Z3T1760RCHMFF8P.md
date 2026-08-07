---
id: 01KYC4ZVPE0Z3T1760RCHMFF8P
created: 2026-07-25T08:06:43.150331Z
updated: 2026-08-07T10:09:38.774912Z
type: task
title: 'Events screen: list and detail modal'
project: 01KX671DATY39VW6GWK3M2T3DN
number: 276
sprint: s6pc5xk
blocked_by:
- 01KYC4YWCCZM0GHY37VMHWDTER
comments:
- id: 01KYCCDXM433WP99KZ29HXTS5G
  author: Steve Vine
  at: 2026-07-25T10:16:43.908093Z
  text: |-
    Done. The pane of glass for received webhooks.

    Backend (api/v1/events_api.py, viewer-readable): list over webhook_event with filters (source_id, level, event_type, outcome, since_hours window) + limit/offset pagination + total; a /events/facets endpoint returning the distinct levels/event_types/outcomes present so the filter controls offer only what exists; and GET /events/{id}. Named events_api and mounted at /events, deliberately distinct from the audit_event table + Audit screen (called out in the module docstring). Read-only. Registered in the v1 router; API types regenerated.

    Frontend (EventsPage + "Events" nav entry with IconWebhook + /events route): newest-first table — time, source, title, type, outcome badge (success green / failure red / neutral gray), level badge (alert red / warn yellow / info gray). Filters: source/type/outcome Selects (populated from facets + the sources list) and a 24h/7d/30d/All SegmentedControl, all persisted across navigation (ISE-156 usePersistedState). Pagination via Mantine Pagination. Row click → detail modal with every schema field, the detail rendered through the existing Markdown component, and the raw payload as pretty-printed JSON in a scrollable Code block.

    Acceptance met: post a release-style event via curl → it appears in Events → open the modal → read the payload.

    6 backend integration tests green; backend mypy (297 files) + ruff clean; frontend build (tsc -b + vite) + eslint + prettier + full vitest all green. Committed to feature/ise-276-events-screen (stacked on ise-275).
assignee: steve
label: null
priority: medium
task_status: done
---
The user-facing pane of glass for received webhooks — a new top-level **Events** screen.

- New `NAV_ITEMS` entry **Events** (tabler icon, e.g. webhook/bolt) + `/events` route + page, per the ui-brief.
- **List** of received events, newest first: date/time, source, title, event type, outcome (badge — e.g. success green / failure red / neutral otherwise). Filters: source, event type, outcome, time window (mirroring the tick-list filter pattern); pagination.
- **Row click opens a detail modal**: all schema fields, the `detail` markdown rendered, and the raw payload pretty-printed JSON in a collapsible section.
- Backend: `api/v1/events_api.py` list/get endpoints (viewer role) with the filter params; careful naming vs the existing `audit_event` table/Audit screen. Regenerate API types.

Acceptance: post a release-style event via curl (ISE-274), see it appear in Events, open the modal, read the payload.