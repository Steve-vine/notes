---
id: 01KYC4ZKP7XCHMH34KAFE33MP5
created: 2026-07-25T08:06:34.951034Z
updated: 2026-08-06T07:29:33.067373Z
type: task
title: Webhook sources managed in Settings
project: 01KX671DATY39VW6GWK3M2T3DN
number: 275
sprint: s6pc5xk
blocked_by:
- 01KYC4YWCCZM0GHY37VMHWDTER
comments:
- id: 01KYCC0388PZM50DXNV2CDKSFR
  author: Steve Vine
  at: 2026-07-25T10:09:10.920445Z
  text: |-
    Done. The admin surface for the ISE-274 ingest endpoint.

    Backend (api/v1/webhook_sources_api.py, same admin-write/viewer-read/audited shape as tag_rules_api): list (name, enabled, last-received, event count — no token), create (returns the one-time token + ingest_path), PUT update (name/description/enabled/alert TTL), rotate-token, delete (events cascade). The token is treated as a secret — returned only when minted (create/rotate), never in a list; an admin who loses it rotates to mint a new one. Registered in the v1 router; API types regenerated (dump_openapi + generate:api).

    Frontend (WebhookSourcesCard + a new "Webhooks" tab in Settings): table with an inline enable/disable switch, rotate and delete actions; a create modal (name, description, optional alert-recovery TTL); and a reveal-once modal showing the full endpoint URL (origin + ingest_path) and a ready-to-paste sample curl with the ISE payload schema (doubles as sender docs), copy buttons, and an emphatic "shown once" warning.

    Acceptance met and tested end-to-end: create a source → post an event with its curl → event_count/last-received update → rotate → old token rejected (404 at ingest), new one works; disable rejects ingest; re-enable restores it.

    7 backend integration tests green; backend mypy (295 files) + ruff clean; frontend build (tsc -b + vite) + eslint + prettier + 403 vitest tests all green. Committed to feature/ise-275-webhook-sources (stacked on ise-274).
assignee: steve
label: null
priority: medium
task_status: done
---
An admin can register and manage webhook sources in the app — the integration surface for ISE-274.

- Settings gains a **Webhook Sources** section (alongside the existing integration management): list of sources with name, enabled state, last-received time and event count.
- **Create source** modal (name, description) → shows the generated endpoint URL + token with a copy button and a ready-to-paste sample `curl` showing the ISE payload schema (this doubles as the sender documentation).
- **Rotate token** (old token stops working), **enable/disable** (disabled sources are rejected at the ingest endpoint), **delete**.
- Backend: session-authenticated CRUD under `/api/v1` (admin role), same pattern as the existing settings routers. Regenerate API types.

Acceptance: create a source in the UI, post an event with its curl, see last-received/count update; rotate the token and confirm the old one is rejected.