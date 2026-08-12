---
id: 01KZVBG9P8YA1GXWQPRZRB09ZY
created: 2026-08-12T16:04:51.528394Z
updated: 2026-08-12T16:04:51.528394Z
type: task
title: Asset upsert clobbers discovered_in_workflow_step_run_id on conflict
assignee: steve
label: bug
task_status: backlog
imported_from: linear
priority: low
project: 01KZV767QMFTN9CZ3TPGTSAASD
number: 122
---
**Flagged in:** [Brief 033](<https://github.com/Steve-vine/redvektor/blob/main/docs/briefs/033-scan-steps-consume-prior-step-assets.md>) §Risks & notes, [DEV-233](<https://linear.app/stevevine/issue/DEV-233/scanner-chaining-issue>) closeout

## Problem

`AssetUpsertService.upsert` in `app/backend/src/redvektor_api/services/assets.py` unconditionally sets `discovered_in_workflow_step_run_id = excluded.workflow_step_run_id` in its `ON CONFLICT` clause:

```python
on_conflict_set: dict[str, Any] = {
    "last_seen_at": observed,
    "meta": text("assets.meta || excluded.meta"),
    "discovered_in_scan_id": self.scan_id,
    "discovered_in_scan_job_id": scan_job_id,
    "discovered_in_workflow_run_id": self.workflow_run_id,
    "discovered_in_workflow_step_run_id": workflow_step_run_id,  # ← clobbers
}
```

Two prior step runs in the same WorkflowRun discovering the same `fingerprint` means the second step's `step_run_id` wins on the row. Lineage of "which step run first found this Asset" is lost.

## Evidence from DEV-233 smoke

A live 3-step `cloudflare(MP) → cloudflare(VN) → httpx` run produced:

* CF(MP) `meta.asset_count` = 411 emit events
* CF(VN) `meta.asset_count` = 73 emit events
* Total = 484, but **483 unique SUBDOMAIN rows** in DB

The collapse is either (a) within-zone duplicate record types for the same hostname, or (b) cross-zone hostname collision. Both are silently overwritten — we can't tell from the row which step run first emitted the value.

Brief 033's dispatcher fix is unaffected (it dedups in Python by `value`), so the symptom never surfaces in input-set assembly. But the lineage information on the Asset row itself is wrong.

## Suggested fix

In the `ON CONFLICT` clause, only set `discovered_in_workflow_*` columns when they are currently `NULL` — preserve the first writer's lineage:

```sql
discovered_in_workflow_step_run_id = COALESCE(assets.discovered_in_workflow_step_run_id, excluded.discovered_in_workflow_step_run_id)
```

Same shape likely wanted for `discovered_in_scan_job_id` and the `*_workflow_run_id` / `*_scan_id` pairs — the constructor enforces XOR, so first-writer-wins across the four columns is the natural rule.

Cross-check: `first_seen_at` is already set via INSERT-only (not in the conflict-update set) — same intent, same pattern.

## Out of scope

* Re-stamping existing rows from history. The `asset_history` table has the full lineage; lookups that need "first discoverer" can join through it. Not worth a backfill.
* Adding a separate `first_discoverer_workflow_step_run_id` column. The COALESCE rule on the existing column is sufficient.

## Files

* `app/backend/src/redvektor_api/services/assets.py` — `AssetUpsertService.upsert`
* `app/backend/tests/test_asset_upsert_service.py` (or equivalent) — extend to pin first-writer-wins for both scan and workflow lineage pairs

---

Imported from Linear [DEV-235](https://linear.app/stevevine/issue/DEV-235/asset-upsert-clobbers-discovered-in-workflow-step-run-id-on-conflict)