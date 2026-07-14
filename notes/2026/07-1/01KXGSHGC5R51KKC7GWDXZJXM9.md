---
id: 01KXGSHGC5R51KKC7GWDXZJXM9
created: 2026-07-14T17:07:08.805768268Z
updated: 2026-07-14T17:07:08.805768268Z
type: task
title: Linked-decision surfacing on control/risk/content
label: brief
task_status: done
priority: medium
assignee: steve
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 49
---
Surface the decisions that govern a control / risk / content item on those detail pages (split from <issue id="c20a24b7-29e6-4b57-92d2-1709451f1441" href="https://linear.app/stevevine/issue/DEV-463/decision-records-ui-linked-decision-surfacing">DEV-463</issue> — the ADR 0017 integration point). Decision↔target links already exist in the API (`POST`/`DELETE /decisions/{number}/links`); this adds the reverse view + per-page panels.

- [ ] **Backend**: a query-by-target filter on the decisions list — `GET /decisions?target_type=&target_id=` (resolve the polymorphic `DecisionLink` back to decisions) + tests.
- [ ] **Frontend**: a "Decisions" panel on `ControlDetailPage`, `RiskDetailPage`, `ContentDetailPage` listing linked decisions (→ decision detail), with **link/unlink** for admin/editor (a decision picker + the existing links endpoints).
- [ ] Reads open; link/unlink gated to admin/editor. Tests mirror existing detail-page tests.

Refs: ADR 0013, 0017. Depends on: Decision records UI — section + author (<issue id="c20a24b7-29e6-4b57-92d2-1709451f1441" href="https://linear.app/stevevine/issue/DEV-463/decision-records-ui-linked-decision-surfacing">DEV-463</issue>).

---
*Migrated from Linear [DEV-466](https://linear.app/stevevine/issue/DEV-466/linked-decision-surfacing-on-controlriskcontent) · created 2026-06-17 · completed 2026-06-17*