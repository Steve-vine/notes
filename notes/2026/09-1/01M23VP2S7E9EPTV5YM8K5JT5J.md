---
id: 01M23VP2S7E9EPTV5YM8K5JT5J
created: 2026-09-09T19:52:57.383103Z
updated: 2026-09-10T11:11:46.262814Z
type: task
title: Risks and gaps gain a reference — R-14, G-7 — one sequence each across every company
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 645
sprint: sa2t9sq
comments:
- id: 01M25B25JXF881JWBEEEM44J13
  author: Steve Vine
  at: 2026-09-10T09:40:56.538017Z
  text: |-
    Done — merged to main in PR #652 (https://github.com/Steve-vine/compass/pull/652), squash 06b59f3.

    Every risk and gap now carries a reference: R-14, G-7. Allocated when the record is created from one Postgres sequence per entity across every company; never reused, never renumbered. Existing records were numbered in creation order by migration 0176 (soft-deleted ones included, so a deleted record leaves its hole); the backfill is pinned by a populated-database test.

    Where it shows: Ref is the first, numerically sorted column on the Risks and Gaps registers; the risk and gap page headers read "R-14 · title"; the ref leads on a control's gaps, a risk's related gaps, a gap's risks, a vendor's linked risks, the pickers that link them, the Actions queue, the activity trail, the dashboard's recent-activity feed and search results. Both register exports gain Ref as the first column (CSV and PDF). Search treats "R-14", "r14" and "14" as a citation and ranks the exact hit first; a gap search result now opens the gap's own page.

    Smoke test: Risks and Gaps registers (Ref column, sort by it), a risk page and a gap page header, search "R-1" / "G-1", export both registers. Vendors were left out as agreed; the decision number is COM-644.

    To deploy to staging once all three sprint tasks are in review.
assignee: steve
label:
- improvement
priority: medium
task_status: done
---
A decision has a number; a risk and a gap have only a title. A risk register is the one thing in Compass an auditor reads line by line, and "risk 14" is how a line gets cited in a meeting, an email or a finding. Two risks with similar titles are indistinguishable in an export, a gap raised twice on the same control cannot be told apart, and a title can be edited so nothing stable exists to cite.

**The rule.** Every risk and every gap carries a reference, allocated when the record is created, never reused, never renumbered. Deleting one leaves a hole, which is itself an audit fact. **One sequence across all companies** for each entity (Steve, 2026-09-09: a single report covering every company is a plausible future, and per-company numbers would collide in it). Format `R-14` and `G-7`: a short prefix, a plain number, no zero padding. Existing records are numbered in creation order.

**Backend:**

- `number: int` on `Risk` and `Gap` — not null, unique, indexed, `server_default` from a Postgres sequence (`risk_number_seq`, `gap_number_seq`) so allocation is atomic and gapless-enough under concurrent creates. The migration creates the sequences, adds the column nullable, **backfills existing rows ordered by `created_at` then `id`**, sets each sequence to max+1, then makes the column not null. This is the populated-database kind of migration CI never exercises — reproduce against a copy of staging's data before it goes near staging.
- `ref: str` on `RiskOut` and `GapOut`, derived (`f"R-{number}"`), alongside `number` for sorting. The prefix lives in one place per entity, not in the frontend.
- **Search** (`api/v1/search.py`): "R-14", "r14" and "14" all find the risk; same for gaps. Strip a leading prefix and match the number exactly before the fuzzy pass.
- **Exports** (`api/v1/reports.py`): the risk register and gap register gain `Ref` as the first column, CSV and PDF.
- **Activity summaries**: wherever the one-liner names a risk or gap by title, it says the ref first ("R-14 · Loss of the main office").
- Addresses do **not** change: `/risks/{id}` and `/gaps/{id}` stay on the id. Routing by ref is possible now that the sequence is global, and is a follow-up if anyone wants it — not this task.

**Frontend:**

- One small `RefText` (or the pill family's equivalent) that renders a reference in a stable monospace-ish weight, used everywhere below so it reads the same on every screen.
- **Registers**: `Ref` as the first, sortable (numeric) column on `RisksPage` and `GapsPage`, before the linked title — the Decisions register is the pattern.
- **Detail pages**: the page header carries the ref before the title (`R-14 · Loss of the main office`), per the header conventions in `brief/information-architecture.md`.
- **Wherever a risk or gap is named elsewhere**: the linked-risk chips on a control, gap rows on a risk, risk rows on a gap, the Actions queue, the Dashboard's gap counts if they list any, search results. The ref leads.
- Regenerate `schema.d.ts` (the drift script).

Tests: the migration's backfill order on a seeded populated DB; two creates get consecutive numbers; a delete leaves a hole; search by ref; export column.

Not in this task: vendors (left for now, Steve 2026-09-09), and changing what the decision number looks like — that is its own task and shares `RefText`.