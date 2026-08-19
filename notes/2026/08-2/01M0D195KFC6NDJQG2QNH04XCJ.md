---
id: 01M0D195KFC6NDJQG2QNH04XCJ
created: 2026-08-19T12:52:31.983206Z
updated: 2026-08-19T16:23:51.108119Z
type: task
title: Approval page — details permanently visible left, actions right, plus four field-rendering fixes
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 279
sprint: s5gwx0s
comments:
- id: 01M0DDC3J4AHJ208XP4CQ9CCV2
  author: Steve Vine
  at: 2026-08-19T16:23:51.107956Z
  text: |-
    Merged to main in PR #278. The approval/validation surface reworked:

    **Layout** — left panel always shows the full read-only request details (every field execution will use, justification prominent in every kind and mode); "Edit details" switches the same panel to the shared COM-260 editors (gate mode before approval, amend mode during validation — one component, never forked), with Save corrections / Discard. Right column: the decision (Approve/Reject/Cancel, Validate/Amend & validate) always visible, timeline beneath. Batch requests render per-subject blocks down the left.

    **Four field fixes**: group owner resolved (name + UPN) read-only with the picker only after Edit; joiners show Business role(s) with the resolved mapped-group list (Usage location kept, minor); mover/leaver subjects resolve to display name + UPN from the mirror with the GUID as a copyable detail (COM-253 convention); justification always shown.

    Backend: AccessSubjectOut gained presentation-only resolved_person + group_owners (one mirror query per response) — deliberately separate from the stored fields so the gate editors never round-trip resolution into a spurious gate edit.
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