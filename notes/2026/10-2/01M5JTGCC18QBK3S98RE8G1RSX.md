---
id: 01M5JTGCC18QBK3S98RE8G1RSX
created: 2026-10-22T22:08:03.969273Z
updated: 2026-10-22T22:10:36.220051Z
type: task
title: Evidence and trust centre documents carry a sensitivity classification — anything unclassified is treated as Internal, and the Evidence register can classify many items at once
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1248
sprint: s5uw2fz
blocked_by:
- 01M5JTG6G8R2J6E26R58G57ERQ
assignee: steve
label:
- feature
priority: high
task_status: todo
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