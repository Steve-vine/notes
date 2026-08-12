---
id: 01KZVDP3CW164G6823ABYJCCYW
created: 2026-08-12T16:42:58.844917Z
updated: 2026-08-12T16:42:58.844917Z
type: task
title: 'version-cve: conditional-applicability labelling (AND/running-on) — operator-tree eval deferred'
priority: low
imported_from: linear
label: feature
task_status: done
assignee: steve
project: 01KZV767QMFTN9CZ3TPGTSAASD
number: 196
---
Split out of [DEV-624](<https://linear.app/stevevine/issue/DEV-624>) (P4). The precision pass deferred the heaviest, lowest-ROI piece: evaluating the **full NVD applicability operator tree**.

## Problem

P1's sync (`services/cve_sync.py` `_walk_cpe_matches`) **flattens** the NVD `cve.configurations[].nodes[].cpeMatch[]` structure into independent `cve_cpe_match` rows — it drops the node-level `operator` (AND/OR), the multi-node config structure, and the "running on" / target-platform relationships, keeping only `vulnerable=true` criteria. So the matcher (`services/cve_lookup.py`) does per-row containment and unions hits; it **cannot** enforce multi-criterion logical constraints. A CVE that only applies when product X runs **on** platform Y (AND-gated) will match on X alone → false positive.

## Scope

* **Re-store the applicability tree** — schema change (a node/operator structure, or a JSONB applicability blob per CVE) + sync rewrite to preserve the `configurations` tree instead of flattening.
* **Evaluate the tree** in the matcher — AND/OR node logic + the running-on/target constraints, against the detected CPE set (and, where available, the host's other detected components).
* Keep the P4 no-version suppression + confidence/KEV gating behaviour.

## Acceptance

* A CVE whose applicability is AND-gated on a platform the target isn't running is **not** emitted; OR-gated and simple single-criterion CVEs still match. Matcher tests over representative NVD operator-tree shapes.

## Notes

Lower priority than P5 operability — most version-CVE FPs for the common web-stack case come from no-version + low-confidence (addressed in P4), not operator-tree mis-evaluation. This is the long-tail precision work. Plan-mode-driven; the storage shape (normalised node table vs JSONB blob) is the key design decision.

---

Imported from Linear [DEV-626](https://linear.app/stevevine/issue/DEV-626/version-cve-conditional-applicability-labelling-andrunning-on-operator)