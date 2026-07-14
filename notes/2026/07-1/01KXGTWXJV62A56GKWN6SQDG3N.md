---
id: 01KXGTWXJV62A56GKWN6SQDG3N
created: 2026-07-14T17:30:51.355628681Z
updated: 2026-07-14T17:31:26.678595276Z
type: task
title: Mark for Review
label:
- feature
task_status: done
priority: medium
assignee: steve
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 102
sprint: sg31rps
comments:
- id: 01KXGTXFM2FTEZZZTFFT8ME2SZ
  author: Steve Vine
  at: 2026-07-14T17:31:09.826382047Z
  text: |-
    [Migrated from Linear — Steve Vine, 2026-06-30 16:32 UTC]
    ## Completion write-up

    **PR:** https://github.com/Steve-vine/compass/pull/105 · branch `dev-718-mark-for-review`

    ### What was built
    A red **"Review"** pill on content that's within its review window, flagged at **14 days**.

    Per planning, "Review" is a **derived overlay, not a stored status** — a published item under review is still the live version, and ADR 0032 keeps "due for review" out of the `ContentStatus` enum. So **no new enum value and no migration**:
    - `core/config`: `reminder_lead_days` 7 → **14** (the brief's "within 14 days"; shared by the reminders bell, the actions queue, and this overlay).
    - `core/due`: `is_review_due(next_review_at, today)` reusing `review_lead_window`, so the pill and the `content_review_due` notification agree on what's due (incl. overdue).
    - `api/v1/schemas`: computed **`review_due`** flag on `ContentItemOut` (inherited by `ContentItemDetail`); regenerated `schema.d.ts`.
    - frontend: `review → red` in `statusColors`; content list + detail render the pill from `review_due`.

    ### Decisions made mid-session
    - **Derived overlay over stored status** (your call) — keeps the `published` lifecycle intact and avoids an `ALTER TYPE` enum migration; the API exposes the flag so the frontend doesn't hardcode the 14-day window.
    - **Window bump applied globally** (`reminder_lead_days` 7→14, your call) — verified it leaves `test_reminders`/`test_actions` green (their fixtures use 2020/2999 and ±3/30-day dates, clear of the 8–14-day gap).
    - **Pill uses the existing `StatusPill`** (`variant="light"`, tinted red) for consistency with the app's other red statuses — not a bespoke filled badge.

    ### Open questions / follow-ups
    - **Reviewer-specific notification is DEV-719** — out of scope here. The existing **owner**-targeted `content_review_due` notification continues, and now fires at 14 days via the window change.
    - The status **filter** stays draft/published; "Review" isn't a server-side-queryable status (it's a derived overlay). If filtering by "due for review" is wanted later, that's a small follow-up (client-side, or a `review_due` query param).

    ### Files changed
    `git diff --stat origin/main...dev-718-mark-for-review` — 10 files, +112/−8:
    ```
    backend: core/config.py, core/due.py, api/v1/schemas.py, tests/test_content.py, tests/test_due.py (new)
    frontend: api/schema.d.ts, components/statusColors.ts(.test.ts), pages/ContentPage.tsx, pages/ContentDetailPage.tsx
    ```

    ### Test status
    - Backend: `ruff` ✓ · **`mypy src`** ✓ · `tests/test_due.py` unit ✓ · `test_content.py`/`test_reminders.py`/`test_actions.py` integration (testcontainers) ✓ **32 passed** (new `review_due` cases: within / overdue / beyond / draft / undated).
    - Frontend: `format:check` ✓ · `eslint` ✓ · `vitest` **126 passed** (new review→red colour case) · `tsc -b + vite build` ✓.
- id: 01KXGTY02PXBSG7R7QR1BNTF77
  author: Steve Vine
  at: 2026-07-14T17:31:26.678422688Z
  text: |-
    [Migrated from Linear — Steve Vine, 2026-06-30 16:48 UTC]
    PR #105 merged (`main` `147970c`) and **deployed live** — helm rev **51**, image `main-20260630-1642`, all workloads Ready, `/readyz` + `/` 200.

    The **"Review" overlay pill** is now live: a *published* content item whose `next_review_at` is within **14 days** (incl. overdue) shows a red "Review" pill in place of "Published" on the Content list + detail pages. Derived (`ContentItemOut.review_due`), so the stored status stays `published`. Example: **Access Control Policy** (next review 2026-07-07) will now show it. The `reminder_lead_days` window was raised 7→14 to match (this also widens the existing owner reminders + the M16 Actions "upcoming review" window).

    ⚠️ The **"notify the Reviewers"** half of this issue was **not** in #105 — split out as **DEV-728** (needs a definition of "Reviewers"; today only the content *owner* is notified, via the M5 Beat job). Closing this as the visual/pill scope; notification tracked in DEV-728.
---
When a Content is within 14 days of the Next Review date, change its status to 'Review' with a red pill.

Add a notification for the Reviewers to review that content.

---
*Migrated from Linear [DEV-718](https://linear.app/stevevine/issue/DEV-718/mark-for-review) · created 2026-06-29 · completed 2026-06-30*  
*Related to (Linear): DEV-719, DEV-728*