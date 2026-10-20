---
id: 01M5CM9SQN68EQEPBWPR34KX3C
created: 2026-10-20T12:24:10.229049Z
updated: 2026-10-20T18:09:26.888638Z
type: task
title: Asset recertifications show as Evidence of operation on the asset-register controls
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1155
comments:
- id: 01M5D660MG9G9KD9Z5TGPJQQER
  author: Steve Vine
  at: 2026-10-20T17:36:40.591935Z
  text: |-
    Merged in PR #1160 at 17:33 UTC on 2026-10-20 (main 6547688a). Not yet on staging.

    **What changed:** on a company's assessment of the asset controls, Evidence of operation gains an **Inventory recertification** line, one per register:
    - **ASM.1 and ASM.2:** "Technology and software assets confirmed accurate";
    - **PDH.13:** "Data assets confirmed accurate";
    - **ACC.4:** "Access to assets recertified". Access Control's own recertifications appear beside it, under their own label, once COM-1154 lands.

    Each line shows:
    - **Last done:** the most recent Confirm accurate and who pressed it. On the access line, the last completed asset recertification, the owners who submitted it, and how many rows were kept or flagged.
    - **Next due:** the earliest asset falling due under the company's review intervals, or the next asset recertification.
    - **Warnings:**
      - accuracy lines: assets overdue for confirmation, and assets never confirmed;
      - access line: overdue recertifications, and live assets with no recertification at all.
    - An empty register says so, e.g. "No data assets recorded". A withdrawn review is never counted as done.

    Only people who can view Inventory see the line. Nothing about the assessment changes.

    **My calls:**
    - As in the task: fixed controls, one line per register, and "never confirmed" or "no recertification" counts as a warning.
    - A disabled recertification schedule doesn't count as recertifying its asset.
    - **The asset's name is shown under Last done, but it isn't a link on the card.** The link travels in the data, and the assistant has it. The card's layout for these lines is shared by every module and I left it alone while three sibling sources landed at once; making it a link is a small follow-up if you want it.

    **Checks:**
    - 6 new integration tests:
      - the control key-to-ref mapping;
      - the register line: confirmed through the screen's own action, overdue, never confirmed, and decommissioned left out;
      - the data line;
      - the access line: completed, withdrawn, overdue and unscheduled;
      - empty registers;
      - no line for someone without Inventory.
    - The attestation, privacy request, incident, SAP and assistant evidence suites, plus the vendor and content sources that landed first: all green locally.
    - ruff, ruff format, mypy. No migration, and no API change.

    **CI:** run 39463939017, 21.0 min in total, backend-test 19.9 min, on compass-runners. The frontend job was skipped (backend only). Two earlier runs were cancelled when I rebased onto the vendor (COM-1153) and content (COM-1156) sources as each merged.
assignee: steve
label:
- follow_up
priority: low
task_status: done
---
Split from COM-1060 (2026-10-20). Builds on COM-1051's Evidence of operation registry (ADR 0115 §10).

## Why

Inventory asks owners to confirm, on a cycle, that each asset's record is accurate and that its access list is right. Those confirmations prove the register is kept, but the asset controls' assessments don't show them.

## What people see

On a company's assessment of these controls, Evidence of operation gains an **Inventory recertification** line:
- **ASM.1** and **ASM.2** (`ASM.1`, `ASM.2`): assets recorded in a register, each with an owner. The line covers technology and software assets confirmed accurate.
- **ACC.4** (`ACC.8`): owners recertify access to information assets. The line covers asset access confirmed.
- **PDH.13** (`s42.PDH.2`): a record of processing kept current. The line covers data assets confirmed accurate.

Each line shows:
- **Last done:** the most recent confirmation, by whom, with a link to the asset.
- **Next due:** the earliest asset falling due under the company's review intervals.
- **Warning:** how many assets are overdue for confirmation, and how many have no recertification at all.

The line is visible to people who can see the assessment and can view Inventory.

## My calls (to confirm)

- **Fixed controls,** as the other modules do.
- **One line per register (technology, data, access) per company, not one per asset.**
- **"No recertification" counts as a warning,** because the register can't be shown as kept for those assets.

## Notes (technical)

- New source module; `CONTROL_EVIDENCE` keyed by control key (memory control-key-vs-ref).
- Reuse the review-interval and assets-without-recertification logic behind Inventory's review intervals and the assistant's `inventory_list_assets_without_recertification`.
- ACC.4 will also have Access recertification lines (sibling task). Both appear, each under its own source label.
- Tests: confirmed, overdue and never-recertified assets in each register; a reader without Inventory view sees nothing.

**Done when:** on staging, a company's assessment of ASM.1 shows its last asset confirmation, the next due, and the overdue count.