---
id: 01M4XZH3BTESJFVK9EVDWYPMP0
created: 2026-10-14T19:51:47.322756Z
updated: 2026-10-14T19:51:53.523299Z
type: task
title: The Software tab shows each entry once with how many technology assets it is on, and opening it shows which
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 961
sprint: sbkelqe
blocked_by:
- 01M4XZGT1G67Z1HYZRG8MQ07BS
assignee: steve
label:
- feature
priority: high
task_status: todo
---
Part of sprint 67, Inventory discovery - Software (ADR in COM-959). This matches the Discovered ▸ Software view (COM-960), so both lists read the same way.

## What people see

- **Each Software entry is one row with a count:** "Windows Server Standard 2019 · on 14 technology assets". The count includes installs typed by hand and installs discovery found, each asset counted once.
- **Opening the row** (expanding it in place) lists those technology assets. Each one says whether the install was **typed** or **found by discovery**, and for discovered ones, the exact version and the resource it runs on. The entry's own page and its *Deployed on* section stay as they are.
- The count can be sorted, so the most widespread software comes first.
- An entry on nothing shows **0**, which is the existing *not deployed* state.

## Notes (technical)

- The count and the expanded list come from the same derivation as *Deployed on* (`container_software` plus discovered installs matched by key). Return the count with the list and the assets on demand, so the register stays one query.
- Keep `SortableTh` and the screen conventions. Regenerate `schema.d.ts`.

**Done when:** on staging, the Software tab shows counts that agree with each entry's *Deployed on*, and expanding a row lists the same assets, marked typed or discovered.