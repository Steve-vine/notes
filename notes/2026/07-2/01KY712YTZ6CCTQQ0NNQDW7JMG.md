---
id: 01KY712YTZ6CCTQQ0NNQDW7JMG
created: 2026-07-23T08:22:18.207158Z
updated: 2026-07-23T11:00:29.42725Z
type: task
title: Persist applied-but-unvalued taxonomies (empty taxonomy fields)
task_status: done
assignee: steve
imported_from: linear
priority: medium
project: 01KY6W9951TW0904DT0GGJVGE7
number: 197
sprint: s1ea454
label: null
---
A taxonomy currently only exists on a note once it has a value: empty editor rows are buffer-only and vanish on save/reload. That breaks DEV-840's "add to all tasks" (nothing to sweep until a value exists) and DEV-842's applied taxonomies (they lapse on navigation).

Adopt option A: an applied-but-unvalued taxonomy persists as an **empty frontmatter field** (`genre:`, YAML null).

* The editor shows it as an empty row (no default stamping, no value copying — both would fabricate data).
* Save path distinguishes "row with no values" (write empty field) from "no row" (remove field); read path surfaces empty fields as rows.
* Index records empty fields (empty-string sentinel, excluded from browse/value queries) so "taxonomies used in this project" counts them.
* DEV-840's "add to all tasks" sweeps the empty field immediately; values are then set per task.

Decision recorded as an ADR. Spawned from DEV-840 / DEV-842 testing.

---

Linear DEV-844 · Sprints · created 2026-07-05 · done 2026-07-05