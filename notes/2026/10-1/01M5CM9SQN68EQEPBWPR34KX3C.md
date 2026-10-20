---
id: 01M5CM9SQN68EQEPBWPR34KX3C
created: 2026-10-20T12:24:10.229049Z
updated: 2026-10-20T12:24:10.229049Z
type: task
title: Asset recertifications show as Evidence of operation on the asset-register controls
label: follow_up
priority: low
assignee: steve
task_status: backlog
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1155
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