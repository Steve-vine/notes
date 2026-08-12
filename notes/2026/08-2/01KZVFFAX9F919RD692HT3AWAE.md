---
id: 01KZVFFAX9F919RD692HT3AWAE
created: 2026-08-12T17:14:14.313979Z
updated: 2026-08-12T17:14:14.313979Z
type: task
title: 'M6: unify parse_scanner_line with conformance parser (spec-1.0.0 V1 swap)'
priority: medium
task_status: done
assignee: steve
imported_from: linear
project: 01KZV767QMFTN9CZ3TPGTSAASD
number: 316
---
Planning note surfaced by Brief 062 (DEV-269) — for the M6 engine-cutover brief(s), not standalone work now.

**Finding:** the conformance CLI could not reuse `protocol.parse_scanner_line` as Brief 062 intended, because that parser is **legacy-only** — its `ScannerLine` discriminator union can't co-host the spec-1.…

---

*Excerpt — full description in Linear.*

Imported from Linear [DEV-303](https://linear.app/stevevine/issue/DEV-303/m6-unify-parse-scanner-line-with-conformance-parser-spec-100-v1-swap)