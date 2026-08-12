---
id: 01KZVAS99DY8HTP2TQC5NEQ6AJ
created: 2026-08-12T15:52:17.453644Z
updated: 2026-08-12T16:00:08.601987Z
type: task
title: Business Services compose modal keeps the last draft
project: 01KX671DATY39VW6GWK3M2T3DN
number: 670
assignee: steve
label:
- bug
priority: low
task_status: active
---
The same fault as ISE-659, in the one other place it survives.

On Business Services, `ComposeModal` (`pages/BusinessServicesPage.tsx:198`) is rendered unconditionally and keyed only on the row being edited (`editing?.entity_id ?? 'new'`). Closing the modal only flips `opened`, so the component instance is never unmounted and its draft state — `useState(editing?.name ?? '')` and the selected application ids — outlives the close. Expect a second 'New service' to open pre-filled with whatever the last one had typed, and a cancelled edit to reappear the next time the same service is opened. A page refresh clears it.

Fix as per ISE-659: a session counter folded into the modal's React key, so every open mounts a fresh instance while the modal still animates shut. (A mount guard — `{opened && <ComposeModal … />}` — also works and is what the other cards do, at the cost of the close transition.)

Not affected, checked while auditing the same key pattern: `TagRulesCard`, `ReportsPage` and `DashboardsPage` all wrap the modal in a mount guard already, so they unmount on close and re-initialise correctly. `ServersPage` keys on `'closed'` when shut, which has the same effect.

Not reproduced against staging — found by reading the code while fixing ISE-659/ISE-661.