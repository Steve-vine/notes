---
id: 01KZK2GWF414BZTFJQE11AVZJ1
created: 2026-08-09T10:53:58.116403Z
updated: 2026-08-09T12:03:49.924367Z
type: task
title: 'Discovered tab: list every Windows and Linux device, with filters, bulk actions, a Dismissed tab and paging'
project: 01KX671DATY39VW6GWK3M2T3DN
number: 621
assignee: steve
label:
- improvement
priority: high
task_status: review
---
Supersedes the classification approach in [ISE-620]. Agreed with Steve 2026-08-09.

**The inversion.** ISE stops trying to decide what a device IS. Entra has no attribute for "server", so every rule ISE writes is a proxy that rots on the next Windows release. Instead: report every Windows and Linux device, and give the operator the tools to narrow the list themselves. Judgement moves to the person who has it.

**Detection**
- Entra contributes ALL Windows and Linux devices — servers and workstations alike. The `SERVER_BUILDS` allow-list goes.
- Non-computers (iOS, Android, macOS, printers) stay out; they are not machines ISE could ever manage agentlessly.
- Disabled and stale (>60d unseen) device objects stay filtered — that is about a machine being DEAD, not about what kind it is. Flag if this should change.
- Expected volume in the live tenant: ~1,480 Windows + Arc 39 + Azure 12, so the queue goes from 51 to ~1,500 rows. Everything below exists because of that number.
- The ephemeral-compute exclusions (k8s nodes, VMSS instances) STAY. Different problem: those are replaced continuously, so each new instance is a new candidate that can never be usefully dismissed. A workstation is stable — dismiss it once and it stays dismissed.

**Discovered tab** (renamed from Coverage)
- Filters to narrow the list — source, OS family, free-text on hostname.
- A checkbox per row, with select-all-on-page.
- **Manage** and **Dismiss** as bulk actions over the selection.
- Bulk Manage has to handle a mixed selection: a profile is per OS family, so the modal asks for one profile per family present in the selection rather than assuming they are all the same.

**Dismissed tab** (new)
- Every dismissed device that a source is STILL reporting, so a mistaken dismissal is recoverable.
- A **Manage** button per row — the way back.

**Paging** on all three tabs (Fleet, Discovered, Dismissed), matching the Estate screen's pattern. Without it, none of the above is usable at 1,500 rows.

**Acceptance**: the Discovered tab lists every Windows and Linux device the estate can see, filterable and pageable; selecting rows and dismissing them in bulk clears them in one action; dismissed devices appear on the Dismissed tab and can be managed back; the Fleet tab pages.