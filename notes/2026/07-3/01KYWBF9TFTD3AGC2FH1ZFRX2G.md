---
id: 01KYWBF9TFTD3AGC2FH1ZFRX2G
created: 2026-07-31T15:07:51.503902Z
updated: 2026-07-31T22:52:12.092211Z
type: task
title: Freshservice evidence, summary card + live smoke
project: 01KX671DATY39VW6GWK3M2T3DN
number: 444
order: 1.5
sprint: s5pft6a
blocked_by:
- 01KYWBDKMHGT3KM4TK3H6Q8KWF
assignee: steve
priority: medium
task_status: todo
---
Closes the sprint: on-demand desk context for investigations, the System detail card, and the live smoke.

**Evidence-on-demand** (`evidence_catalogue` / `fetch_evidence`, the M365 shape — pull not push, ADR 0031): `ticket_detail` (by id, current state), `recent_tickets`, `ticket_search` (by keyword). This is what recovers investigative value lost by entity-less signals: an agent investigating an unrelated Kubernetes incident can ask what the service desk is seeing. Side-effect free; `data` is untrusted content by contract; degrade to `ok=False` with a summary rather than raising.

**Summary card** — `_require_freshservice` guard + `GET /{system_id}/freshservice-summary` in `api/v1/systems.py`, response model in `api/v1/schemas.py`, card component + the `connector_type === 'freshservice' &&` line in `SystemDetailPage.tsx` (~1731). Reads ISE's own stored record only, **never a live vendor call on page view**.

Card shows: domain and agent identity, open ticket counts by type/priority, current burst state, 24h ticket-event count, and the **count of ISE-raised tickets** — which makes the feedback-loop cut visible to an operator rather than merely tested.

Regenerate the OpenAPI snapshot (new endpoints redden the api-types check — regenerate on the branch that adds them, per the EntraID lesson).

**Live smoke on staging (Steve):** register the integration; confirm tickets land on the Events screen; provoke a burst and confirm an incident opens; then raise a ticket from that incident and confirm it appears in Freshservice with the `ise-generated` tag and is **not** re-ingested as a signal.

**Prerequisite:** a Freshservice instance with a read API key (view-only agent) and a second key on a separate agent scoped for ticket creation.