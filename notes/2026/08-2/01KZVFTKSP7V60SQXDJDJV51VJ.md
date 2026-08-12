---
id: 01KZVFTKSP7V60SQXDJDJV51VJ
created: 2026-08-12T17:20:23.862743Z
updated: 2026-08-12T17:20:23.862743Z
type: task
title: Canonical severity enum + per-scanner normalisation
assignee: steve
task_status: done
imported_from: linear
label: feature
priority: high
project: 01KZV767QMFTN9CZ3TPGTSAASD
number: 354
---
Canonical severity enum + per-scanner mapping. Foundational work for DEV-97 (SLA deadlines from severity) and the Finding data model — both need a consistent severity scale.

## Problem

Different scanners emit severity on different scales:

* **nuclei** — `critical / high / medium / low / info`
* **nma…

---

*Excerpt — full description in Linear.*

Imported from Linear [DEV-248](https://linear.app/stevevine/issue/DEV-248/canonical-severity-enum-per-scanner-normalisation)