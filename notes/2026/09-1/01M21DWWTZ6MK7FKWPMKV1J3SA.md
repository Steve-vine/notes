---
id: 01M21DWWTZ6MK7FKWPMKV1J3SA
created: 2026-09-08T21:13:31.743361Z
updated: 2026-09-09T07:20:46.479981Z
type: task
title: Gap status gains a real lifecycle — New, In progress, On hold, Under review, Complete, Cancelled — and the register opens on "All open"
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 625
sprint: sa2t9sq
blocked_by:
- 01M21D1W4ZJKHZ54H1D2EP25K7
comments:
- id: 01M21JAWT7TBTPN35P8SEWFVHC
  author: Steve Vine
  at: 2026-09-08T22:31:04.774985Z
  text: |-
    Done — PR #636 merged to main. Six statuses in lifecycle order (New, In progress, On hold, Under review, Complete, Cancelled); the enum's values are renamed in place (open→new, closed→complete) and the three newcomers added, so existing rows carry over with no data pass. Staging runs Postgres 16.4, where ADD VALUE inside the migration transaction is fine (nothing later in the chain uses the values). A new populated-DB test in test_upgrade_path.py drives 0169→0170 with the three old values in the table and asserts the rows.

    "Open" everywhere now means the four working states, read from OPEN_GAP_STATUSES on the model: the Actions queue and the dashboard's Open gaps tile/per-domain counts (the latter used to count only Open). The register's Gap status filter offers All open first and opens on it; clearing shows everything. Gap pills take their own colours (New red, In progress yellow, On hold orange, Under review blue, Complete green, Cancelled grey) via a new `color` prop on StatusPill, because the shared map already spends `new`/`in_progress`/`under_review` on other lifecycles. schema.d.ts regenerated; the data-model brief's Gap line updated. Awaiting the sprint deploy to staging for smoke test.
assignee: steve
label:
- improvement
priority: medium
task_status: done
---
Asked for by Steve while smoke-testing, 2026-09-08. Follows COM-624 (the pill in the same cell goes first — land that, then this).

## The statuses

A gap has three statuses today: Open, In progress, Closed. Replace them with six, in this lifecycle order:

1. **New** — the default for a newly raised gap
2. **In progress**
3. **On hold**
4. **Under review**
5. **Complete**
6. **Cancelled**

The order is the order in the picker, the order the Gap status column sorts by, and the order the register groups by. Complete and Cancelled are the two "done" states; the other four are "open" — outstanding work.

**Existing gaps.** Open → New. In progress → In progress. Closed → Complete. (Assumption: nothing marked Closed today was a cancellation; if that is wrong it is a one-row edit afterwards, not a reason to hold the change.)

## The filter

The Gap status filter on the register offers the six statuses, with **"All open"** as a first option and the default. All open shows New, In progress, On hold and Under review — everything except Complete and Cancelled. Picking a single status narrows to it. Clearing the filter shows everything, including the done states, as it does today.

## Everywhere else that reads "open"

Anything that today asks "is this gap still outstanding?" means the four open states, and anything counting "closed" means Complete or Cancelled:

- the Actions queue's gap items (outstanding gaps by owner)
- the dashboard's "Open gaps" tile and the per-domain open-gaps count — **today this counts only Open, not In progress** (a pre-existing quirk). Make it the four open states, which is what the label says.
- the gap page's picker and pill, and the control's Gaps box pill

## Colours

New red, In progress yellow, On hold orange, Under review blue, Complete green, Cancelled grey. Same palette family the other lifecycle pills use.

---

*Implementation notes.*

**Backend.** `models/gap.py` `GapStatus` — six members; keep snake_case values (`new`, `in_progress`, `on_hold`, `under_review`, `complete`, `cancelled`). Default `GapStatus.new` on the model and on `GapCreate` in `schemas.py`. A helper `OPEN_GAP_STATUSES` on the model replaces `_OPEN_GAP` in `core/actions/company.py` and the `== GapStatus.open` in `api/v1/dashboard.py:144`. `GET /gaps?status=` stays single-valued — "All open" is a client-side filter, as the filter already is.

**Migration.** Postgres enum `gap_status` (created in 0007). Rename in place — `ALTER TYPE gap_status RENAME VALUE 'open' TO 'new'`, `'closed' TO 'complete'` — then `ADD VALUE` the three newcomers. Rename keeps every existing row correct with no data pass. `ADD VALUE` cannot run inside a transaction on older Postgres — check the version g5 runs and use `op.execute` with `COMMIT` / autocommit block if needed. **Test the upgrade against a populated local DB, not just fresh-DB CI** (see the fresh-DB blind spot memory). Downgrade: renames reverse cleanly; the three added values cannot be dropped from a Postgres enum — downgrade re-creates the type (or is documented as one-way).

**Frontend.** `gaps/gap.ts` — `GAP_STATUS_OPTIONS`, `GAP_STATUS_LABELS`, `GAP_STATUS_COLORS` (typed off `Gap['status']`, so regenerating `schema.d.ts` drives the compiler to every gap). `components/statusColors.ts` `GAP_STATUS_ORDER` — the six in lifecycle order. `GapsPage.tsx` — the filter `Select` gets a sentinel `all_open` entry first and `useState('all_open')`; the row filter at ~line 154 treats it as "not complete, not cancelled". `GapDetailPage.tsx` picker picks up the options automatically.

**Contract.** `GapStatus` is in the OpenAPI schema — run the drift script and commit `schema.d.ts` in the same PR (the PR suite does not check drift; the main backstop does).

**Tests.** Backend: create defaults to `new`; actions queue includes on_hold/under_review and excludes complete/cancelled; dashboard count matches. Frontend: register default shows the four open states and hides the two done ones; sort by Gap status follows lifecycle order (COM-616 convention).