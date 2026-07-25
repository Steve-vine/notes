---
id: 01KYC4ZVPE0Z3T1760RCHMFF8P
created: 2026-07-25T08:06:43.150331Z
updated: 2026-07-25T08:06:43.150331Z
type: task
title: 'Events screen: list and detail modal'
assignee: steve
priority: medium
task_status: backlog
label: feature
project: 01KX671DATY39VW6GWK3M2T3DN
number: 276
---
The user-facing pane of glass for received webhooks — a new top-level **Events** screen.

- New `NAV_ITEMS` entry **Events** (tabler icon, e.g. webhook/bolt) + `/events` route + page, per the ui-brief.
- **List** of received events, newest first: date/time, source, title, event type, outcome (badge — e.g. success green / failure red / neutral otherwise). Filters: source, event type, outcome, time window (mirroring the tick-list filter pattern); pagination.
- **Row click opens a detail modal**: all schema fields, the `detail` markdown rendered, and the raw payload pretty-printed JSON in a collapsible section.
- Backend: `api/v1/events_api.py` list/get endpoints (viewer role) with the filter params; careful naming vs the existing `audit_event` table/Audit screen. Regenerate API types.

Acceptance: post a release-style event via curl (ISE-274), see it appear in Events, open the modal, read the payload.