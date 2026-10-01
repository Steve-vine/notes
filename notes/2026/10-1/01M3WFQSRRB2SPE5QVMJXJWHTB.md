---
id: 01M3WFQSRRB2SPE5QVMJXJWHTB
created: 2026-10-01T19:40:53.400613Z
updated: 2026-10-01T19:42:47.163702Z
type: task
title: A gap says who raised it and when it was closed — and "Closed this month" counts by the close date
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 831
sprint: s0zzctz
assignee: steve
label:
- improvement
priority: medium
task_status: todo
---
Follow-up from sprint 65 (COM-803, COM-809). The redesigned screens wanted two facts a gap doesn't show today:
- the control page's Gaps tab, and the prototype's gap rows, show who raised each gap;
- the Gaps register's "Closed this month" card counts by the gap's *last change*. Editing an old closed gap therefore moves it into this month.

## What people see

- **Who raised a gap and when.**
  - **Where:** the gap's page shows "Raised by Steve Vine · 25 Sep 2026" under its title.
  - **Lists:** a control's Gaps tab and the Gaps register show the raiser beside each gap, as the prototype does ("Steve Vine · 25 Sep 2026").
- **When a gap was closed.**
  - **Setting it:** moving a gap to Complete or Cancelled records the date. Reopening it clears the date, and closing it again records the new one.
  - **Where:** the gap's page shows "Closed 3 Oct 2026" in its Progress card.
- **"Closed this month"** on the Gaps register counts gaps closed this calendar month by that date. Editing an old closed gap no longer moves it.
- **Existing closed gaps** get their close date from the activity history (when their status last became Complete or Cancelled). Any with no history fall back to their last change, as today.

## Notes (technical)

- **Who raised it is already stored.**
  - The only creator of gaps (`api/v1/gaps.py` ~80) sets `created_by` from the `ActorMixin`; `GapOut` just doesn't expose it.
  - Add `created_by` (id) and `created_at` to `GapOut`. The frontend resolves names with `useUserNames` as owners already do.
- **Close date.**
  - New column `gaps.closed_at` (timestamptz, nullable), via an append-only migration with an id ≤ 32 chars.
  - The PATCH route sets it on a transition into complete or cancelled and clears it on a transition out. Set it server-side, never from the client.
  - **Backfill in the migration:** for each closed gap, take the latest activity-log entry (ADR 0023) whose changes set `status` to complete or cancelled; otherwise `updated_at`.
    - Read the activity-log shape before writing the SQL.
    - Avoid f-strings into `sa.text()` (semgrep).
    - Test the backfill against a populated DB, not just a fresh one ([[migrations-fresh-db-blindspot]]).
  - Expose `closed_at` on `GapOut`, and regenerate `schema.d.ts`.
- **Frontend:**
  - the GapsPage "Closed this month" card and its filter switch to `closed_at`;
  - GapDetailPage shows Raised by and Closed;
  - the control page's Gaps tab and the register rows show the raiser.
- **Tests:**
  - integration: closed_at set and cleared on transitions, and the backfill on a seeded closed gap with and without history;
  - vitest: the card counts by close date, and the raiser is shown.

**Done when:** on staging, a gap shows who raised it, closing one shows its close date, and "Closed this month" doesn't change when an old closed gap is edited.