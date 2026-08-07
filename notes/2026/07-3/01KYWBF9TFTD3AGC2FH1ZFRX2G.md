---
id: 01KYWBF9TFTD3AGC2FH1ZFRX2G
created: 2026-07-31T15:07:51.503902Z
updated: 2026-08-07T09:40:52.838415Z
type: task
title: Freshservice evidence, summary card + live smoke
project: 01KX671DATY39VW6GWK3M2T3DN
number: 444
order: 1.5
sprint: s5pft6a
blocked_by:
- 01KYWBDKMHGT3KM4TK3H6Q8KWF
comments:
- id: 01KYX7EV04F8QHV3CVYH7R2AMF
  author: Steve Vine
  at: 2026-07-31T23:16:56.452567Z
  text: |-
    Done — PR #391 (stacked on #390), CI green including frontend and api-types.

    **Evidence:** `ticket_detail`, `recent_tickets`, `ticket_search`. These are what recover the investigative value entity-less signals lose — an agent working an unrelated Kubernetes incident can't *join* tickets to the affected entity, but it can ask what the desk is seeing about "checkout" right now. `ticket_search` matches subject *and* body, since a user's description often names the service when the subject doesn't.

    **One deliberate asymmetry worth knowing:** evidence does *not* apply the scope gate or the ISE-tag exclusion. That gate exists to keep noise out of **detection**, not out of an operator's own question — "what is the desk seeing?" means everything, including the ticket ISE raised. There's a test pinning it so nobody "fixes" it later.

    **Summary card** reads ISE's own record only. It reports arrivals (24h / 7d) rather than open-vs-resolved, because state isn't tracked locally and the card should say what it knows rather than guess.

    Two details I'd flag:
    - **The domain is derived from a stored ticket's own URL**, not the credential. Naming the desk is worth a card line; it isn't worth an audited credential reveal on every page view.
    - **The ISE-raised count makes the feedback-loop cut visible** rather than merely tested — you can see how many of the desk's tickets ISE put there and satisfy yourself none are feeding the detectors. Counted from executed `ProposedChange` rows, because a desk agent can delete a tag but can't edit ISE's own record.

    Verification: 42 connector tests + 17 integration tests (including the card before any sweep, and the wrong-connector-type refusal); **full backend suite 2023 passed, full frontend 466 across 82 files**; all lint/type/build gates clean. OpenAPI + `schema.d.ts` regenerated on this branch per the EntraID lesson.
assignee: steve
label: null
priority: medium
task_status: done
---
Closes the sprint: on-demand desk context for investigations, the System detail card, and the live smoke.

**Evidence-on-demand** (`evidence_catalogue` / `fetch_evidence`, the M365 shape — pull not push, ADR 0031): `ticket_detail` (by id, current state), `recent_tickets`, `ticket_search` (by keyword). This is what recovers investigative value lost by entity-less signals: an agent investigating an unrelated Kubernetes incident can ask what the service desk is seeing. Side-effect free; `data` is untrusted content by contract; degrade to `ok=False` with a summary rather than raising.

**Summary card** — `_require_freshservice` guard + `GET /{system_id}/freshservice-summary` in `api/v1/systems.py`, response model in `api/v1/schemas.py`, card component + the `connector_type === 'freshservice' &&` line in `SystemDetailPage.tsx` (~1731). Reads ISE's own stored record only, **never a live vendor call on page view**.

Card shows: domain and agent identity, open ticket counts by type/priority, current burst state, 24h ticket-event count, and the **count of ISE-raised tickets** — which makes the feedback-loop cut visible to an operator rather than merely tested.

Regenerate the OpenAPI snapshot (new endpoints redden the api-types check — regenerate on the branch that adds them, per the EntraID lesson).

**Live smoke on staging (Steve):** register the integration; confirm tickets land on the Events screen; provoke a burst and confirm an incident opens; then raise a ticket from that incident and confirm it appears in Freshservice with the `ise-generated` tag and is **not** re-ingested as a signal.

**Prerequisite:** a Freshservice instance with a read API key (view-only agent) and a second key on a separate agent scoped for ticket creation.