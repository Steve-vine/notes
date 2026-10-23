---
id: 01M5JTGCC18QBK3S98RE8G1RSX
created: 2026-10-22T22:08:03.969273Z
updated: 2026-10-23T18:06:19.619797Z
type: task
title: Evidence and trust centre documents carry a sensitivity classification — anything unclassified is treated as Internal, and the Evidence register can classify many items at once
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1248
sprint: s5uw2fz
blocked_by:
- 01M5JTG6G8R2J6E26R58G57ERQ
comments:
- id: 01M5KZEG0BHZA4JD6SYBYHD1KQ
  author: Steve Vine
  at: 2026-10-23T08:53:39.467314Z
  text: |-
    Done — merged in #1265 (1b29e215, migration 0600_evidence_classification).

    - **Audit ▸ Evidence:** a Classification column (sortable) and filter, including "Not classified". With Manage evidence, tick rows (or Select all on the page) → **Classify N…** → one level for all; each item's history records it.
    - **Evidence page:** a Classification panel; Manage evidence changes it there. A library document shows its own level, read-only ("Set in the library — open it").
    - **Add evidence** has an optional Classification.
    - **Trust Centre ▸ Documents:** a Classification column; set on upload or edit; library documents show their content's level read-only. "Who sees it" is unchanged.
    - Unclassified items show "Not classified — treated as Internal, so it won't be shared in a DDQ" (a hover tip on "Not classified" in tables).

    My calls:
    - "Evidence item" = a file, a link or a vendor certificate (the register's stored kinds); library content keeps its own classification.
    - A trust centre document's file, in the register, shows and sets the **document's** classification — it keeps its level when the file is renewed.
    - Any current file, link or certificate can be classified from the register wherever it sits (incidents, the plan, DSRs too): classification governs DDQ sharing, not the record it sits on.
    - Archived versions keep the level they had; replacing a file/link or renewing a certificate carries the level to the new version.
    - Bulk classify is all-or-nothing and per page (up to 50). Clearing back to "Not classified" is one at a time on the evidence page.
    - The level field is on the register's Add evidence and the trust centre upload only, not every module's own upload.

    Known gap (before this sprint too): Activity shows a classification change as rank numbers ("Classification: — → 2"), not the level name.
assignee: steve
label:
- feature
priority: high
task_status: done
---
Sprint 84, DDQ-1 (ADR in COM-1245).

**Chain:** on the chain — migration + API

## What people see

- **Audit ▸ Evidence:** every evidence item has a **Classification**, a column and a filter (including "Not classified"). Select several items → **Classify…** sets one level on all of them, and each item's history records it.
- **Evidence detail and upload:** Classification is a field. A new upload asks for it; it can be left blank.
- **Trust Centre ▸ Documents:** an uploaded document (certificate, audit report, pen test) has a Classification. A document that *is* library content shows the content's own classification, read-only.
- **Content:** Classification already exists (COM-1061) and is unchanged.
- Wherever an item is unclassified, a small hint reads "Not classified — treated as Internal, so it won't be shared in a DDQ".

## Notes (technical)

- classification_rank (nullable) on the evidence item and trust_centre_document; revisions/Activity as each table already does.
- The trust centre's own everyone/restricted tier is untouched; it governs the portal, not DDQs.

**Done when:** 20 evidence items are classified Sensitive in one action; an unclassified item shows the hint.