---
id: 01M04YK1G1B4HSEEMYXMFH9DGQ
created: 2026-08-16T09:31:34.273606Z
updated: 2026-08-16T09:31:34.273606Z
type: task
title: 'Review surface: read-only vendor view with per-engagement boxes and in-box decisions'
task_status: todo
assignee: steve
label: feature
priority: medium
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 224
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