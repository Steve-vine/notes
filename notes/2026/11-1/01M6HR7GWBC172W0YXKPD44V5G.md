---
id: 01M6HR7GWBC172W0YXKPD44V5G
created: 2026-11-03T22:24:43.915954Z
updated: 2026-11-04T01:27:14.851668Z
type: task
title: Record a rotation — the owner marks a secret rotated, with the date, how, and that the old key no longer works; the secret keeps its full rotation history, which becomes evidence of operation for the key management controls
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1566
sprint: sjrd5gz
blocked_by:
- 01M6HR736H74082R9R6V293FJX
assignee: steve
label:
- feature
priority: high
task_status: active
---
Sprint "Secrets - New Module" (ADR 0141, COM-1563). Builds on COM-1565.

## What people see

- **Record rotation** on the secret's page, for its owner or anyone with *Manage secrets*:
  - the **date** (today by default, never in the future);
  - **how** it was done ("new key generated in Stripe, old one revoked");
  - a required tick: **"The old key no longer works."**

  Saving sets Last rotated, and Next due recalculates.
- **Rotations tab** on the secret. Every rotation shows its date, who recorded it, how, and **how it's known**. This task adds only *Recorded by owner*. Later tasks add *Seen in the store, confirmed by owner*, *Seen at source and store* and *Rotated by AWS*.
- **Rotations are frozen.** A wrong one can be marked **Recorded in error**, with a reason. It stays in the history struck through, and Last rotated falls back to the one before.
- **Evidence of operation.** The rotations recorded in a period are evidence for **IDM.18**, **IDM.19** and **KMC.2**:
  - on each control's evidence (as other modules supply it, e.g. the Inventory recertifications);
  - in Audit ▸ Evidence: "Secrets rotated, 1 Jan–31 Mar: 14 rotations across 9 secrets, 0 overdue at the end of the period".

## Notes (technical)

- New `secret_rotation` table: secret_id, rotated_on, how, old_key_revoked (bool, must be true), proof enum (`recorded`, `store_confirmed`, `source_and_store`, `cloud_native`), recorded_by, in_error_at, in_error_reason. Append-only apart from the error mark.
- `last_rotated_on` is derived from the latest rotation not in error, falling back to the typed-in value on the secret.
- Evidence of operation: a new `secrets_evidence_of_operation.py` in the shape of `inventory_evidence_of_operation.py`. Look controls up by **key** (`s42.IDM.3`, `s42.IDM.4`, `KMC.3`), never by the displayed ref (memory: control key vs ref).
- Run the key-shaped-text guard on "how".

**Chain:** on the chain (migration and API).

**Done when:** on staging, in E2E Test Company:
- the owner records a rotation for an overdue secret, and it becomes *Due in 365 days*;
- marking that rotation Recorded in error puts it back to overdue;
- IDM.18's evidence of operation lists the rotation for the period.