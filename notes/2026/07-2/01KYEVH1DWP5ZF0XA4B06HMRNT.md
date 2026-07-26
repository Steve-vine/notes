---
id: 01KYEVH1DWP5ZF0XA4B06HMRNT
created: 2026-07-26T09:19:03.612676Z
updated: 2026-07-26T09:50:07.603771Z
type: task
title: Playbook authoring UI + learning proposals made discoverable
project: 01KX671DATY39VW6GWK3M2T3DN
number: 302
sprint: svgrad3
assignee: steve
label:
- feature
- bug
priority: medium
task_status: todo
---
**Sprint 24, live-found (2026-07-26).** Steve resolved IN-1079 (which carried a committed diagnosis), the backend correctly proposed a playbook (`propose_learning` returns it; `GET /issues/{id}/learning` → 200), and yet: nothing visible in Playbooks and no way to create one by hand. Two UI gaps, both Sprint-13 ship-the-API-not-the-screen misses (the DoD rule's exact failure mode):

**1. Learning proposals are invisible unless you know where to scroll.** The "What ISE learned from this incident" card renders on the incident detail page (below Recall/Merge), but nothing points at it:
- **Resolve-flow nudge**: when resolving/closing an incident that yields a learning proposal, tell the operator — a notification or inline prompt ("ISE proposed a playbook from this incident — review it") linking to the card. The loop's Update step should close itself, not rely on scroll-luck.
- **Pending-proposals hint on the Playbooks page**: resolved/closed incidents with an unconfirmed, not-already-covered proposal listed ("2 incidents have unconfirmed learnings") linking back to each incident's card. Needs a small backend listing (e.g. recent terminal issues where propose_learning is non-null) — keep it bounded/cheap.

**2. No manual authoring UI.** `POST /playbooks` exists (operator role, ADR 0029 route 2: seed a known class directly) but the Playbooks page is list-only. Add a "New playbook" button + form matching `PlaybookCreate` (name, kind, hypotheses, investigation plan, remediation options referencing catalogue operations by name, validation criteria). Editing an existing playbook (versioned, per ADR 0029 provenance) belongs here too if cheap — otherwise note it out of scope.

Acceptance: resolving an incident with something to learn visibly prompts the operator and one click lands them on the confirm card; the Playbooks page can create a playbook from scratch; the Playbooks page shows when unconfirmed learnings are waiting.