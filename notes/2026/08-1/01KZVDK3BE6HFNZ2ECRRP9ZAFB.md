---
id: 01KZVDK3BE6HFNZ2ECRRP9ZAFB
created: 2026-08-12T16:41:20.49482Z
updated: 2026-08-12T16:41:20.49482Z
type: task
title: 'version-cve P3: evaluate the operator tree against the host CPE set'
assignee: steve
imported_from: linear
label: feature
priority: low
task_status: done
project: 01KZV767QMFTN9CZ3TPGTSAASD
number: 190
---
Phase 3 of [DEV-632](<https://linear.app/stevevine/issue/DEV-632>) — the payoff. Evaluate a CVE's stored applicability tree (P1) against the host's CPE set (P2).

## Scope

* Tree evaluator: AND/OR + `negate` + running-on (`vulnerable:false`) over the host CPE set, reusing `version_in_match` / `compare_versions` (`services/cve_lookup.py`) for per-match containment.
* Wire into the lookup: an AND-gated CVE whose required co-component is **absent** from the host stack is **not** emitted; one whose full AND-set is **present** is emitted at **high** confidence — **superseding the** DEV-626 **conditional label where the tree is now evaluable**.
* Matcher tests over representative NVD operator-tree shapes (single-node OR, multi-node AND, running-on present/absent, negate).

## Acceptance

* A CVE AND-gated on a platform the host isn't running is not emitted; one whose full AND-set is present matches at high confidence; simple OR/single-criterion CVEs still match. The DEV-626 conditional/low label is replaced by a real verdict where evaluable.

---

Imported from Linear [DEV-635](https://linear.app/stevevine/issue/DEV-635/version-cve-p3-evaluate-the-operator-tree-against-the-host-cpe-set) · parent DEV-632