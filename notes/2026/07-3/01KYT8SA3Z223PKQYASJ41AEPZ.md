---
id: 01KYT8SA3Z223PKQYASJ41AEPZ
created: 2026-07-30T19:42:24.895625Z
updated: 2026-07-30T19:42:24.895625Z
type: task
title: Cloudflare surface — account card, entity display, brief update, live smoke
task_status: backlog
label: feature
priority: medium
assignee: steve
project: 01KX671DATY39VW6GWK3M2T3DN
number: 385
---
The pane-of-glass slice (DoD: usable in the app, not just JSON) — AWS/Azure surface precedent (ISE-363/ISE-369).

- Cloudflare account card on System detail: status, last sync, entity counts by type, findings — mostly free via the generic card; verify.
- Estate/Explorer/graph display for the new `zone` and `tunnel` entity types (icons, detail rendering, filters).
- Update the integration-connectors brief table row (Cloudflare → Built, actual transport/scope) + run the "adding a new integration" DoD checklist (§1-5).
- Live smoke against the real Cloudflare account (the Azure smoke caught two real bugs — do it before calling the sprint done).