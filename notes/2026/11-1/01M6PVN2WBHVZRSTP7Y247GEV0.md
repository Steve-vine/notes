---
id: 01M6PVN2WBHVZRSTP7Y247GEV0
created: 2026-11-05T22:00:46.219682Z
updated: 2026-11-07T08:55:18.865251Z
type: task
title: Batch actions on the Checks page — select controls (or "all matching" the filters) and Collect now, Switch off, or Ask Polaris to design, re-validate or re-create their checks; a Polaris batch shows what it will do and what it will cost before it starts, and runs within the spend limits
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1609
sprint: s5khbev
blocked_by:
- 01M6PVMKAHWMEB7NT5YK2RJSV5
comments:
- id: 01M6QAVH3AP5GJ343SMYGSQQ85
  author: Steve Vine
  at: 2026-11-06T02:26:26.025925Z
  text: |-
    Done — merged to main (PR #1625).

    What's there
    - On Posture ▸ Checks, tick one or more controls, or select every control the filters show. Then choose "Do something with them":
      - Collect now
      - Switch off / Switch on (with a reason)
      - Ask Polaris to design checks
      - Ask Polaris to re-check
      - Ask Polaris to re-create
    - A preview comes first. It says what will happen, which controls are left out and why (for example "Already fully automated"), and for Polaris what it will cost and whether today's limit holds it ("Start the first N" when it doesn't).
    - Polaris batches run one control at a time in the background, with progress shown on the page. Stop keeps what's already done.
    - A batch raises one review action ("Design checks for 3 controls — 3 waiting"), not one per control. The activity log gets one entry per batch.
    - Switch off / on writes one activity-log line for the whole batch, with the reason.

    My calls
    - A batch is at most 200 controls per part; bigger selections run as several parts.
    - Switch off also switches off the built-in checks on those controls.

    Tests: test_collection_batch.py; CoverageTab.test.tsx (batch preview and start).

    What to check on staging: select a few controls, then Collect now, and check the preview and the result. The Polaris actions are Couldn't check: they need Polaris's AI provider.
- id: 01M6RBFGWENC36CSC6N46VNM3D
  author: Steve Vine
  at: 2026-11-06T11:56:35.598573Z
  text: |-
    Pre-UAT, as E2E Admin B in E2E Test Company, against the real AI provider: Partly passed. Stop halfway, Collect now on 20, and Switch off on three are Couldn't check.

    What I did and saw:
    - **The batch bar.** Selecting two "Not yet looked at" controls shows "2 controls selected · Do something with them". The menu has Collect now, Switch off, Switch on, and Ask Polaris to design / re-check / re-create.
    - **The preview before starting.** "Polaris will look at 2 — design checks for 2 controls. About $0.46. Polaris's day limit has $48.84 left." I cancelled.
    - **A whole domain.** The same preview through chat for the Access Control domain: "design checks for 15 controls", $3.60, fits today's allowance.
    - **A batch run.** One of 2 controls (ACC.1, ACC.2) finished in 40 seconds and came back on the Review tab.

    Couldn't check:
    - Stop halfway, Collect now on 20 checks, and Switch off on three closing their gaps. E2E Test Company has one live collected check, and a bigger Polaris batch costs real money.

    For Steve: try Switch off on a few checks with gaps, and a bigger design batch, in a real company.

    Screenshot: ~/compass-uat/s5khbev/COM-1609/
assignee: steve
label:
- feature
priority: high
task_status: done
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