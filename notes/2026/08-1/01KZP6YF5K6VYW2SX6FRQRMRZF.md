---
id: 01KZP6YF5K6VYW2SX6FRQRMRZF
created: 2026-08-10T16:09:00.851518Z
updated: 2026-08-10T16:09:09.227324Z
type: task
title: An incident that names no entity loses impact, playbooks and AI context — and says none of it
project: 01KX671DATY39VW6GWK3M2T3DN
number: 639
sprint: s1rgnyx
assignee: steve
label:
- improvement
priority: high
task_status: backlog
---
Found 2026-08-10, companion to [ISE-638]. When a finding carries no `entity_id`, the incident it raises quietly loses three capabilities at once. Each degradation is a silent `if`, and none of them tells the operator what happened or why.

**What goes missing, all gated on the same null:**

- **Impact.** `IssueDetailPage.tsx:1634` renders `ImpactPanel` only `if (issue.entity_id)`. The panel's own comment calls "what is this hurting" a header question the operator needs *before* the timeline — and for 58 of 60 DataDog incidents it is simply absent, indistinguishable from "nothing depends on this".
- **Playbooks.** `playbooks.py:99` matches `or_(Playbook.entity_id.is_(None), Playbook.entity_id == finding.entity_id)`. With a NULL finding entity the equality is never true, so an unlinked incident can only ever match **unscoped** playbooks. Every entity-scoped playbook in the estate is invisible to it, permanently — and per [ISE-634] the answer is still just "no applicable playbooks".
- **AI context.** `get_affected_entity_context` has no entity to resolve, so the agent reasons about an incident with no subject. This is how "resolves to no known entity" gets stated as a fact about the estate ([ISE-633] is the same sentence from a different cause).

**The principle**, again from the preflight failure categories: an absent capability must name its missing precondition. "This incident names no estate entity, so impact and entity-scoped playbooks are unavailable" is a fixable statement — a blank space is not. It is also *the* triage question: an operator who cannot see what an alert is attached to cannot judge whether it matters.

**Scope**
- The incident header states when there is no linked entity, with the reason available from the signal (no scope tag on the group / no matching alias / manual incident).
- Where a capability is withheld for that reason, say so in place of rendering nothing — impact panel, playbook list, and the AI's own answer.
- A route out: let an operator **attach an entity by hand** to an incident whose signal could not resolve one. That turns a dead end into a triage step, and it is the same act ISE already supports at authoring time elsewhere. Worth checking whether the attachment belongs on the incident or on the finding — on the finding it also fixes every future incident from that monitor, which is the more valuable place for it.

**Acceptance**: an unlinked incident says so in the header and says what is unavailable because of it; an operator can attach the right entity and see impact and playbooks appear; the AI says "this signal resolved to no entity" rather than "this host is not registered".