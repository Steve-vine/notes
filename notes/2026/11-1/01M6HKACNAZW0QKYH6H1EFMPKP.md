---
id: 01M6HKACNAZW0QKYH6H1EFMPKP
created: 2026-11-03T20:58:55.018999Z
updated: 2026-11-04T00:22:06.837488Z
type: task
title: Decisions show who created them and who accepted or declined them — on the decision page and the Decisions list, filled in for existing decisions from the activity log
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1553
sprint: snyzymp
comments:
- id: 01M6HP2XDRFKTMV1RAPKJ7T7CK
  author: Steve Vine
  at: 2026-11-03T21:47:15.768655Z
  text: |-
    Done: PR #1567 merged (1384748e), migration 0767.

    What's there:
    - Each decision page shows **Created by** (name and date). Once a decision is past proposed, it also shows **Accepted by** or **Declined by**.
    - A superseded decision keeps who accepted it, and its "Superseded by" link says who accepted the newer one.
    - The Decisions list has a sortable **Decided by** column.
    - Polaris's decision answers include "created by" and "decided by".
    - Existing decisions are filled in from the activity log:
      - the creator comes from the decision's created entry;
      - whoever decided it is taken from the earliest status change to accepted or declined;
      - a decision with no such change was created that way, so its creator decided it.
    - Seeded decisions, which have nobody against them, read **Imported**.

    My calls:
    - Sending a decision back to proposed clears who decided it.
    - Editing an accepted decision's text doesn't change who decided it.

    To test on staging (after the sprint deploys), as admin in E2E Test Company:
    1. Create a decision: it shows Created by.
    2. Accept it: Accepted by shows your name and today's date.
    3. Check a seeded decision: it shows Imported.
    4. Sort the Decisions list by Decided by.
- id: 01M6HYYEQN0AVV3GB74WVRWEQ4
  author: Steve Vine
  at: 2026-11-04T00:22:06.837266Z
  text: |-
    Pre-UAT (staging 9c0b06a2, 2026-11-04, E2E Test Company): **Passed** (through the API; the Playwright browser wasn't connected this session).

    Steps and what I saw, as E2E Admin A:
    1. Created D-10: Created by "E2E Admin A", no decider while proposed.
    2. Accepted it: Accepted by "E2E Admin A", dated today.
    3. The backfill filled in all 9 existing staging decisions with who decided them, so none reads "Imported" on staging. Imported is covered by the automated tests.

    For you to look at in the browser: the Created by and Accepted by lines on a decision's page, and sorting the Decisions list by the Decided by column.
assignee: steve
label:
- improvement
priority: medium
task_status: review
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