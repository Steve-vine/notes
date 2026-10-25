---
id: 01M5KSGP21X9HQH89DCES4QWCR
created: 2026-10-23T07:09:59.745359Z
updated: 2026-10-25T16:24:03.512384Z
type: task
title: Linking a control or gap to a risk again after unlinking it fails with an error
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1268
assignee: steve
label: bug
priority: medium
task_status: backlog
---
Found 2026-10-22 while building COM-1221 (sprint 83). Not yet reproduced on screen; confirmed by reading the code on main (643bc461).

**Chain:** independent unless the fix needs a migration (it shouldn't)

## What happens

On a risk in Posture ▸ Risks: link control ACC.8, unlink it, then link it again. The second link should simply come back; instead the save fails with a server error. The same goes for a gap.

## Why (technical)

- `risk_control_links` and `risk_gap_links` are soft-deleted on unlink (`deleted_at` set), but keep a plain unique constraint on the pair (`uq_risk_control_link`, `uq_risk_gap_link`).
- `link_control` / `link_gap` in `api/v1/risks.py` look only for a *live* link before inserting a new row, so a soft-deleted row for the same pair makes the insert violate the constraint (IntegrityError → 500).
- Approving a risk assessment already handles this by reviving the old row (`core/risk_assessment_approval.py`, `link.deleted_at = None`); the screen's routes should do the same.
- Check `vendor_risk_links` too (keyed by the pair; COM-1221 notes it has no id).

## Fix

Revive the soft-deleted row (clear `deleted_at`, set `updated_by`) instead of inserting, so Activity shows "linked R-14 to control ACC.8" again. Test: link → unlink → link for a control, a gap and a vendor.

**Done when:** a control, gap or vendor can be unlinked and linked again on a risk, and each step shows in Activity.