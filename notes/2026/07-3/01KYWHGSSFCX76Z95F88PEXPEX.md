---
id: 01KYWHGSSFCX76Z95F88PEXPEX
created: 2026-07-31T16:53:32.079902Z
updated: 2026-08-06T08:15:18.957249Z
type: task
title: Destination resolution — 1:1 chats by person, group chats by discovery/install
project: 01KX671DATY39VW6GWK3M2T3DN
number: 447
order: 3.0
sprint: s8rg5n9
blocked_by:
- 01KYWHGF17XY27YYK08XYDQ8MX
assignee: steve
priority: medium
task_status: done
---
Turning "who should hear this" into a Bot Framework conversation id, cached on the channel.

**1:1 chats (a named person)**
- ISE user → Entra user → `aadObjectId`. The EntraID sprint (setdxf2) already stores users as estate entities with their object ids, and left the UPN↔email cross-key harvest as a noted follow-on — this is that join.
- Create the conversation: `POST /v3/conversations` with the aadObjectId in `members[].id`, `channelData.tenant.id`, against the global proactive service URL `https://smba.trafficmanager.net/teams/`. Returns the conversation id — cache it, create once.
- The app MUST be installed in that user's PERSONAL scope or the send fails 403 `ForbiddenOperationException`. ISE can install it via Graph `POST /users/{id}/teamwork/installedApps` (`TeamsAppInstallation.ReadWriteSelfForUser.All`), which requires the app to be in the ORG APP CATALOGUE.

**Group chats** — achievable outbound-only (verified 2026-07-31):
- Discover: `GET /users/{id}/chats?$filter=installedApps/any(a:a/teamsApp/id eq '{app-id}')` returns every chat the ISE app is installed in, with `id`, `topic`, `chatType`, `webUrl`. Application permission `Chat.ReadBasic.All` — VERIFY AT BUILD whether the asterisk on that permission in the Graph docs footnotes a protected-API/licensing gate.
- Install into a chat: `POST /chats/{chat-id}/installedApps`, least-privileged application permission `TeamsAppInstallation.ReadWriteSelfForChat.All` (install only our own app). Documented limitation: the ForChat install permissions cannot install apps requiring RSC consent — we use none, so it should not bite.
- FALLBACK if listing is gated: a chat's `webUrl` contains the thread id (`19:…@thread.v2`), so accept a pasted chat link and parse it. Keeps the feature working with one fewer permission.

Cache resolved conversation ids on the channel row; a 403 on send should invalidate the cache and surface "the app is not installed here" rather than a raw error.