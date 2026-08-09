---
id: 01KZ9N0KH0AWGT2G4CHTME3JNY
created: 2026-08-05T19:04:43.29641Z
updated: 2026-08-09T19:18:23.063158Z
type: task
title: EntraID device discovery feeds the coverage reconciler
project: 01KX671DATY39VW6GWK3M2T3DN
number: 569
sprint: sesjg7z
assignee: steve
label: null
priority: medium
task_status: done
---
Enabling follow-on for ISE-566: the EntraID connector currently discovers users, groups, service principals and CA policies — **not devices** — so Entra can't yet feed the fleet reconciler.

- Extend the EntraID connector with **device object discovery** (`/devices` via the shared `GraphClient` in `msgraph.py`), filtered to **server operating systems** (hybrid/Entra-joined Windows Server; exclude workstations, mobile, autopilot clutter) — this is a *list source* for the reconciler, like Arc: devices do **not** become estate entities from this path.
- Feed unmatched server-OS devices into the ISE-566 reconciler as list-only candidates (register + mint on confirm). Dedupe against Arc by hostname — the same physical server frequently appears in both; one candidate, both sources cited.
- Stale device objects are a known Entra disease: apply a last-sign-in/last-activity recency filter so long-dead computer objects don't resurrect as candidates; log the filtered count.
- Read scope addition to the EntraID credential spec (`Device.Read.All`) — read SP only; document in the integration docs page.

**Acceptance**: on staging, Entra-joined Windows Servers appear as coverage candidates exactly once (deduped with Arc), workstations and stale objects never do, and the EntraID integration card reflects the new capability.