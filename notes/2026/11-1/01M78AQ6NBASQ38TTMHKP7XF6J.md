---
id: 01M78AQ6NBASQ38TTMHKP7XF6J
created: 2026-11-12T16:51:09.611194Z
updated: 2026-11-12T18:02:19.865908Z
type: task
title: Deleting an asset from its page leaves no errors in the browser
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1766
sprint: spsp226
comments:
- id: 01M78BHNE51BGCGTVZ0XHCSFC0
  author: Steve Vine
  at: 2026-11-12T17:05:36.70925Z
  text: |-
    Built — PR #1758 (auto-merge set), commit d5f44b55. Frontend only.

    What you'll see: deleting a technology, data or software asset from its page (plain Delete or "Move N links and delete") lands on Inventory as before, and nothing is asked for again about the deleted asset — the console stays clean.

    Cause: after a delete, the page refreshed every inventory read while it was still open, so it fetched the deleted asset again before moving away (the 5 × 404 seen on staging). Now the deleted asset's reads are cancelled and removed instead, and only the registers, the asset it duplicated, and linked risks and decisions refresh.

    Checks: five delete tests (technology plain, decommissioned clear-up and duplicate; data; software) now assert nothing is asked for afterwards — all five fail without the fix, and the duplicate test records exactly the staging requests; with the fix they pass. eslint, tsc, prettier clean; full vitest suite passes (3965). Re-check on staging after deploy.
- id: 01M78ESGTSFKMC0PXBN6DQNKPP
  author: Steve Vine
  at: 2026-11-12T18:02:19.865663Z
  text: |-
    Pre-UAT on staging (1392890d), 2026-11-12 — **Passed**.
    As E2E Admin A in E2E Test Company: deleted AST-47 (technology), DAT-13 (data) and SFT-26 (software) from their pages — each one delete (204), then only list refreshes (200); nothing asked for the deleted asset, its deletion check, holders or risks; landed on Inventory; console empty. Duplicate: AST-48 (depending on AST-42, depended on by AST-49) deleted as a duplicate of AST-46 — dialog read "Moves to AST-46 · Depended on by AST-49" and "Dropped — AST-46 has it already · Depends on AST-42", "Move 1 link and delete"; one delete check on AST-46, the delete, then lists only; nothing asked for AST-48; console empty; AST-49 then depended on AST-46. Test assets cleaned up.
    Screenshots ~/compass-uat/spsp226/COM-1766/recheck-*.
assignee: steve
label:
- bug
priority: medium
task_status: review
---
Found in the sprint 116 round-3 pre-UAT pass on staging (3175d2ad, 2026-11-12); caused by COM-1758. Fix forward.

**What happens:** deleting a technology, data or software asset from its page (plain Delete, or "Move N links and delete") works and returns to Inventory, but the page then asks again for the deleted asset — the asset itself, its access holders, its risks and the new "what stops the delete" read — and each gets a 404 in the console. Seen 5 times, e.g. `GET /api/v1/containers/<id>/deletion`, `/holders`, `/risks`, `/containers/<id>`; the same for `/data-assets/<id>` and `/software-assets/<id>`.

**What it should do:** deleting from the page leaves no failed requests and nothing in the console (the deleted asset's queries are removed, not refreshed — the same pattern as COM-1760).

**Done when:** deleting a technology, a data and a software asset, including as a duplicate, logs no console errors and lands on Inventory as today; a test fails without the fix. Frontend only, independent.