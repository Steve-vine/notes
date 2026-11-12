---
id: 01M77MWJXKT8ZQYER1X7QPM4KF
created: 2026-11-12T10:29:37.331696Z
updated: 2026-11-12T14:26:22.467287Z
type: task
title: A done SAP entry's name can be corrected, with a reason, the old name kept beside the record
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1750
sprint: spsp226
comments:
- id: 01M77YFAY9H7FKMDKAD5C621BS
  author: Steve Vine
  at: 2026-11-12T13:17:08.933708Z
  text: |-
    Built: PR #1747 (auto-merge set; on the chain, migration 0822).

    What you'll see:
    - On a done plan entry the button now reads "Correct" (was "Correct outcome"). Its form's first field is Title, filled with the current title; changing it needs a reason, like any correction.
    - The entry's corrections list shows "Title: old → new" beside the reason, who and when; the owner's portal shows the same list.
    - Same title and nothing else changed → still "Nothing to correct". A blank title is refused.
    - Only people who could already correct a done entry can change its title (a plan reader is refused; the portal owner has no Correct). Cancelled entries can't be corrected.
    - The new title belongs to that entry only; the rest of its series keeps theirs.
    - It shows on the plan, Coverage, Evidence of operation, its files in Audit ▸ Evidence ("Plan · <title>"), new exports and the portal. Audit packs and exports already built keep the old name.
    - Polaris's correct-entry tool takes a title.

    Choices to know about:
    - Labelled "Title", not "Name", to match the entry's own form and the plan's column (one-word change if you'd prefer "Name").
    - A title correction doesn't count as "changed since approval": the sign-off snapshot keeps the title as approved. ADR 0115 has an appended amendment saying so.
    - Corrections keep before/after in their own columns, so a small migration adds the title's before and after; earlier corrections show nothing for it.

    Checks: backend lint, format, types and unit suite pass; SAP correction/cancel integration tests (two new), assistant SAP and exercise tests pass; frontend lint, types, format and SAP page tests pass (new correct-title test); OpenAPI regenerated. Browser walk-through to come in the pre-UAT pass on staging.
- id: 01M782E343ZGX7W5QAEPRBGBCQ
  author: Steve Vine
  at: 2026-11-12T14:26:22.467031Z
  text: |-
    Pre-UAT (staging 80ffc250, E2E Test Company): Passed.
    - Created "E2E pre-UAT 1750 entry" (SAP-71), marked done, Correct → Title "E2E pre-UAT 1750 entry renamed", reason "E2E pre-UAT title correction" → "Correction saved". Heading and trail show the new name; Corrections reads "12 Nov 2026 · E2E Admin A / E2E pre-UAT title correction / Title: E2E pre-UAT 1750 entry → E2E pre-UAT 1750 entry renamed"; history has a matching row; the plan list, timeline and Audit ▸ Evidence ("Plan · E2E pre-UAT 1750 entry renamed") all show it.
    - Nothing changed: the form keeps Save correction greyed out (a trailing space included), so the message can't be reached from the screen; sent straight to the server it answers "Nothing to correct".
    - Viewer: can't open the plan at all, so no Correct; a direct request is refused (403).
    - No console errors. SAP-70 untouched.
    Screenshots: ~/compass-uat/spsp226/COM-1750/
assignee: steve
label:
- improvement
priority: low
task_status: review
---
Steve, testing on staging (2026-11-12).

**Today:** a done SAP entry is frozen (ADR 0115 §5). **Correct** covers only the outcome, the completion date, and an exercise's result and recovery times. A done entry with the wrong name can't be put right.

**What it should do:** the name joins what **Correct** can change on a done entry.
- It's the same correction as today: a reason is required, and the correction is kept beside the record with the name before and after, who made it and when.
- The new name shows everywhere the entry is named: the plan, coverage, Evidence of operation, its evidence in Audit ▸ Evidence, exports, and the owner's portal. Audit packs already built keep the name they were built with.
- Only the people who can correct a done entry today can correct its name.
- Correcting the name changes only this entry. Other entries in its repeating series keep their names, as other corrections already work.
- Cancelled entries stay as they are: no name correction.
- Polaris's correct-entry tool (MCP) takes the name too.

**Done when:**
- on a done entry, Correct → change the name → give a reason → the new name shows on the entry, the plan and its evidence;
- the corrections list shows the name's before and after, with the reason;
- a Correct with the same name and nothing else changed still says "Nothing to correct";
- someone without the right to correct can't change the name;
- there are no errors in the browser console.

Amend ADR 0115 §5 (what a correction may change). The API change puts this on the chain: `SapCorrectIn` gains `title`, the correction keeps it before and after, and the OpenAPI and `schema.d.ts` are regenerated.