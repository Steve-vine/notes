---
id: 01M7DBVS5Y8BKH687546NWY0EQ
created: 2026-11-14T15:47:20.382557Z
updated: 2026-11-14T15:47:25.169151Z
type: task
title: A capture's page and table in an audit pack use the fields that capture actually holds, not the check's fields today (no more empty columns)
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1828
sprint: spsp226
assignee: steve
label:
- bug
priority: high
task_status: active
---
## What happened

Found in Claude's re-check of COM-1824 on staging 55b58a1b (2026-11-14), E2E Test Company, as E2E Admin A. Pack f19a326a (Core controls, ACC.13, 1–14 Nov, PDF and zip), and the retried b46f0550, lay out CHK-2's **Microsoft 365 capture** (6 Nov 10:56, 210 items) with CHK-2's *current* kept fields — GitHub repository fields (`allow_forking`, `archive_url`, …), because CHK-2's reads changed after that capture. So its `table.csv` is 210 rows × 102 columns, **all empty**, and its PDF is 590 pages of field names with no values. The capture's real data (`directoryScopeId`, `roleDefinitionId`, …) is only in its raw JSON. This is probably also why that one capture's page was so large (COM-1824).

Likely from COM-1804 (a capture's page shows the check's kept fields) and COM-1814 (the new CSV and column names), which take the field list from the check as it is now.

Repro: build a pack for ACC.13, 1–14 Nov, in E2E Test Company; open "…· Microsoft 365 · 2026-11-06 table.csv" in the zip.

## What people see

- A capture's page and table (in the Evidence register and in audit packs) show the fields **that capture holds** — the fields it was filed with — in the order they were kept, with the check's display names where a name exists for that field, and the raw field otherwise.
- A capture filed before the check's reads changed reads as it did when filed; it never shows columns it doesn't hold.
- Left-out (sensitive) fields stay out, as now.

## Done when

- In a rebuilt pack for ACC.13, 1–14 Nov, the Microsoft 365 capture's table.csv and page show its own fields with their values (no all-empty columns), and its page is a normal size.
- The GitHub captures still read as now, with CHK-2's names.
- Tests: a check whose reads changed after a capture — the older capture's page/CSV use its own fields; names apply only to fields it holds.

**Independent** unless the capture's own field list isn't stored (then say so; it joins the chain). Fix-forward from COM-1814 / COM-1804, found while checking COM-1824.