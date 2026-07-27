---
id: 01KYJRM7ZZZNDPP7B9MPPCMCK0
created: 2026-07-27T21:45:20.639366Z
updated: 2026-07-27T21:45:20.639366Z
type: task
title: 'MCP authoring parity: draft, confirm and publish playbooks from Claude'
assignee: steve
priority: medium
task_status: backlog
label: feature
project: 01KX671DATY39VW6GWK3M2T3DN
number: 348
---
Engineers live on the MCP surface (ADR 0055); the playbook loop must not force them back to the UI mid-flow. Operator-tier tools, session-scoped, all through the same service layer as the authoring UI (one rule, two surfaces):

- `list_pending_learnings` / `confirm_learning` — the ISE-302 proposal queue readable and confirmable from Claude; confirming drafts the V2 body from the distilled proposal.
- `draft_playbook(body, envelope)` / `update_playbook` — create/edit drafts. Envelope validated identically to the UI path (T3 refusal, predicate schema-check at publish).
- `request_publish(playbook_id)` — starts the second-engineer gate; the OTHER engineer publishes (in UI or via their own `publish_playbook` call — the not-sole-author rule enforced server-side regardless of surface).
- `find_playbooks` grows the envelope view so an engineer reviewing from Claude sees exactly what the desk would be allowed to do.
- Cue: an incident resolved in a Claude session that produced a learning proposal gets a "distil this into a playbook?" line in the session's closing flow (the skill's record-conclusions discipline extends naturally).

DoD: the full loop — investigate in Claude, resolve, confirm the learning, draft the V2 playbook, hand to a second engineer to publish — happens without opening the UI (except the second engineer's own review, either surface).