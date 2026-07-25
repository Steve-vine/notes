---
id: 01KYC4ZKP7XCHMH34KAFE33MP5
created: 2026-07-25T08:06:34.951034Z
updated: 2026-07-25T08:06:34.951034Z
type: task
title: Webhook sources managed in Settings
assignee: steve
priority: medium
task_status: backlog
label: feature
project: 01KX671DATY39VW6GWK3M2T3DN
number: 275
---
An admin can register and manage webhook sources in the app — the integration surface for ISE-274.

- Settings gains a **Webhook Sources** section (alongside the existing integration management): list of sources with name, enabled state, last-received time and event count.
- **Create source** modal (name, description) → shows the generated endpoint URL + token with a copy button and a ready-to-paste sample `curl` showing the ISE payload schema (this doubles as the sender documentation).
- **Rotate token** (old token stops working), **enable/disable** (disabled sources are rejected at the ingest endpoint), **delete**.
- Backend: session-authenticated CRUD under `/api/v1` (admin role), same pattern as the existing settings routers. Regenerate API types.

Acceptance: create a source in the UI, post an event with its curl, see last-received/count update; rotate the token and confirm the old one is rejected.