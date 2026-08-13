---
id: 01KZVAS99DY8HTP2TQC5NEQ6AJ
created: 2026-08-12T15:52:17.453644Z
updated: 2026-08-13T19:00:22.222304Z
type: task
title: Business Services compose modal keeps the last draft
project: 01KX671DATY39VW6GWK3M2T3DN
number: 670
comments:
- id: 01KZVBDXEVKYE14E0B6CF4KH52
  author: Steve Vine
  at: 2026-08-12T16:03:33.467596Z
  text: |-
    Fixed in PR #621 (commit ece1c2b), merged to main and deployed to staging.

    Confirmed the same mechanism as ISE-659: `ComposeModal` is rendered unconditionally so it can animate shut, and keyed only on `editing?.entity_id ?? 'new'`. `close()` only flips `opened`, so the instance is never unmounted and its `useState` draft — the name and the chosen application ids — outlives the close. That key tells one row from another but is constant across repeated opens of the same row, and across every 'new'.

    Fix: a `session` counter incremented on every open, folded into the modal's React key, with both open sites routed through one `openModal` helper. Same shape as the ISE-659 fix, so the two pages now behave identically.

    Tests: two in `BusinessServicesPage.test.tsx` (a second 'New business service' opens blank; a cancelled rename does not persist into the next open). Both verified failing before the fix.

    Scope confirmed on the way through: this was the only remaining instance. `TagRulesCard`, `ReportsPage` and `DashboardsPage` match the same key pattern but already mount-guard the modal, and `ServersPage` keys on `'closed'` when shut — none needed changing.
assignee: steve
label:
- bug
priority: low
task_status: done
tech: null
---
The same fault as ISE-659, in the one other place it survives.

On Business Services, `ComposeModal` (`pages/BusinessServicesPage.tsx:198`) is rendered unconditionally and keyed only on the row being edited (`editing?.entity_id ?? 'new'`). Closing the modal only flips `opened`, so the component instance is never unmounted and its draft state — `useState(editing?.name ?? '')` and the selected application ids — outlives the close. Expect a second 'New service' to open pre-filled with whatever the last one had typed, and a cancelled edit to reappear the next time the same service is opened. A page refresh clears it.

Fix as per ISE-659: a session counter folded into the modal's React key, so every open mounts a fresh instance while the modal still animates shut. (A mount guard — `{opened && <ComposeModal … />}` — also works and is what the other cards do, at the cost of the close transition.)

Not affected, checked while auditing the same key pattern: `TagRulesCard`, `ReportsPage` and `DashboardsPage` all wrap the modal in a mount guard already, so they unmount on close and re-initialise correctly. `ServersPage` keys on `'closed'` when shut, which has the same effect.

Not reproduced against staging — found by reading the code while fixing ISE-659/ISE-661.