---
id: 01KYHPW2259K63H3XE83KS5DJC
created: 2026-07-27T11:55:25.125028Z
updated: 2026-08-07T10:35:36.633665Z
type: task
title: 'Incident actions from Claude: status changes, merge/detach, notes, diagnosis'
project: 01KX671DATY39VW6GWK3M2T3DN
number: 335
sprint: sax9eff
assignee: steve
priority: medium
task_status: done
---
Steve must-have #6: perform ISE incident actions inside the Claude conversation. All operator-gated (RBAC from the foundation task), all requiring a pinned session, all reusing the existing service layer so rules stay in one place.

- `update_incident_status` — resolve / acknowledge / reactivate / dismiss; identical semantics to the UI including the child cascade + signal resolution (ADR 0035 §5, `cascade_status_to_children`).
- `merge_incidents` / `detach_incident` — reuses `merge.py` structural rules verbatim; `MergeRejected` details surface as the tool error so Claude can explain *why* ("that incident is already merged; detach it first"). Complements ISE-328: manual merge arrives on the MCP surface first; the widened candidate rule feeds the cues.
- `record_note` — a timeline note attributed to the user via Claude; how conversation conclusions get durably onto the ticket.
- `commit_diagnosis` — re-expose the existing ISE-285 machinery (zero fresh spend, reasoning already happened in the conversation).
- Explicitly OUT of scope here: direct infra mutations. Anything touching real systems goes through `propose_change` + tiered approval — the approvals task covers the approve side; proposing from MCP reuses the governed catalogue (ADR 0017/0026).

Vertical DoD: in a pinned session — merge IN-1091 into IN-1092, record a note, commit the diagnosis, resolve — and the incident screen shows all four, correctly attributed, with the merge obeying every structural rule.