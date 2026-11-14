---
id: 01M7CPAKK455QW6A5GMM4KNRK3
created: 2026-11-14T09:30:57.508433Z
updated: 2026-11-14T11:53:39.791658Z
type: task
title: 'Rename a column in a check''s table: a display name for a messy field (custom_fields.closure_code → Closure code), kept with the check and shown everywhere its evidence appears'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1814
sprint: spsp226
comments:
- id: 01M7CYFRSQ6ZHFMB2JDJ3BV4WW
  author: Steve Vine
  at: 2026-11-14T11:53:35.283971Z
  text: |-
    Built — PR #1814 (7fc3a5de). On the chain, migration 0849 (merges after 1817 → 1815). ADR 0142 amended (2026-11-14).

    What you now see:
    - Every column header in a check's table has a small menu: Rename… (pre-filled, up to 80 characters) and Reset to field name. Only people who can change checks get it.
    - A renamed column shows "Closure code" with custom_fields.closure_code beneath it in small grey text.
    - Names show on every check waiting for review (the new Review page), a new "What it collected last" table under a live check's Details on the control's Evidence tab (first rows of each account's latest capture), held captures, the fresh sample while editing reads, the readable page of every capture filed from now on, and the audit pack — its capture page uses the names and it now carries a table (CSV) beside the raw data, headers like "Closure code (custom_fields.closure_code)". The raw JSON keeps the service's own names.
    - Names given during review are kept when it's approved. A rename on a live check doesn't send it to Review or change what it reads; it goes into the check's history ("column type shown as 'Type of change'…"). A change already waiting for review takes the rename too, so approving it doesn't undo it.
    - Rules: trimmed, max 80, blank = field name; no two columns read the same (case-insensitive, and not another column's field name); a field that leaves the reads loses its name.
    - Polaris renames columns in chat (applies at once, even on a live check, and says what it renamed).

    Choices: pages already filed in the Evidence register stay as filed (they're evidence) — new captures and every audit pack use current names; the "What it collected last" table is new (a live check had no table to rename in); the audit pack's per-capture CSV is new (there was no CSV of a capture before). The no-rule check page from COM-1817 gets the names once #1810 merges (a few lines, after rebase).

    Tests: new tests for save/reset, names surviving approval, duplicate and over-80 refusals, live rename in history without Review, a waiting change keeping a live rename, names dropped when a field leaves the reads, Polaris renaming, page and CSV headers incl. a built audit pack; integration 35 passed; unit 2334 passed; ruff/mypy/eslint/tsc/prettier clean; schema.d.ts regenerated.

    For Steve on staging: rename a column on a real check → it shows on its next capture's page and in a freshly built audit pack.
assignee: steve
label:
- improvement
priority: medium
task_status: review
---
## What happened

On 2026-11-14, while reviewing checks, Steve found that the column headers in a check's table are the raw field names the service returns (e.g. `custom_fields.closure_code`). They're hard to read, for him and for an auditor. He asked for a simple **Rename** on a column header so he can enter a display name.

## What people see

1. **Rename on the header.** Every column header in a check's table has a small menu (or pencil) with **Rename…**. It asks for a display name, pre-filled with the current one, and saves it. **Reset to field name** puts the raw name back.
2. **The real field is never hidden.** A renamed column shows the display name, with the original field (`custom_fields.closure_code`) underneath in small grey text or on hover. Nobody has to guess what was really read.
3. **It belongs to the check, not the screen.** The name is saved with the check and used wherever that check's evidence is shown: the review page (COM-1813), the check's own page, each capture, the control's Evidence tab, and audit packs and exports (CSV headers, PDF). It's renamed once and shows the same everywhere.
4. **Renaming during review.** Names given while a check is waiting for review are kept when it's approved.
5. **Renaming a live check** doesn't send it back to Review and doesn't touch what's collected, because it changes how the evidence looks, not what's read. It's recorded in the check's history ("Column custom_fields.closure_code shown as 'Closure code'").
6. **Captured files are untouched.** The raw capture an auditor downloads keeps the service's own field names. The display name only changes how Compass labels it.
7. **Who:** anyone who can edit or approve checks for the company. Everyone else sees the names but has no Rename.
8. **Polaris** can rename columns in chat as part of changing what a check shows ("call that column Closure code"), saying what it changed. Same rules as on screen.

## Rules

- A display name is per check and per field path. The same field in another check keeps its own name.
- Blank means the raw field name. Names are trimmed and limited to 80 characters, and two columns in one table can't have the same display name.
- If a field disappears from the reads (the query is edited), its name goes with it. If it comes back, it starts from the raw name.
- Service-agnostic: no names built into the code for any service (ADR 0147 §9).

## Done when

- Rename and Reset work on the review page and on a live check's table, and the name shows on the check page, the captures, the control's Evidence tab and an exported audit pack.
- The original field is visible next to every renamed header.
- A live check's rename appears in its history and doesn't move it to Review.
- Polaris can rename a column in chat.
- There are tests for saving and resetting a name, names surviving approval, the duplicate-name refusal, and the export headers.

**On the chain:** the check needs somewhere to keep display names (a migration) and the API needs to carry them.