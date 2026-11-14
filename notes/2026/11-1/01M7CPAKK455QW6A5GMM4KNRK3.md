---
id: 01M7CPAKK455QW6A5GMM4KNRK3
created: 2026-11-14T09:30:57.508433Z
updated: 2026-11-14T10:26:12.506351Z
type: task
title: 'Rename a column in a check''s table: a display name for a messy field (custom_fields.closure_code → Closure code), kept with the check and shown everywhere its evidence appears'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1814
sprint: spsp226
assignee: steve
label:
- improvement
priority: medium
task_status: active
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