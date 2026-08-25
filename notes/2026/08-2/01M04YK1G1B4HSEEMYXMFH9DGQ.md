---
id: 01M04YK1G1B4HSEEMYXMFH9DGQ
created: 2026-08-16T09:31:34.273606Z
updated: 2026-08-25T18:43:23.039704Z
type: task
title: 'Review surface: read-only vendor view with per-engagement boxes and in-box decisions'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 224
sprint: sbph5q5
blocked_by:
- 01M04Y6BSFNQTTMB5ZVA3T23A7
comments:
- id: 01M055DNBRQ1K9GPFQP32HD6DR
  author: Steve Vine
  at: 2026-08-16T11:30:58.040433Z
  text: |-
    Implemented — PR #222 (originally #221; GitHub auto-closed that when COM-223's branch was deleted on merge, so it was reopened against main with the same commit).

    Built as specified, with one simplification worth flagging: **which engagement is "under approval" turned out to be one field, not a switch on the kind.** Every kind points at the engagement it is about — the initial one for `new_vendor`, the newly proposed one for `new_engagement`, the target for `amend_engagement` — so `request.engagement_id` answers it in all three cases. Your `amend_engagement` assumption holds: that box is highlighted and additionally renders the what-would-change diff, since the rules judged the projection.

    Your other assumption also stands, and I'd argue it more strongly: **all three decisions belong in the box**, not just Approve. An approver who can only agree from the surface that shows them the evidence will disagree somewhere else, or not at all. Reject and Request info require a comment — a refusal without a reason leaves the requester nothing to act on — which is exactly why they never fitted on a queue row.

    The highlight is `var(--mantine-primary-color-filled)` (a theme token, so both schemes hold), plus an "Under review" badge for readers who cannot rely on colour alone.

    **The old request-detail modal is gone**, not left beside this one. Everything it did renders here — justification, the info-requested resubmit flow, the approvals list, the historical answers — and the request row's own button opens the same view with nothing to decide on it. `AmendmentDiff` moved to its own module so the two callers share one definition of "what would move". Nothing lost a home, as you asked.

    Where the caller is not an approver for that area, or it is already decided, the box states which and offers no buttons.

    Four tests: the outlined box + read-only vendor fields, the comment-gated reject posting through the existing decide route, the informational rendering for a non-approver, and the amendment diff on the new surface.
assignee: steve
company: null
label:
- feature
priority: medium
task_status: done
---
Defines COM-223's (Review) button (Steve, 2026-08-16). Clicking Review on an approval sub-row opens a **read-only version of the vendor form** for the request's vendor, with the decision made in context:

- [ ] **Read-only vendor view** — the vendor detail presentation (details, criticality, data fields) with no edit affordances, using the COM-213 readable read-only styling. Opened from the Review button with the specific approval (request × area) in context.
- [ ] **One box per engagement** — engagements render as separate boxes (not combined into one card): scope, criticality, data types, data entities, residency, access, sub-processors, status.
- [ ] **The engagement under approval gets a highlight border**: the initial engagement for `new_vendor`, the newly proposed engagement for `new_engagement`. For `amend_engagement` (assumption 2026-08-16): the target engagement's box is highlighted and shows the proposed changes (reuse the what-would-change diff), since the rules judged the projection.
- [ ] **Decision buttons inside the highlighted box**, acting on the approval whose Review was clicked: **Approve**, plus **Reject** and **Request info** (assumption 2026-08-16 — both need a comment, as in the current modal; an approver must be able to decline from the same surface). Buttons only when the current user is an approver for that area and it's pending; otherwise the box is informational.
- [ ] Highlight border uses a theme colour token — legible in light and dark.
- [ ] After a decision: view reflects the new approval status; grouped list (COM-223) refreshes; derived request status may flip (approved requests leave the Open view).
- [ ] The old request-detail modal's remaining duties (justification text, info-requested resubmit flow) either render in this view or stay reachable — nothing loses a home.
- [ ] Tests: read-only (no writes possible from this surface except the decision), correct engagement highlighted per kind, decision gating (approver-only, pending-only), amendment diff shown.

Stacks on COM-223 (grouped list + Review stub).