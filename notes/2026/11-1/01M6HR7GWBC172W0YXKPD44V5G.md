---
id: 01M6HR7GWBC172W0YXKPD44V5G
created: 2026-11-03T22:24:43.915954Z
updated: 2026-11-04T07:22:00.914892Z
type: task
title: Record a rotation — the owner marks a secret rotated, with the date, how, and that the old key no longer works; the secret keeps its full rotation history, which becomes evidence of operation for the key management controls
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1566
sprint: sjrd5gz
blocked_by:
- 01M6HR736H74082R9R6V293FJX
comments:
- id: 01M6J4EVHVC33PWQVC01VJREB6
  author: Steve Vine
  at: 2026-11-04T01:58:27.131626Z
  text: |-
    Done: PR #1580 merged, migration 0775.

    What's there:
    - **Record rotation** on the secret's page (its owner, or *Manage secrets*):
      - the date: today by default, never in the future, never before it was created;
      - how it was done;
      - a required tick, **"The old key no longer works"**. Until it's ticked, the dialog says "it isn't rotated", and the database refuses one without it too.

      Saving moves Last rotated and Next due at once: an overdue API key becomes *Due in 365 days*.
    - **Overview and Rotations tabs** on the secret. Rotations lists every rotation, newest first: when, how, how it's known (*Recorded by owner* for now) and who recorded it.
    - **Recorded in error**, with a reason, keeps a rotation in the list struck through, with the reason under it, and stops it counting. Last rotated falls back to the one before, or to the date typed in.
    - **Evidence of operation:** a new **Secrets** source on **IDM.18**, **IDM.19** and **KMC.2** (looked up by key). The row reads "Secrets rotated":
      - "N rotations across M secrets in the last 12 months";
      - the latest, with its secret and how it's known;
      - a warning for each registered secret past its date, or "No secrets registered".

      Audit packs pick it up through the usual evidence-of-operation path.

    My calls:
    - **Last rotated is the later of** the latest recorded rotation and the date typed on the secret, so typing a date by hand still works for older keys.
    - **Reading the evidence** needs both *View secrets* and the posture read, like every other evidence-of-operation source.

    To test on staging (after the sprint deploys), as admin in E2E Test Company:
    1. On an overdue secret, Record rotation without the tick: refused. With the tick: *Due in 365 days*.
    2. On the Rotations tab, mark it Recorded in error with a reason: it's struck through, and the secret is overdue again.
    3. Open IDM.18's assessment: the Secrets evidence row lists the rotation, and warns about anything still overdue.
- id: 01M6JPZAAJVFVPMRN29S3EPKHR
  author: Steve Vine
  at: 2026-11-04T07:22:00.914694Z
  text: |-
    **Pre-UAT: Passed, one item not checked** (staging, E2E Test Company).
    - A rotation of SEC-2 was recorded (through Polaris): today, old key revoked. It shows on the secret's Rotations tab as *recorded*, and next due moved a year on.
    - A rotation of SEC-3 was recorded through the API, and its incident card says "Rotated · recorded".
    - **Fix during pre-UAT:** a control's Secrets evidence of operation counted secrets across every company's rotations. That was fixed in PR #1594 with a regression test.
    - **Not checked on staging:** a control's Evidence of operation screen (s42.IDM.3). E2E Test Company has no assessment for it; the integration test covers it.

    Screenshot: `~/compass-uat/sprint-105/COM-1566/rotations-tab-sec-2.png`.
assignee: steve
label:
- feature
priority: high
task_status: review
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