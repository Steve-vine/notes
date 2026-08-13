---
id: 01KYJRM7ZZZNDPP7B9MPPCMCK0
created: 2026-07-27T21:45:20.639366Z
updated: 2026-08-13T19:00:07.239287Z
type: task
title: 'MCP authoring parity: draft, confirm and publish playbooks from Claude'
project: 01KX671DATY39VW6GWK3M2T3DN
number: 348
order: 0.0
sprint: sf23rna
comments:
- id: 01KYJV5REG2JN950NFGM8TT6Z6
  author: Steve Vine
  at: 2026-07-27T22:29:51.696194Z
  text: 'Built (PR #322, stacked on #321). First extracted create_draft/apply_update into playbooks.py so the REST endpoints and MCP tools share literally one rule (rows, audit, edit-retracts-live). Six operator-tier tools: list_pending_learnings (the page nudge''s own bounded scan reused), confirm_learning (distils diagnosis + executed fix into a draft body — defaults to the pinned session''s incident, or takes IN-NNNN), draft_playbook, update_playbook, publish_playbook / retract_playbook (ISE-343''s gates verbatim — envelope validation with T3 named in the refusal, second-engineer SoD in the service''s own wording). One deliberate decision beyond the task body, noted in the module docstring: authoring tools are NOT session-pinned — a playbook is cross-incident engineering work, not activity on one ticket; creation/publish/retract are audited on the playbook entity instead (the request_publish two-step from the body collapsed into publish_playbook since SoD is enforced server-side regardless of who initiates). The skill gained a "Close the learning loop" section — offer to distil on resolve, tighten, hand to a second engineer, "you cannot publish your own". Tests: the full loop over MCP incl. SoD refusal + second-engineer publish + edit-retracts; T3 refusal; non-distillable refusal; responder tokens list zero authoring tools. Full gates green.'
assignee: steve
label: null
priority: medium
task_status: done
tech: null
---
Engineers live on the MCP surface (ADR 0055); the playbook loop must not force them back to the UI mid-flow. Operator-tier tools, session-scoped, all through the same service layer as the authoring UI (one rule, two surfaces):

- `list_pending_learnings` / `confirm_learning` — the ISE-302 proposal queue readable and confirmable from Claude; confirming drafts the V2 body from the distilled proposal.
- `draft_playbook(body, envelope)` / `update_playbook` — create/edit drafts. Envelope validated identically to the UI path (T3 refusal, predicate schema-check at publish).
- `request_publish(playbook_id)` — starts the second-engineer gate; the OTHER engineer publishes (in UI or via their own `publish_playbook` call — the not-sole-author rule enforced server-side regardless of surface).
- `find_playbooks` grows the envelope view so an engineer reviewing from Claude sees exactly what the desk would be allowed to do.
- Cue: an incident resolved in a Claude session that produced a learning proposal gets a "distil this into a playbook?" line in the session's closing flow (the skill's record-conclusions discipline extends naturally).

DoD: the full loop — investigate in Claude, resolve, confirm the learning, draft the V2 playbook, hand to a second engineer to publish — happens without opening the UI (except the second engineer's own review, either surface).