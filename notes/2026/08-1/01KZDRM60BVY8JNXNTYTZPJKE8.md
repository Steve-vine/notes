---
id: 01KZDRM60BVY8JNXNTYTZPJKE8
created: 2026-08-07T09:24:48.267199Z
updated: 2026-08-13T19:00:01.886415Z
type: task
title: Role gate drops — Assist ask to viewer, incident status/merge to responder
project: 01KX671DATY39VW6GWK3M2T3DN
number: 597
sprint: snk16ew
comments:
- id: 01KZE6ZG7MH7YDNET8PWCBKDAJ
  author: Steve Vine
  at: 2026-08-07T13:35:39.252734Z
  text: |-
    Built on feature/ise-597-role-gate-drops — PR #519.

    Both rulings implemented. The rule I worked to: a gate move lands in THREE places or it hasn't landed — the API route, the MCP registry `min_role`, and the `describe_resources` blurb.

    **Ruling 4 — Assist ask operator → viewer.**
    - `POST /assist/threads` and `POST /threads/{id}/turns` now ViewerUser. Reasoning written into the module docstring: Assist structurally cannot act (every tool opens a read-only session, no action catalogue — ADR 0023), so asking reaches nothing a viewer couldn't open a screen and read; spend is the ADR 0033 budget gates' job and they apply per user regardless of role.
    - Ownership scoping untouched and now pinned by its own test — a viewer reaches their own thread and nobody else's, same 404 for "not yours" as "not there".
    - Frontend: the "you need the operator role to ask" notice is gone; a viewer gets the composer AND the new-conversation button.

    **Ruling 5 — incident merge operator → responder.**
    - Note `/status` was ALREADY responder from ISE-344, so the actual work here was merge.
    - `POST /issues/{id}/merge` → ResponderUser; MCP `merge_incident` → min_role responder.

    **Two step-siblings I took deliberately, neither in the rulings' letter:**
    - `DELETE /assist/threads/{id}` → viewer. A role that can start a conversation and never tidy it away is a bug shipped on purpose. Owner-scoped, so the blast radius is the caller's own history.
    - `/detach` and MCP `detach_incident` → responder. Reversibility is precisely why merging is safe to hand to the desk; a rung that can merge and not unmerge is a one-way door built by oversight.

    **The lockstep guard.** `_TIER_UNLOCKS` now reads "responder: incident state — status, assignment, merge/detach, record notes" and operator keeps only "commit diagnosis, propose changes". New test `test_the_tier_blurb_matches_what_is_actually_registered` asserts the blurb against the REGISTRY, not against prose — so the next min_role change can't quietly make describe_resources lie. Worth stating explicitly: a promise that UNDERSTATES is as wrong as one that overstates, because a desk agent told it cannot merge will not try.

    **Screen (the half that makes it real).** The engineer's incident page was the only place the merge-candidates panel lived — and a responder never sees that page, they get GuidedIncidentView. So dropping the API gate alone would have changed nothing a desk agent could see. `MergePanel` is extracted to `components/MergePanel.tsx` (gate now `responder`) and rendered in BOTH the engineer page and the guided page. A responder can now fold in the duplicate they could already see.

    No new ADR: ADR 0090 §3 already decided both rulings and explicitly deferred the implementation to a separate task. I added an amendment block to 0090 recording that the gates have landed, the two step-siblings, and the three-places rule.

    Tests: viewer-can-ask full lifecycle + ownership-still-holds; merge AND detach at responder end to end; responder MCP tool list gains merge/detach and still excludes commit_diagnosis/propose_change; the registry↔blurb invariant; frontend desk-can-merge and viewer-sees-no-button. One existing test flipped meaning correctly — `test_responder_can_resolve_but_not_operate` now expects 400 (the domain rule refusing a self-merge) where it expected 403, which is the role gate letting the call through.

    Full backend suite green locally: 2540 passed. Frontend 661 passed, build/eslint/prettier clean. OpenAPI + schema.d.ts regenerated (docstrings changed, no shape change).
assignee: steve
label: null
priority: medium
task_status: done
tech: null
---
Implement Role Matrix rulings 4 and 5 (agreed 2026-08-07):

- **Assist ask: operator → viewer.** Assist structurally cannot act (ADR 0023), so asking is a read; spend stays governed by the ADR 0033 budget gates. Backend gate on `POST /threads` + `/turns`; remove the frontend "you need the operator role to ask" notice for viewers.
- **Incident actions (status, merge): operator → responder.** The Service Desk manages incident state. Both places: the API routes AND the MCP registry `min_role` — and the MCP `describe_resources` role-tier blurb must move in lockstep (it is read as a promise and may only claim what is registered — Sprint 54 rule).
- RBAC tests for both boundaries (403 below the rung, 2xx at it).

Screens: Assist page (viewer can ask); incident screen (responder sees status/merge controls — UI hides what the role can't do, API is the authority).