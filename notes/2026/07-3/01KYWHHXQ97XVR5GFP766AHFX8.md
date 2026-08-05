---
id: 01KYWHHXQ97XVR5GFP766AHFX8
created: 2026-07-31T16:54:08.873744Z
updated: 2026-08-05T11:55:25.159794Z
type: task
title: Teams app package + Settings destination picker + live smoke
project: 01KX671DATY39VW6GWK3M2T3DN
number: 450
order: 1.5
sprint: s8rg5n9
blocked_by:
- 01KYWHH9WKA1RDD2JCNXME42HK
assignee: steve
priority: medium
task_status: done
---
The operator-facing half and acceptance.

- **Teams app package**: manifest (bot id, personal + groupChat scopes, name/icons/description), zipped. Published to the ORG APP CATALOGUE — required for ISE to install the app for a user or into a chat via Graph, and the one step with no ISE-side workaround. Keep the manifest in the repo so it is versioned, not a one-off upload.
- **Settings → Notifications rework**: the URL field is gone (ISE-446). Instead a destination picker per channel — a person, a group chat (from the discovered list, with a pasted-chat-link fallback), or the incident's assignee (ISE-449). Severity threshold and event toggles are unchanged. Test send stays, and should now report "not installed" distinctly from "failed".
- Recent-deliveries log gains the destination it resolved to, so it is clear WHO was told, not just that something was sent.
- Regenerate API types (`dump_openapi` + `npm run generate:api`).
- **Live smoke with Steve**: install the app, register a 1:1 channel and a group-chat channel, then verify test send → a real incident opening (card arrives, @mention on high) → the SAME card updating to resolved rather than a second card appearing → the deep link back into ISE.

Prereqs for Steve: an Entra app registration for the bot (id + secret), an Azure Bot resource, Graph application permissions consented (`TeamsAppInstallation.ReadWriteSelfForUser.All`, `...SelfForChat.All`, `Chat.ReadBasic.All`), and the app package published to the org catalogue.