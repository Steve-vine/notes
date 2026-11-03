---
id: 01M6HKACNAZW0QKYH6H1EFMPKP
created: 2026-11-03T20:58:55.018999Z
updated: 2026-11-03T21:08:15.376211Z
type: task
title: Decisions show who created them and who accepted or declined them — on the decision page and the Decisions list, filled in for existing decisions from the activity log
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1553
sprint: snyzymp
assignee: steve
label:
- improvement
priority: medium
task_status: active
---
Sprint "Initiatives - New Feature". Raised by Steve on 2026-11-03: decisions don't show who created them or who approved them.

## What people see

- The **decision page** shows **Created by** (name and date). Once a decision has moved on from proposed, it also shows **Accepted by** or **Declined by** (name and date).
- A decision created directly as Accepted shows its creator as the one who accepted it.
- A superseded decision keeps who accepted it. It also says which decision superseded it and who accepted that one.
- The **Decisions list** gains a "Decided by" column, sortable, following the screen conventions.
- **Existing decisions** get the same, taken from the activity log: who created each, and who changed its status to accepted or declined.
- Decisions with no person against them say **"Imported"**. That covers the seeded ones and anything from before the log.
- A deleted account still shows the name it had (the activity log keeps it).

## Notes (technical)

- `decision_records` already has `created_by`, and the table is audited (`db/audit.py`). It has no record of who decided.
- Add `decided_by` (FK to users, SET NULL) and `decided_by_name` (a snapshot, like `activity_log.actor_name`).
- Set both whenever the status moves to accepted or declined, whether on create or on update.
- **Backfill in the migration** from the earliest `activity_log` row for each decision whose changes set the status to accepted/declined. Use the create row if it was created that way. Use `postgresql.ENUM(create_type=False)` if you touch the status enum.
- Reproduce the backfill against a populated DB locally (fresh-DB CI won't exercise it).
- Add `created_by_name`, `decided_by_name` and `decided_at` to `DecisionOut`. Regenerate `schema.d.ts`.
- Show the new fields in the MCP `posture_get_decision` / `posture_list_decisions` output.

**Chain:** on the chain (migration + API).

**Done when:** on staging, as admin in E2E Test Company:
- a new decision shows Created by;
- accepting it shows Accepted by, with your name and today's date;
- an existing seeded decision shows "Imported";
- the Decisions list sorts by Decided by.