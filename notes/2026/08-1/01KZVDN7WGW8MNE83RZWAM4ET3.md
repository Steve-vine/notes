---
id: 01KZVDN7WGW8MNE83RZWAM4ET3
created: 2026-08-12T16:42:30.672144Z
updated: 2026-08-12T16:43:16.782375Z
type: task
title: 'version-cve: host-stack-aware correlation (enables NVD operator-tree applicability)'
project: 01KZV767QMFTN9CZ3TPGTSAASD
number: 193
sprint: s3ry03w
assignee: steve
imported_from: linear
label:
- feature
priority: low
task_status: done
---
Prerequisite surfaced by [DEV-626](<https://linear.app/stevevine/issue/DEV-626>). True NVD operator-tree applicability (AND/OR + "running-on") can't be evaluated while `version-cve` correlates **one asset's CPE at a time** — an AND-gate referencing the host OS/platform is unobservable from a single endpoint. DEV-626 therefore only **labels** conditional-applicability CVEs (low-confidence); this issue is the real fix.

## Idea

Correlate at the **host level** against the host's **full detected-CPE set** (all of a host's `endpoint` + `technology` assets), so a CVE's stored applicability tree can be evaluated (an AND-gate is satisfied only if *all* required CPEs are present in the host's stack).

## Scope (to triage at plan time — milestone-sized)

* **Store the applicability tree** — schema + sync rewrite to preserve NVD `configurations` (node/operator structure) instead of the current flatten (a JSONB applicability blob per CVE vs a normalised node table — the key design decision).
* **Host-stack assembly** — gather a host's full CPE set at correlation time (group the host's endpoint/technology assets). Decide where this lives (the lookup taking a CPE set, the engine gathering host components, or a host-level correlation step).
* **Tree evaluation** — AND/OR + running-on against the host CPE set; drop AND-gated-unsatisfied CVEs; promote confidence for satisfied ones (supersedes the DEV-626 conditional label where evaluable).

## Acceptance

* A CVE AND-gated on a platform the host isn't running is **not** emitted; one whose full AND-set is present matches at high confidence. Matcher tests over representative NVD operator-tree shapes.

## Notes

Not on the M11 milestone (M11's P1–P5 + DEV-630 close the shipped capability). This is a substantial follow-on — effectively its own milestone-sized effort. Plan-mode-driven; ROI is the long-tail precision gain for multi-component CVEs (modest for the common web-stack case, per DEV-624 analysis).

---

Imported from Linear [DEV-632](https://linear.app/stevevine/issue/DEV-632/version-cve-host-stack-aware-correlation-enables-nvd-operator-tree)