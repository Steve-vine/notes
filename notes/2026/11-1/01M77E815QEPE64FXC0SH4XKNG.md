---
id: 01M77E815QEPE64FXC0SH4XKNG
created: 2026-11-12T08:33:32.343107Z
updated: 2026-11-12T12:34:43.046506Z
type: task
title: After "Delete permanently", you go back to the Archived list with the deletion confirmed, not to a "Not found" page
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1747
sprint: spsp226
assignee: steve
label:
- improvement
priority: low
task_status: active
---
Found in the COM-1738 pre-UAT pass on staging (2026-11-12).

**What happens:** on an archived piece's page in Audit ▸ Evidence, Delete permanently… works and shows "Deleted for good". The page then reloads the piece it was showing, which no longer exists, so you're left on "Not found — E2E Test Company holds no such evidence, or it isn't yours to see."

**What it should do:** once the delete succeeds, return to where you came from: Audit ▸ Evidence ▸ Archived, or the record's page if you came from a record. "Deleted for good" shows there, and the deleted piece no longer appears in the list.

**Done when:** deleting an archived piece from its page lands you on the Archived list (or the record you came from) with the confirmation. No "Not found" page, and no errors in the browser console.