---
id: 01KXGS7N1QZ67P89B6P8Q3CC6D
created: 2026-07-14T17:01:45.91113595Z
updated: 2026-07-14T18:32:39.974828562Z
type: task
title: Risk register & detail UI
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 39
sprint: sq2tcpq
blocked_by:
- 01KXGS67RWK8T0Q5A0J7MVPMTW
- 01KXGS6ZCKDV9DYPMNM2JQW2CD
comments:
- id: 01KXGS7ZD2K2TR1V2GJ9M7QA10
  author: Steve Vine
  at: 2026-07-14T17:01:56.514725167Z
  text: |-
    [Migrated from Linear — Steve Vine, 2026-06-17 13:06 UTC]
    PR open: https://github.com/Steve-vine/compass/pull/36

    **Delivered** (all four checklist items)
    - **RisksPage** — company-scoped browse with banded inherent/residual score badges, status, over-appetite flag; status/band/owner filters; New-risk modal.
    - **RiskDetailPage** — Details & scoring (inherent/residual Selects with live derived score+band badges), Mitigating controls (link/unlink → control detail), Related gaps (link/unlink), Treatment plans (add/close/delete) with the **accept-vs-appetite** path surfaced (Over-appetite badge + modal hint + API 422).
    - `src/risk/hooks.ts` + `riskStatusColor`; routing/nav wired; schema regenerated.

    Two UX defaults (per the plan): scoring via Selects (the 5×5 heat-map is DEV-452); owner via assign-to-me (no admin-only user picker).

    **Verification**: lint/typecheck/47 tests (8 new)/format/build — all green. Frontend-only; ships on the next image roll. M4 remaining: DEV-452 (dashboard/heatmap), DEV-453 (risk attachments).
assignee: steve
label:
- brief
priority: medium
task_status: done
---
The Risks section (ADR 0017 — the `/risks` nav item, currently a placeholder), per the selected company.

- [ ] Browse risks: table filterable by status / band / owner, with banded score badges (inherent + residual; Low/Med/High/Critical colours from the scales).
- [ ] Risk detail: 5×5 likelihood×impact scoring for inherent **and** residual (with the derived score/band), title/description, owner, status workflow.
- [ ] Linked **controls** (the Core controls that mitigate, → control detail) and **gaps** — link/unlink inline.
- [ ] Treatment plans: list + add/edit (type, owner, due date, status), with the accept-vs-appetite path surfaced.

Refs: ADR 0012, 0017, 0018. Depends on: Risk register model + API, Treatment plans.

---
*Migrated from Linear [DEV-451](https://linear.app/stevevine/issue/DEV-451/risk-register-and-detail-ui) · created 2026-06-17 · completed 2026-06-17*  
*Related to (Linear): DEV-453, DEV-452*