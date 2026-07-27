---
id: 01KYJRJCAP6NMWP1JP0M3R2Y5S
created: 2026-07-27T21:44:19.542096Z
updated: 2026-07-27T21:45:39.948113Z
type: task
title: 'Responder role: the viewer < responder < operator rung + role-aware surfaces'
project: 01KX671DATY39VW6GWK3M2T3DN
number: 344
sprint: sf23rna
assignee: steve
label:
- feature
priority: high
task_status: backlog
---
The Service Desk principal (ADR 0056; inserts into ADR 0015's cumulative ladder — legal because responder's powers are a strict subset of operator's).

- **Backend**: `ROLE_ORDER` becomes viewer < responder < operator < approver < admin. Responder grants: everything viewer has, PLUS run desk-executable playbooks on matched incidents, resolve/dismiss an incident after a run, record a note. Explicitly NOT: free-form propose_change, merge/detach, diagnose/analyse triggers, playbook authoring, approvals.
- **Sweep every `require_role("operator")` call site** and decide rung-by-rung — the insertion changes what "below operator" means; each endpoint gets an explicit decision, not an accident (mypy/grep sweep, documented in the PR).
- **MCP surface**: responder tokens work naturally (role cap "responder"); tool list filters the same way — a responder token sees read tools + run_playbook (ISE-345's tool) + resolve + record_note.
- **UI**: role-aware hiding — a responder's incident page shows the guided surface (ISE-346), not the power tools; nav trims to what they can use. The UI merely hides; the API is the authority (house rule).
- Role assignment stays wherever it lives today — in-app role editing remains deliberately unbuilt (ADR 0015; standing memory note).

DoD: a responder dev-login sees the guided experience end-to-end and every power endpoint 403s them; existing roles unchanged in behaviour.