---
id: 01M6PVJ4NH3YZH816WWPV157P7
created: 2026-11-05T21:59:09.745433Z
updated: 2026-11-05T21:59:09.745433Z
type: task
title: Held for review — Compass compares every capture with the approved one and holds it when fields appear or go missing, the size jumps or drops sharply, or the result is empty; a held capture stays out of the register until a person confirms it (the new shape becomes the approved one) or discards it
assignee: steve
label: feature
priority: high
task_status: todo
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1603
---
Sprint "Evidence Collection - Integrations" (ADR 0142, COM-1595). Builds on COM-1602. Asking Polaris about a held capture is the next task (COM-1604).

## What people see

- **Every capture is compared with the check's approved shape**, before it's filed. It is **held for review** when:
  - **new fields** appear. "3 fields Compass hasn't seen before: `mfaPhoneNumber`, …". Nobody has checked these for sensitive data;
  - **fields go missing**: "`grantControls` is no longer returned";
  - **the size changes sharply**: more than half as big again, or less than half, in items ("40 policies last time, 4 now");
  - **the result is empty** where it wasn't before.
- **A held check shows "Held for review"**, amber, on the control's card, with the reason in words. "Collected checks · Review" goes on the Actions of whoever approved the check, or on the assessment's owner if that person has left.
- **Reviewing a held capture** shows it side by side with the last filed one:
  - new fields highlighted, with the same sensitive-field marking as the first-capture check;
  - missing fields and the size change spelled out.
  - The reviewer can **Confirm**: the capture is filed, and its shape (minus any fields they leave out) becomes the approved shape;
  - or **Leave fields out and confirm**;
  - or **Discard**: nothing is filed, and the check keeps its old shape and runs again next time.
- **While held,** later runs keep being compared with the approved shape, so one review clears them. Only the newest held capture is offered; older held ones are dropped.
- **Broken (from COM-1602) is different from Held.** Broken means Compass couldn't read. Held means it read something that needs a person's eyes.

## Notes (technical)

- The shape is the set of field paths with their types (flattened JSON paths, arrays as `[]`) plus the item count. Comparison is deterministic: no AI.
- The size threshold is ADR 0142's call (×1.5 / ×0.5). Make it a per-company setting on Posture ▸ Checks ▸ Settings, beside the gap target days.
- An action source in `core/actions/` (one action per check, ADR 0137).

**Chain:** on the chain (migration and API).

**Done when:** tests cover each hold reason and Confirm, Leave out and Discard. On staging, in E2E Test Company, a capture with an extra field is held (not in the register), and Confirm files it and updates the approved shape. The next identical capture goes straight in.