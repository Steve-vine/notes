---
id: 01KZVB28ZGPVWY9D0ZN72N5EZD
created: 2026-08-12T15:57:12.048367Z
updated: 2026-08-12T15:57:12.048367Z
type: task
title: Document Helm hook-ordering pattern in architectural-standards
imported_from: linear
label:
- follow_up
- chore
task_status: backlog
priority: medium
assignee: steve
project: 01KZV767QMFTN9CZ3TPGTSAASD
number: 92
---
Five issues during PR #11 verification (#21, #22, #25) all stemmed from the same architectural pitfall (Helm hooks land before non-hook resources). Worth promoting to a documented pattern with explicit weight ranges (CNPG/Cluster CRs at weight 0, secrets at weight 5, migration Jobs at weight 10).

Source: Obsidian To Do § From Brief 007.

---

Imported from Linear [DEV-37](https://linear.app/stevevine/issue/DEV-37/document-helm-hook-ordering-pattern-in-architectural-standards) · parent DEV-12