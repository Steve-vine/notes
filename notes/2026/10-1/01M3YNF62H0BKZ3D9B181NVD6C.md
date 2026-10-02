---
id: 01M3YNF62H0BKZ3D9B181NVD6C
created: 2026-10-02T15:59:31.409234Z
updated: 2026-10-02T15:59:34.989188Z
type: task
title: A hybrid joiner's mailbox access and lists are applied once their account reaches Entra — not reported as "Exchange Online is not configured"
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 835
sprint: sme8esk
assignee: steve
label:
- bug
priority: high
task_status: active
---
Found in Steve's staging smoke test of COM-781/COM-820 (2026-10-02).

## What happened

Steve created a hybrid joiner, aardvark.smith, with Test Role. The role grants a cloud group plus Open and Send As on the shared mailbox 24 Hour.
- The account was made in AD and reached Entra a sync later.
- Compass then added him to the cloud group.
- The mailbox access was **not** applied. The request said *"Exchange Online is not configured — mailbox access not applied: 24 Hour (can open), 24 Hour (can send as)"*, yet staging's Exchange connection was healthy.
- The joiner was then marked finished, so nothing would ever retry it.

## What should happen

When a hybrid joiner's account reaches Entra, Compass gives them **everything** their roles grant in the cloud, Exchange included: shared-mailbox access and cloud distribution-list membership. That's what a cloud-only joiner already gets in a single step. If Exchange really isn't configured, it says so, as it does today.

## Notes (technical)

- `tasks/access_execute.py::_finish_joiners_awaiting_entra` builds `_Graph(db, client, token)` **without `exchange=`**. The joiner's own run (`execute_access_request`) passes it.
- So `_apply_mailbox_changes` returns the "not configured" note and `awaiting_entra_since` is cleared. List membership through Exchange is hit the same way.
- Fix: resolve the Exchange config in the sweep, as the main run does, and pass it in. Check the other sweeps that build a `_Graph` too.
- Test: a hybrid joiner whose role grants a mailbox, finished by the sweep with Exchange configured → the grant goes through the Exchange seam and nothing says "not configured".

**Done when:** the sweep applies a waiting hybrid joiner's mailbox access, merged to main. Steve will delete aardvark.smith and re-test end-to-end, with a licence group on the role.