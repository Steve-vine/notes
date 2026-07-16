---
id: 01KXK86HERPE453WK26R20JMEB
created: 2026-07-15T16:01:46.968592191Z
updated: 2026-07-16T18:50:46.359985481Z
type: task
title: Request-more-info loop (onboarding)
assignee: steve
label:
- brief
priority: medium
task_status: done
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 183
blocked_by:
- 01KXK86E3SAMMHM8YJBCDCRN6J
comments:
- id: 01KXNHVR86Q5XN0585DE84FVHF
  author: Steve Vine
  at: 2026-07-16T13:29:08.102558357Z
  text: |-
    Build complete on feature/com-183-info-loop (stacked on COM-182); PR #174 open against main, branch merged to staging. This closes the Sprint 28 build — all six Phase 3 briefs are on staging with PRs #169–#174 open, stacked in dependency order for the batch release.

    Decisions: resubmission keeps the approver's comment on the reset approval (it is the question being answered); the stale pending notification is deleted-and-recreated so the approver gets a fresh unread "resubmitted" notification instead of being dedup-suppressed.

    Local verification: ruff + format, mypy src, 88 unit + 12 integration, 187 Vitest, build, Semgrep clean.
- id: 01KXP48P6Q07WJ7VA5VC0SSV04
  author: Steve Vine
  at: 2026-07-16T18:50:46.359778825Z
  text: 'Released: Sprint 28 batch release complete. PRs #169–#174 squash-merged to main in dependency order (a72be15 → 06c1d7e), each stacked branch rebased onto main as its predecessor landed and re-verified by PR CI before merging. Feature branches deleted; staging reset to main. Production deploy (migrations 0041–0045, with the 0044 postgresql.ENUM fix) triggered on the final main push — all six Phase 3 briefs (COM-178 → COM-183) are Done. This closes Sprint 28 (Vendor Management - Phase 3).'
sprint: sxngp10
---
Phase 3 (ADR 0039 §6): the info-requested round-trip on onboarding requests.

- [x] Approver requests info (comment required) → request `info_requested`, requester notified (in-app + email) — landed with COM-182's decide endpoint.
- [x] Requester edits answers and resubmits [require_vendor_submit, own requests only — 403; info_requested only — 409] → answers replaced (re-validated, fresh prompt snapshots), info-requested approvals reset to `pending` (approver's question kept visible), stale pending notifications replaced so approvers are re-notified, status re-derived.
- [x] UI: info-requested banner + the approvers' comments inline on the request detail; Edit & resubmit modal pre-filled from the raw stored `answer_json`.
- [x] Tests: one end-to-end integration test covering ownership guard, reset semantics, both notification directions (fresh approver notification, deduped count), 409 guard, and the closed loop through to vendor activation.

Branch `feature/com-183-info-loop` (stacked on COM-182), PR #174. Ref: ADR 0039 §6.