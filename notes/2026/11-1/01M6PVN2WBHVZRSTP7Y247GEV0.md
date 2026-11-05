---
id: 01M6PVN2WBHVZRSTP7Y247GEV0
created: 2026-11-05T22:00:46.219682Z
updated: 2026-11-05T22:02:55.949097Z
type: task
title: Batch actions on the Checks page — select controls (or "all matching" the filters) and Collect now, Switch off, or Ask Polaris to design, re-validate or re-create their checks; a Polaris batch shows what it will do and what it will cost before it starts, and runs within the spend limits
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1609
sprint: s5khbev
assignee: steve
label:
- feature
priority: high
task_status: todo
---
Sprint "Checks - Coverage and batch work" (COM-1605). Builds on COM-1608. Where a Polaris batch's results come back is the next task (COM-1610).

## What people see

- **Selecting:** a tick box on each row and a select-all for the page, plus **"Select all 214 matching"** when the filters match more than one page. The selection bar says how many controls and how many checks are selected.
- **Actions** (Record assessments). Each says what it will do before doing it:
  - **Collect now**: runs every selected collected check, and Run now for built-in ones, in the background, with a progress line ("38 of 52 done").
  - **Switch off / Switch on**: per check, for this company, with a reason. Switching off closes the gaps it raised, as today.
  - **Ask Polaris to design checks**: for selected controls that are *Not yet looked at* or *Partly automated*.
  - **Ask Polaris to re-validate**: for selected collected checks.
  - **Ask Polaris to re-create**: for selected collected checks. The old ones keep running until replacements are approved (COM-1604).
- **Before a Polaris batch starts:**
  - "Polaris will look at 52 controls. About $6.10. Polaris's day limit has $14 left."
  - Big selections are split into parts of at most 200 controls, each with its cost (COM-1605).
  - Controls Polaris can't do anything for are listed and left out: built-in checks can't be re-created, and a control with no accounts to read gets "connect an integration first".
  - If the spend limit would be hit, it says so and offers to start only what fits.
- **While it runs:** a progress line on the page ("Polaris has looked at 18 of 52"), which the person can leave and come back to, and **Stop**. What's finished so far stays.
- **Activity log:** one entry per batch ("<person> asked Polaris to design checks for 52 controls"), not 52.

## Notes (technical)

- Selection limited to the filtered rows, as `vulnerabilities/RegisterTab.tsx` does. A bulk preview then bulk run, like `api/v1/vulnerability_bulk.py` (`/bulk/preview`, `/bulk`). "All matching" sends the filters, not ids, and the preview resolves them server-side.
- A Polaris batch is one COM-1599 job with many items: one item per control, run in sequence, committing each. Copy `read_some`'s stop-on-limit. Cost estimate: from recent jobs of the same kind (median tokens × `price_of`), falling back to a fixed estimate.
- Collect now in bulk: one Celery task per check on the normal queue, not the interactive lane, so a big batch doesn't starve Test buttons.

**Chain:** on the chain (API).

**Done when:** on staging, in E2E Test Company:
- filtering to "Not yet looked at" in one domain and selecting all shows the cost and then runs;
- Stop halfway keeps what's done;
- Collect now on 20 checks shows progress and finishes;
- Switch off on three closes their gaps with one activity-log entry.

Without a provider key, the Polaris parts are Couldn't check.