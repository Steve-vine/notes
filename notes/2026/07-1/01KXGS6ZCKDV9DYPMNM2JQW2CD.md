---
id: 01KXGS6ZCKDV9DYPMNM2JQW2CD
created: 2026-07-14T17:01:23.73198902Z
updated: 2026-07-14T18:32:39.955918685Z
type: task
title: 'Treatment plans: model + API'
task_status: done
label:
- brief
priority: medium
assignee: steve
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 38
sprint: sq2tcpq
comments:
- id: 01KXGS7AYETEZ7SSKR1YWESW2F
  author: Steve Vine
  at: 2026-07-14T17:01:35.566591627Z
  text: |-
    [Migrated from Linear — Steve Vine, 2026-06-17 12:45 UTC]
    PR open: https://github.com/Steve-vine/compass/pull/35

    **Delivered** (all four checklist items)
    - **`TreatmentPlan` model** (risk-scoped) + migration `0013` — type (mitigate/accept/transfer/avoid), owner, due date, status (open/in_progress/done/cancelled).
    - **`/risks/{id}/treatments` API**: create / list (status filter) / patch (close via `status=done`) / soft-delete.
    - **Accept-gate** (ADR 0018): `type=accept` requires residual ≤ appetite (else 422) + owner + rationale, reusing `core/risk_scoring` (single-sourced with the register); re-checked on PATCH.
    - **Risk status stays manual** (the agreed approach) — treatments don't auto-advance it.

    **Verification**: ruff/format/mypy clean; migration round-trips + `alembic check` clean; **full integration suite 90 passed** (3 new). Backend-only — treatments surface in the register UI (DEV-451), which this unblocks.
blocked_by:
- 01KXGS67RWK8T0Q5A0J7MVPMTW
---
How each risk is treated (ADR 0012) — turning the register into a work-prioritisation tool.

- [ ] `TreatmentPlan` model: `risk_id`, `type` (`mitigate` / `accept` / `transfer` / `avoid`), `description`, `owner_id`, `due_date`, `status` + migration.
- [ ] API nested under a risk: create / list / update / close treatment plans (admin/editor).
- [ ] Acceptance path: residual **above appetite** (<issue id="f34a32da-81d5-4ab5-8aa0-4e6dd765b954" href="https://linear.app/stevevine/issue/DEV-448/risk-scoring-scales-appetite-rubric">DEV-448</issue>) must be treated/escalated; **at or below** may be formally `accept`-ed with an owner + rationale recorded.
- [ ] A risk's overall status reflects its treatment progress (open → treated → accepted/closed) — keep history.

Refs: ADR 0012, 0015, 0018. Depends on: Risk register model + API.

---
*Migrated from Linear [DEV-450](https://linear.app/stevevine/issue/DEV-450/treatment-plans-model-api) · created 2026-06-17 · completed 2026-06-17*  
*Related to (Linear): DEV-448*