---
id: 01M3WFQSRRB2SPE5QVMJXJWHTB
created: 2026-10-01T19:40:53.400613Z
updated: 2026-10-02T08:51:33.347163Z
type: task
title: A gap says who raised it and when it was closed — and "Closed this month" counts by the close date
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 831
sprint: s0zzctz
comments:
- id: 01M3WMZDW5DSC0GNHB26ZVGRPW
  author: Steve Vine
  at: 2026-10-01T21:12:26.244856Z
  text: |-
    Merged: PR #835 (c71f609).

    - Who raised a gap, and when: the gap's page says "Raised by Steve Vine · 25 Sep 2026" under its title; the Gaps register and a control's Gaps tab show the same line under each gap's title. If the raiser's account is gone it reads "Raised 25 Sep 2026". The register's search also finds a gap by its raiser's name.
    - When a gap was closed: moving a gap to Complete or Cancelled records the date; reopening clears it; closing again records the new one. The gap's page shows "Closed 3 Oct 2026" at the bottom of its Progress card.
    - "Closed this month" counts by that date, so editing an old closed gap no longer moves it into this month.
    - Existing closed gaps get their date from the activity history (the last time they became Complete or Cancelled); any with no such history fall back to their last change, as before.

    Three things worth knowing:
    - The lists say "Raised by <name> · <date>" rather than the prototype's bare "<name> · <date>", because each row already shows an owner and a target date in that shape and the bare form read as the owner.
    - Moving a closed gap between Complete and Cancelled counts as closing it again and records a new date.
    - The admin Activity log now shows a "Closed at" line beside the status change when a gap is closed.

    To check on staging: Posture ▸ Gaps — the raised line on each row; open a gap, set it to Complete and look at the Progress card; edit the title of an old closed gap and confirm "Closed this month" does not change.

    Technical: migration 0220_gap_closed_at adds gaps.closed_at and backfills it from activity_log in one statement; the rule lives on the model (a status validator), never taken from a request. GapOut gains created_by and closed_at. The backfill is tested against a database populated at the previous revision, with and without history.
assignee: steve
label:
- improvement
priority: medium
task_status: done
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