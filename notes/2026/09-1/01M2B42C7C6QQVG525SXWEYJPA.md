---
id: 01M2B42C7C6QQVG525SXWEYJPA
created: 2026-09-12T15:34:09.900118Z
updated: 2026-09-12T17:04:15.461834Z
type: task
title: Software assets lose the lifecycle Status field — whether software is in use is derived from where it is installed
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 695
sprint: skdc1az
comments:
- id: 01M2B97ACQRHFFR4X5C9MFVP78
  author: Steve Vine
  at: 2026-09-12T17:04:14.743337Z
  text: |-
    Done — PR #704, merged to main.

    Software assets have no Status any more. A software asset reads Deployed when at least one live technology asset lists it, otherwise Not deployed; the pill sits beside the support pill on the register and the detail, and the register's Status filter is now a Deployment filter. The record's exit is Delete: refused while any technology asset (live or decommissioned) still lists it or a risk, control or decision cites it, otherwise a soft delete that the activity log keeps. The Lifecycle card is now a Review card; its Delete confirm says why it may be refused and shows the refusal in place. Nothing is exempt from review any more, and the dashboard tile's out-of-support count no longer skips anything.

    The migration drops the two columns and logs how many rows were decommissioned; those stay as live records reading Not deployed, so they can be deleted deliberately after the deploy. The portal page no longer withholds Edit. A `status` column on a software CSV is refused by name. ADR 0072 §6 carries the amendment.

    Not automated: the migration's log line (a plain log call, checked by reading).

    Smoke: no Status on the software form or detail; install a software asset on a live technology asset → Deployed, Delete refused with the reason; remove the installation → Not deployed, Delete succeeds and returns to the register.
assignee: steve
label:
- improvement
priority: medium
task_status: review
---
Requested by Steve, 2026-09-12: the software asset form carries a lifecycle **Status** (in build / live / deprecated / decommissioned) copied from the technology register (COM-691). For software it is a typed answer to a question Compass can already answer: support comes from the two dates, and whether it is in use comes from where it is installed. Remove it.

**What replaces it**
* **Derived `deployment_state`** on the software shapes: *Deployed* when installed on at least one live technology asset (COM-692's join, decommissioned technology assets excluded), otherwise *Not deployed*. Shown as a pill on the list and detail beside the support pill; the list's Status filter becomes a **Deployment** filter (Deployed / Not deployed). The dashboard tile's software counts use it where they used status.
* **Delete instead of decommission**: with no lifecycle, the record's exit is a guarded **Delete** — refused (409) while any live or decommissioned technology asset still lists it (the installation rows are history), allowed otherwise. Soft-delete as the other registers do, so the audit trail keeps the record. The detail page's Decommission button becomes Delete with a confirm that says why it may be refused.
* **Review cadence**: nothing exempt any more — every software asset is reviewed on its interval; a Not deployed one still gets its review-due action (the answer may be "delete it").
* `software_assets.status` and `status_changed_at` are **dropped**; the transition endpoint goes; `CONTAINER_STATUS_TRANSITIONS` is no longer imported here. Migration append-only, one head; the migration logs the count of rows that were `decommissioned` — they stay as live records and appear as Not deployed unless installed, so the log lets the admin delete them deliberately.
* The modal loses the field (create and edit, internal and portal); the CSV template loses the `status` column and the importer rejects it with a row error naming the change.
* ADR 0072 §6 gains a one-line amendment: software has no lifecycle status.

Tests: derivation with zero, one live, and only-decommissioned installations; delete refused/allowed; the filter; the importer's error; the migration's log. Regenerate `schema.d.ts`.

**Acceptance**: no Status field on the software form or detail; a software asset installed on one live technology asset reads Deployed and cannot be deleted; remove the installation and it reads Not deployed and can be deleted.