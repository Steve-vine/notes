---
id: 01M782ESV5BW2SE6ZH1RWYYFVW
created: 2026-11-12T14:26:45.73399Z
updated: 2026-11-12T20:45:30.450295Z
type: task
title: Archiving a piece of evidence from its own page logs no error in the browser
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1760
sprint: spsp226
comments:
- id: 01M783NNSGN3EAK795YGNR8WRJ
  author: Steve Vine
  at: 2026-11-12T14:47:59.536587Z
  text: |-
    Built — PR #1750 (auto-merge set), commit 955067bb.

    What you'll see: archiving a piece of evidence from its own page shows it archived with "Delete permanently…" available, and nothing fails in the background or the browser console. The same holds wherever the archive dialog is used.

    Cause: after a successful archive the piece's page refreshed everything while the archive dialog was still open, so the dialog asked again what archiving involves — for a piece that was now archived — and Compass answered 409.

    Fix (frontend only): the dialog stops asking once the archive is sent; the two archive actions that refresh everything drop the cached archive options instead of re-asking, so a dialog opened later asks afresh. Other screens' archive actions only refresh their own lists and never re-asked.

    Checks: new vitest reproduces the 409 request without the fix and passes with it; eslint, tsc -b, prettier clean; full vitest suite green apart from two unrelated load flakes that passed on rerun. Not yet seen in a browser — that's the pre-UAT pass on staging.
- id: 01M78APSPAWGSDTZ0GK60YBM2F
  author: Steve Vine
  at: 2026-11-12T16:50:56.330708Z
  text: |-
    Pre-UAT on staging (3175d2ad), 2026-11-12 — **Passed**.
    Uploaded e2e-pre-uat-1760-a.txt via Audit ▸ Evidence ▸ Add evidence (lands on its own page), Archive → Wrong file uploaded: the page shows it archived with "Delete permanently…". One archive-options request before (200), the archive (200), refreshes all 200, no second archive-options request; console clean. Repeated in dark with e2e-pre-uat-1760-b.txt (reason Other): same, clean.
    Screenshots ~/compass-uat/spsp226/COM-1760/.
assignee: steve
label:
- bug
priority: low
task_status: done
---
Found in the sprint 116 round-2 pre-UAT pass on staging (2026-11-12), area of COM-1738. Seen twice.

**What happens:** as Admin A in E2E Test Company, open a current piece of evidence (e.g. from Audit ▸ Evidence ▸ Register), click Archive, choose a reason, confirm. It archives correctly, but the browser console logs a 409 on `GET /api/v1/audit/<company>/evidence/file/<id>/archive-options`: after the archive, the page asks again for the archive options of a piece that is now archived. The Browser smoke never archives, so it doesn't catch this.

**What it should do:** archiving from the piece's page shows the piece as archived with no request failing and nothing in the console. The archive options are only asked for while the piece is current (or dropped from the cache once it's archived).

**Done when:** archiving a piece from its own page logs no errors in the browser console, and the page then shows it archived with Delete permanently… available. Frontend only, independent.