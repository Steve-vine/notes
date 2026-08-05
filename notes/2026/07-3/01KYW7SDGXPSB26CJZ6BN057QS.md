---
id: 01KYW7SDGXPSB26CJZ6BN057QS
created: 2026-07-31T14:03:28.669508Z
updated: 2026-08-05T12:03:05.388391Z
type: task
title: Settings → Notifications tab + live Teams smoke
project: 01KX671DATY39VW6GWK3M2T3DN
number: 422
order: 2.0
sprint: s7qg63g
blocked_by:
- 01KYW7S336M90G37F936T5B612
label: null
task_status: done
---
The pane-of-glass slice + acceptance.

- New Notifications tab in `SettingsPage.tsx` (canManage-gated): channels card in the WebhookSourcesCard shape — CRUD, write-only URL entry, min-severity select, per-event toggles, per-channel Test send button.
- Recent-deliveries list (status, event, channel, error) so failed deliveries are visible in the app, not just logged.
- Regenerate API types (`dump_openapi` + `npm run generate:api`).
- Live smoke with Steve: create the Power Automate Workflow in Teams ("When a Teams webhook request is received" → Post card in a chat or channel), paste the URL into a channel; verify test-send, a real incident open/resolve card pair, and the deep link.

Prereq (Steve): a Teams channel + Power Automate Workflow minted from the Workflows app.