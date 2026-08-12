---
id: 01KZV9PSYSYMYGJPDF9BN718FJ
created: 2026-08-12T15:33:27.641462Z
updated: 2026-08-12T15:33:27.641462Z
type: task
title: Cross-step asset parent linkage — resolve parent refs against persisted company assets (M8)
priority: medium
imported_from: linear
assignee: steve
task_status: backlog
label:
- follow_up
- feature
project: 01KZV767QMFTN9CZ3TPGTSAASD
number: 2
---
**Slated for M8** (no Phase 8 milestone exists yet — parked in Backlog, tagged M8). Surfaced during M7 review, 2026-06-09.

## Problem

Spec 1.1.0 §5.2.1 asset `parent` resolution is **within-stream only**. In the dispatcher's `_ingest_assets_for_step_run`, a child asset's `parent` `{kind, value}` ref is matched against a local map of assets emitted **in the same step's stream**. A parent emitted by a **prior step** (different Job) is never in that map → the child is stored **parent-less** and a `workflow_step_run_asset_parent_unresolved` WARN is logged. (Unresolved is best-effort, not an error.) This is correct for the DEV-313 case it was built for — httpx emits a `url` then a `technology` child of it, same stream.

## Consequence (M7 recon chains)

The whole point of chaining is that each engine derives assets from the **previous** engine's output, which lives in a different step:

* nmap `service` → `port` (from naabu, prior step)
* tlsx `certificate` → `port`/endpoint (prior step)
* katana discovered `url` → seed (prior step)
* naabu `port` → host/`ip`

All resolve to no parent. The intended graph (`host → port → service`, `port → certificate`, `seed → url`) collapses to a **flat list of typed assets** — the relationships that make an asset-centric tool navigable (drill-down, host rollup, blast-radius) aren't captured. DEV-113/117/354/355 all shipped parent-less per their briefs' verify-then-defer flag.

## Proposed fix

Extend asset parent resolution to fall back to a **company-scoped DB lookup** by `(kind, canonical value)` when the within-stream map misses — mirroring the **finding-ingest path**, which already resolves a finding's target asset company-wide across steps (`_ingest_findings_for_step_run`; DEV-320 / ADR 035). The machinery exists; it just isn't applied to the asset→parent path. Sequencing holds (steps run sequentially; prior steps commit first).

## Scope / escalation

* **Backend dispatcher change** (asset-ingest behaviour) + a **spec clarification to §5.2.1** (cross-step parents). **Not engine-only.**
* No migration (`assets.parent_asset_id` already exists).
* Touches the asset-model / cross-component contract → always-escalate category, hence its own issue.

## Open design questions

* Uniqueness: confirm `(kind, canonical value)` resolves to exactly one asset per company (fingerprint guarantees this?).
* Should engines also set parent refs they currently omit (e.g. naabu `port → ip`) once cross-step resolution lands?
* Transaction/ordering guarantees across steps within a WorkflowRun.

Related: DEV-113, DEV-117, DEV-354, DEV-355.

---

Imported from Linear [DEV-361](https://linear.app/stevevine/issue/DEV-361/cross-step-asset-parent-linkage-resolve-parent-refs-against-persisted)