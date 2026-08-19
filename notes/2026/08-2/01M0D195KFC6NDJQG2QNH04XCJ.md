---
id: 01M0D195KFC6NDJQG2QNH04XCJ
created: 2026-08-19T12:52:31.983206Z
updated: 2026-08-19T15:34:51.090245Z
type: task
title: Approval page — details permanently visible left, actions right, plus four field-rendering fixes
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 279
sprint: s5gwx0s
assignee: steve
label:
- improvement
- bug
priority: high
task_status: active
---
Rework of the approval screen's review flow (COM-260 as shipped), from smoke-testing: the request contents hide behind a "Review and edit" click, and what that panel shows is wrong in four ways.

**Layout** — no more click-to-reveal:

* **Left column**: the subject, and directly beneath it the **full request details, permanently visible** as read-only values — every field execution will use, plus the justification. Underneath: an **Edit** button that switches the fields to inputs; in edit mode the buttons become **Save corrections** / **Discard** (save records the COM-260 original→approved diff as before; discard reverts to the read-only view untouched).
* **Right column**: the decision — **Approve / Reject / Cancel** — always visible without scrolling past the details on a normal screen.
* Batch requests: per-subject detail blocks down the left, decision still one set of actions on the right.

**Field fixes the details panel must land with:**

1. **Group request — owner invisible**: the owner renders only as a picker in edit mode; read-only mode must show the resolved owner (name + UPN), picker only after Edit.
2. **Joiner — Business Role missing, Usage Location present**: the panel omits the business role(s) — the single most decision-relevant field, since it determines the group adds — while showing Usage Location. Add Business Role(s) with the resolved group list; Usage Location stays (execution sends it on the Graph create) but as a minor field, not in place of the role.
3. **Mover/leaver — GUID instead of username**: the subject renders as the Entra object id; resolve display name + UPN from the mirror everywhere a person is shown (GUID relegated to a copyable detail, the COM-253 modal convention).
4. **Justification never shown**: display it prominently in every kind and mode — it's half of what an approver is judging, and on expedited requests it's the incident context the validator needs.

Same panel serves the validation page (shared editors per COM-260) — apply the layout and all four fixes there too, don't fork the component.

Refs: COM-260 (the surface + edit-diff semantics), COM-262/277 (owner field + required rules), COM-240 (raise forms whose validation the editors mirror), ADR 0022.