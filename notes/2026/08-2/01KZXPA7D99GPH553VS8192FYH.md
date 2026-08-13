---
id: 01KZXPA7D99GPH553VS8192FYH
created: 2026-08-13T13:52:15.785247Z
updated: 2026-08-13T13:52:15.785247Z
type: task
title: An entity attached to a signal in error cannot be removed from the UI
task_status: backlog
priority: medium
assignee: steve
label: improvement
project: 01KX671DATY39VW6GWK3M2T3DN
number: 691
---
Once an incident has an estate entity — attached by hand or resolved automatically — there is no way in the app to correct or remove it. A wrong attachment is permanent from the operator's chair.

**The API already supports it.** `POST /findings/{id}/entity` with an explicit null clears the attachment and returns the row to automatic resolution (`findings.py:247-259`), and its docstring names this exact case: *"Clearing (an explicit null) is always allowed, and is the repair for an attachment made in error."* It even audits it distinctly as `signal_entity_cleared`.

**The UI never offers it.** `UnlinkedEntityPanel` (`IssueDetailPage.tsx:1479`) opens with `if (issue.entity_id || !issue.entity_link_reason) return null` — it renders *only* while the incident has no entity. The moment one is attached the panel vanishes, taking the only control with it. The capability exists and is unreachable.

Two ways to arrive at a wrong entity, and both are live:
- A human picks the wrong row from the search (ISE-639's attach has no confirmation step).
- Automatic resolution binds the wrong thing — a real risk with short hostnames, where `cross_keys_for` publishes the short form of every registered name (`servers.py:439`), so two machines sharing a short name across domains can collide.

**Scope**
- Surface the current entity on the incident with a way to **change** it and a way to **clear** it. Reuse the existing search picker rather than building a second one.
- Show provenance: `entity_pinned_by` is already plumbed to the read model (`issues.py:314`, `schemas.py:481`) but never rendered. "Attached by steve@…" versus resolved automatically is the difference between an answer to challenge and one to trust — and it tells the operator whether clearing will re-resolve to the same thing or to nothing.
- Clearing must be visibly consequential: it withdraws impact, entity-scoped playbooks and the AI's affected-entity context — the same three losses the unlinked panel already explains. Say so at the point of clearing.
- Operator-gated, matching the attach.
- After clearing, the incident returns to the unlinked state and `UnlinkedEntityPanel` reappears — verify that transition, since the panel's render condition is what hid the control in the first place.

Raised alongside ISE-690: fixing the case-insensitive join will start binding entities automatically that were previously unbound, which raises the odds of a wrong automatic binding at exactly the moment there is still no way to undo one.