---
id: 01KZ9N1D1JQ3SGT1BBXDH8EH2Z
created: 2026-08-05T19:05:09.426209Z
updated: 2026-08-09T08:04:37.110385Z
type: task
title: Hyper-V guest enumeration via registered hosts feeds the coverage reconciler
project: 01KX671DATY39VW6GWK3M2T3DN
number: 570
sprint: sesjg7z
assignee: steve
label: null
priority: medium
task_status: review
---
Enabling follow-on for ISE-566, and the recursive one: there is no Hyper-V integration — guest visibility comes from the server integration itself. Register a Hyper-V host, and it reveals its guests. Depends on Windows connectivity (ISE-564) and Windows evidence (ISE-567); lands after Windows support is proven.

- A registered Windows server can be **marked as a Hyper-V host** (or auto-detected from the Hyper-V role in facts/evidence).
- A scheduled or on-registration **guest enumeration** pull (`Get-VM` over WinRM, read profile): guest name, state, OS if available via integration services.
- Guests feed the ISE-566 reconciler as **list-only candidates** attributed to their host ("seen on HV-HOST-01"), deduped by hostname against Arc/Entra/cloud sightings. Register + mint on confirm, same as every list source.
- On confirm, also propose a **`runs-on` edge** guest → host through the normal edge-proposal path, so the graph shows the virtualisation layer.
- Guests of *unregistered* Hyper-V hosts are invisible by definition — the Coverage tab should say so on the host's own candidate row ("registering this host will reveal its guests").

**Acceptance**: registering a staging Hyper-V host surfaces its guests as candidates within one reconciler cycle, each attributed to the host; confirming one registers it and draws the runs-on edge; nothing is enumerated from hosts ISE hasn't been given.