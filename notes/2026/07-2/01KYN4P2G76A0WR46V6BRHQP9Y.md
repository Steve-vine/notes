---
id: 01KYN4P2G76A0WR46V6BRHQP9Y
created: 2026-07-28T19:54:32.327902Z
updated: 2026-08-07T10:55:56.813987Z
type: task
title: 'Sectioned left nav: ISE Core / Integrations / System'
project: 01KX671DATY39VW6GWK3M2T3DN
number: 350
sprint: sg4216j
assignee: steve
priority: medium
task_status: done
---
Split the flat left nav into three titled sections (agreed 2026-07-28):

**ISE Core** — Overview, Dashboards, Incidents, Assist, Events, Playbooks, Estate, Tags, Proposals, Approvals
**Integrations** — Alerts, Observations, Documents, Repos
**System** — Agent runs, Audit, Settings

Notes:
- Overview stays at the top of ISE Core.
- Approvals keeps its `requiresRole: 'approver'` gate.
- Section titles render as headings above each group in `components/nav.ts` / the nav component; keep the existing placeholder (`arrivesInPhase`) behaviour.
- This reorders items relative to today's flat list — the section grouping is the authority.