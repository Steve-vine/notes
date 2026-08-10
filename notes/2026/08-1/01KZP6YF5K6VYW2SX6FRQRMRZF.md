---
id: 01KZP6YF5K6VYW2SX6FRQRMRZF
created: 2026-08-10T16:09:00.851518Z
updated: 2026-08-10T19:03:00.441762Z
type: task
title: An incident that names no entity loses impact, playbooks and AI context — and says none of it
project: 01KX671DATY39VW6GWK3M2T3DN
number: 639
sprint: s1rgnyx
assignee: steve
label:
- improvement
priority: high
task_status: todo
---
Found 2026-08-10, companion to [ISE-638]. When a finding carries no `entity_id`, the incident it raises quietly loses three capabilities at once. Each degradation is a silent `if`, and none of them tells the operator what happened or why.

**What goes missing, all gated on the same null:**

- **Impact.** `IssueDetailPage.tsx:1634` renders `ImpactPanel` only `if (issue.entity_id)`. The panel's own comment calls "what is this hurting" a header question the operator needs *before* the timeline — and for 58 of 60 DataDog incidents it is simply absent, indistinguishable from "nothing depends on this".
- **Playbooks.** `playbooks.py:99` matches `or_(Playbook.entity_id.is_(None), Playbook.entity_id == finding.entity_id)`. With a NULL finding entity the equality is never true, so an unlinked incident can only ever match **unscoped** playbooks. Every entity-scoped playbook in the estate is invisible to it, permanently — and per [ISE-634] the answer is still just "no applicable playbooks".
- **AI context.** `get_affected_entity_context` has no entity to resolve, so the agent reasons about an incident with no subject. This is how "resolves to no known entity" gets stated as a fact about the estate ([ISE-633] is the same sentence from a different cause).

**The principle**, again from the preflight failure categories: an absent capability must name its missing precondition. "This incident names no estate entity, so impact and entity-scoped playbooks are unavailable" is a fixable statement — a blank space is not.

## DECIDED 2026-08-10 — the manual attach lives on the FINDING, pinned

Not on the incident. Attaching on the finding fixes **every future incident from that monitor**, not just the one in front of the operator; attaching on the incident would have to be re-done on every fire, which is the [ISE-648] pattern of a decision that does not stick.

**Shape**: set `finding.entity_id` plus a new `finding.entity_pinned_by` column. `link_findings_to_entities` (`discovery.py:567`) skips any finding whose pin is set.

**Precedent**: `entity.name_pinned_by` already exists for exactly this — "a human decided this, discovery must not overwrite it". Same shape, same reasoning, so the estate gains no new concept.

**Why the pin is load-bearing even though today's rows look safe**: `link_findings_to_entities` only touches findings with a **non-null `entity_key`**, and the 58 unlinked DataDog findings have none — so today a bare `entity_id` write would survive. But once [ISE-638] makes those findings carry an `entity_key`, resolution starts running over them, and an unpinned manual attach would be silently overwritten on the next sync. Build the pin with the attach, not after.

Rejected: writing `finding.entity_key` and letting normal resolution do the work — a key with no matching alias resolves to nothing, so the operator's choice would silently fail to take.

**Also in scope**
- The incident header states when there is no linked entity, with the reason from the signal (no scope tag / no matching alias / manual incident).
- Where a capability is withheld for that reason, say so in place of rendering nothing — impact panel, playbook list, and the AI's own answer.

**Acceptance**: an unlinked incident says so in the header and says what is unavailable because of it; an operator can attach the right entity and see impact and playbooks appear; the attachment survives the next sync and applies to the next incident from that signal; the AI says "this signal resolved to no entity" rather than "this host is not registered".