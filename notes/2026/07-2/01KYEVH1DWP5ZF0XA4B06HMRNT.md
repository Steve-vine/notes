---
id: 01KYEVH1DWP5ZF0XA4B06HMRNT
created: 2026-07-26T09:19:03.612676Z
updated: 2026-08-13T19:00:09.495289Z
type: task
title: Playbook authoring UI + learning proposals made discoverable
project: 01KX671DATY39VW6GWK3M2T3DN
number: 302
sprint: svgrad3
comments:
- id: 01KYEZP25JMJCXDHY18VF5YZ3A
  author: Steve Vine
  at: 2026-07-26T10:31:42.514231Z
  text: |-
    Implemented — PR #270 (feature/ise-302-playbook-authoring-discoverability).

    1. Learning proposals discoverable:
    - Resolve-flow nudge: resolving/closing an incident that yields a learning proposal now fires a notification linking straight to the "What ISE learned" card (gave it id=learning). The Update bookend closes itself instead of relying on scroll-luck.
    - Pending-proposals hint: new GET /playbooks/pending-learnings — bounded scan (40 most-recent terminal incidents) + result cap (10), children excluded, filters to proposals that are non-null AND not already_covered (so once a playbook of that kind exists — including this learning confirmed — it drops off). Playbooks page shows "N incidents have unconfirmed learnings", each linking to /issues/{id}#learning with a hash-scroll to the card.

    2. Manual authoring: operator-gated "New playbook" modal matching PlaybookCreate (name, kind, hypotheses, plan, remediation as 'operation — note' lines, validation). POST /playbooks already existed.

    Scope note: editing an existing playbook is deliberately OUT of scope — there's no PUT endpoint and versioned provenance (ADR 0029) makes it a separate task, as the task text allowed. Authoring-new + discoverability is the deliverable.

    Tests: backend endpoint + integration test (lists then clears when covered), ruff + mypy strict green; frontend PlaybooksPage tests (list/empty/pending-hint-links/authoring-payload) + full suite 409 green + build. API types regenerated. The resolve notification (a portal) is left to the staging smoke test, matching the existing suite's scope. Moving to review; will deploy to staging with ISE-303.
assignee: steve
label: null
priority: medium
task_status: done
tech: null
---
**Sprint 24, live-found (2026-07-26).** Steve resolved IN-1079 (which carried a committed diagnosis), the backend correctly proposed a playbook (`propose_learning` returns it; `GET /issues/{id}/learning` → 200), and yet: nothing visible in Playbooks and no way to create one by hand. Two UI gaps, both Sprint-13 ship-the-API-not-the-screen misses (the DoD rule's exact failure mode):

**1. Learning proposals are invisible unless you know where to scroll.** The "What ISE learned from this incident" card renders on the incident detail page (below Recall/Merge), but nothing points at it:
- **Resolve-flow nudge**: when resolving/closing an incident that yields a learning proposal, tell the operator — a notification or inline prompt ("ISE proposed a playbook from this incident — review it") linking to the card. The loop's Update step should close itself, not rely on scroll-luck.
- **Pending-proposals hint on the Playbooks page**: resolved/closed incidents with an unconfirmed, not-already-covered proposal listed ("2 incidents have unconfirmed learnings") linking back to each incident's card. Needs a small backend listing (e.g. recent terminal issues where propose_learning is non-null) — keep it bounded/cheap.

**2. No manual authoring UI.** `POST /playbooks` exists (operator role, ADR 0029 route 2: seed a known class directly) but the Playbooks page is list-only. Add a "New playbook" button + form matching `PlaybookCreate` (name, kind, hypotheses, investigation plan, remediation options referencing catalogue operations by name, validation criteria). Editing an existing playbook (versioned, per ADR 0029 provenance) belongs here too if cheap — otherwise note it out of scope.

Acceptance: resolving an incident with something to learn visibly prompts the operator and one click lands them on the confirm card; the Playbooks page can create a playbook from scratch; the Playbooks page shows when unconfirmed learnings are waiting.