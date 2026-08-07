---
id: 01KZDRM60BVY8JNXNTYTZPJKE8
created: 2026-08-07T09:24:48.267199Z
updated: 2026-08-07T11:39:13.513623Z
type: task
title: Role gate drops — Assist ask to viewer, incident status/merge to responder
project: 01KX671DATY39VW6GWK3M2T3DN
number: 597
sprint: snk16ew
assignee: steve
label: null
priority: medium
task_status: todo
---
Implement Role Matrix rulings 4 and 5 (agreed 2026-08-07):

- **Assist ask: operator → viewer.** Assist structurally cannot act (ADR 0023), so asking is a read; spend stays governed by the ADR 0033 budget gates. Backend gate on `POST /threads` + `/turns`; remove the frontend "you need the operator role to ask" notice for viewers.
- **Incident actions (status, merge): operator → responder.** The Service Desk manages incident state. Both places: the API routes AND the MCP registry `min_role` — and the MCP `describe_resources` role-tier blurb must move in lockstep (it is read as a promise and may only claim what is registered — Sprint 54 rule).
- RBAC tests for both boundaries (403 below the rung, 2xx at it).

Screens: Assist page (viewer can ask); incident screen (responder sees status/merge controls — UI hides what the role can't do, API is the authority).