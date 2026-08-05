---
id: 01KYJRJCAP6NMWP1JP0M3R2Y5S
created: 2026-07-27T21:44:19.542096Z
updated: 2026-08-05T19:02:15.546966Z
type: task
title: 'Responder role: the viewer < responder < operator rung + role-aware surfaces'
project: 01KX671DATY39VW6GWK3M2T3DN
number: 344
order: -3.0
sprint: sf23rna
comments:
- id: 01KYJSZGNNYZ1E0Y0T96CVN0M1
  author: Steve Vine
  at: 2026-07-27T22:08:58.549726Z
  text: 'Built (PR #318, stacked on #317). ROLE_ORDER gains responder between viewer and operator on both sides (backend rbac + frontend hasRole + MCP tier-unlocks + token-card role list). The sweep''s outcome, each an explicit decision: PATCH /issues/{id}/status and the MCP update_incident_status + record_note tools drop to responder (closing out after a run is the desk''s job); everything else operator-shaped stays operator+ — incident create, merge/detach, diagnose/analyse/propose triggers, playbook authoring/publish, proposed changes, approvals. ResponderUser dependency added; responder-capped MCP tokens list exactly their tools (out-of-role calls answer as unknown, same as any filtered tool); the mint cap means a responder cannot create an operator token. Note: the guided-page UI hiding lands with ISE-347 (this task shipped the enforcement layer; the responder currently sees the standard page with power buttons 403ing server-side if forced). Tests: 4 new (API grants/refusals, viewer unchanged, MCP tool list + note/resolve in session, mint cap) + 66 role-adjacent regression tests green; full mypy/ruff/build green.'
assignee: steve
label: null
priority: high
task_status: done
---
The Service Desk principal (ADR 0056; inserts into ADR 0015's cumulative ladder — legal because responder's powers are a strict subset of operator's).

- **Backend**: `ROLE_ORDER` becomes viewer < responder < operator < approver < admin. Responder grants: everything viewer has, PLUS run desk-executable playbooks on matched incidents, resolve/dismiss an incident after a run, record a note. Explicitly NOT: free-form propose_change, merge/detach, diagnose/analyse triggers, playbook authoring, approvals.
- **Sweep every `require_role("operator")` call site** and decide rung-by-rung — the insertion changes what "below operator" means; each endpoint gets an explicit decision, not an accident (mypy/grep sweep, documented in the PR).
- **MCP surface**: responder tokens work naturally (role cap "responder"); tool list filters the same way — a responder token sees read tools + run_playbook (ISE-345's tool) + resolve + record_note.
- **UI**: role-aware hiding — a responder's incident page shows the guided surface (ISE-346), not the power tools; nav trims to what they can use. The UI merely hides; the API is the authority (house rule).
- Role assignment stays wherever it lives today — in-app role editing remains deliberately unbuilt (ADR 0015; standing memory note).

DoD: a responder dev-login sees the guided experience end-to-end and every power endpoint 403s them; existing roles unchanged in behaviour.