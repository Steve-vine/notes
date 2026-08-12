---
id: 01KZVFT8Z5WGJV58KGM6H6ZWKY
created: 2026-08-12T17:20:12.773458Z
updated: 2026-08-12T17:20:12.773458Z
type: task
title: nuclei stdout transport — work around the ~10MB pod-log cap
assignee: steve
task_status: done
label: feature
imported_from: linear
priority: medium
project: 01KZV767QMFTN9CZ3TPGTSAASD
number: 351
---
Phase-4-scoped sibling to DEV-69 (general result transport upgrade). nuclei is the first scanner expected to exceed the \~10MB NDJSON-on-stdout cap that the K8s pod log API imposes.

## Why now

* …

---

*Excerpt — full description in Linear.*

Imported from Linear [DEV-252](https://linear.app/stevevine/issue/DEV-252/nuclei-stdout-transport-work-around-the-10mb-pod-log-cap)