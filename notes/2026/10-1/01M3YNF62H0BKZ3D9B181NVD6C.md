---
id: 01M3YNF62H0BKZ3D9B181NVD6C
created: 2026-10-02T15:59:31.409234Z
updated: 2026-10-02T16:31:16.229412Z
type: task
title: A hybrid joiner's mailbox access and lists are applied once their account reaches Entra — not reported as "Exchange Online is not configured"
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 835
sprint: sme8esk
comments:
- id: 01M3YP9Y5HSBXM1G039X894FCX
  author: Steve Vine
  at: 2026-10-02T16:14:08.049291Z
  text: |-
    Done: PR #842, merged to main (f47e876). **Not deployed to staging yet**; say when you want it.

    **What was wrong:** a hybrid joiner's cloud side is finished by a background check every 5 minutes, once their account arrives in Entra. That check connected to Entra but not to Exchange. So it added the cloud groups but reported the role's shared-mailbox access as *"Exchange Online is not configured"*, and then marked the joiner as finished, so nothing would retry. Cloud distribution lists were affected the same way.

    **Now:** that check connects to Exchange exactly as the joiner's own run does. Once the account reaches Entra, the joiner gets their cloud groups, shared-mailbox access and lists together.

    **Proven by a new test:** a hybrid joiner whose role grants Open and Send As on a shared mailbox gets both once their account reaches Entra, and nothing says "not configured". The test fails without the fix.

    **For your end-to-end re-test (once deployed):**
    1. Make sure the role includes the licence group, so the joiner gets a mailbox of their own.
    2. Raise the joiner. They appear in AD at once, and the request says the cloud parts will follow.
    3. After Entra Connect's next sync, within about 5 minutes: the cloud groups, Open and Send As on 24 Hour, and no "not configured" message.

    **One thing to watch:** the licence group and the mailbox permissions are applied in the same step. Exchange takes a few minutes to create a newly licensed user's mailbox. If it refuses the permissions because the mailbox isn't there yet, the request will say so, and that would be a follow-up for me. The fix doesn't change that timing.
- id: 01M3YQ9A853FDHCK1FX2QMDK4J
  author: Steve Vine
  at: 2026-10-02T16:31:16.229245Z
  text: '**Deployed to staging:** f47e876 (`staging-20261002-1629`), with the deploy and smoke check green. The API, worker, beat and frontend are on the new images, with no restarts. Only this fix shipped (staging was at COM-834). Ready for your end-to-end re-test.'
assignee: steve
label:
- bug
priority: high
task_status: review
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