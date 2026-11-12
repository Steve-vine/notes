---
id: 01M77E815QEPE64FXC0SH4XKNG
created: 2026-11-12T08:33:32.343107Z
updated: 2026-11-12T14:26:10.664437Z
type: task
title: After "Delete permanently", you go back to the Archived list with the deletion confirmed, not to a "Not found" page
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1747
sprint: spsp226
comments:
- id: 01M77X44VDMCVNHX8BPAE4Z5R5
  author: Steve Vine
  at: 2026-11-12T12:53:33.677394Z
  text: |-
    Built: PR #1744 (auto-merge set, frontend only).

    What you'll see: after Delete permanently… on an archived piece's page, you go back to where you came from with "Deleted for good":
    - Audit ▸ Evidence ▸ Archived if you came from the register, a link or a bookmark (your filters and sort kept if you were already on Archived);
    - the record or control page if you opened the piece from there.
    The deleted piece isn't in the list, there's no "Not found" page, and Back doesn't land on the deleted piece.

    Cause: the delete refreshed everything, including the piece itself, which then came back as Not found and took the dialog's "go back" step with it. The piece is now dropped rather than refreshed.

    Delete permanently exists only on a piece's own page; the register's "Download and delete…" and a vendor's delete are separate and unchanged.

    Checks: lint, types and format clean; two new tests (from the register → Archived; from a record → back to the record), both failing on the old code; full frontend suite green apart from two unrelated flakes that pass alone. To be checked in the browser in the pre-UAT pass after the staging deploy.
- id: 01M782DQK80GM9AZEXPAGM57S0
  author: Steve Vine
  at: 2026-11-12T14:26:10.664263Z
  text: |-
    Pre-UAT (staging 80ffc250, E2E Test Company, Admin A): Passed.
    - From the register: opened an archived piece from Audit ▸ Evidence ▸ Archived → Delete permanently… (reason, typed the name) → landed on Archived with "Deleted for good"; the piece gone (5 → 4 archived); no "Not found". A piece opened from the Register tab also landed on Archived.
    - From a record: a plan entry's file links only download, they don't open the piece's page, so the "came from a plan entry" case can't arise today. Used a control instead: uploaded a file to SAP-71, linked it to ACC.3, opened it from Audit ▸ Evidence ▸ By core control ▸ ACC.3, archived and deleted it for good → landed back on ACC.3's evidence page with "Deleted for good", the piece gone.
    - No console errors on delete. (Archiving from a piece's own page logs one unrelated error, logged separately.)
    Screenshots: ~/compass-uat/spsp226/COM-1747/
assignee: steve
label:
- improvement
priority: low
task_status: review
---
Found in the COM-1738 pre-UAT pass on staging (2026-11-12).

**What happens:** on an archived piece's page in Audit ▸ Evidence, Delete permanently… works and shows "Deleted for good". The page then reloads the piece it was showing, which no longer exists, so you're left on "Not found — E2E Test Company holds no such evidence, or it isn't yours to see."

**What it should do:** once the delete succeeds, return to where you came from: Audit ▸ Evidence ▸ Archived, or the record's page if you came from a record. "Deleted for good" shows there, and the deleted piece no longer appears in the list.

**Done when:** deleting an archived piece from its page lands you on the Archived list (or the record you came from) with the confirmation. No "Not found" page, and no errors in the browser console.