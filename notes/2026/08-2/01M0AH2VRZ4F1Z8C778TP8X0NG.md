---
id: 01M0AH2VRZ4F1Z8C778TP8X0NG
created: 2026-08-18T13:30:59.231845Z
updated: 2026-08-18T13:30:59.231845Z
type: task
title: View Groups screen — searchable inventory, detail modal, directory-role badge, Azure Portal link
assignee: steve
task_status: todo
label: feature
priority: medium
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 253
---
New **View Groups** entry in the Access section nav, below Recertification (remember the `App.tsx` placeholder-exclusion gotcha). Read-only inventory of all discovered groups over the COM-252 API.

* **List**: paginated table — **Name, Group type, Membership type, Email, Source** — with a filter bar at the top: free-text name search (debounced), selects for group type / membership type / source, and a "grants directory roles" toggle. Empty/loading per house patterns.
* **Directory-role badge**: groups that grant Entra directory roles get a **stand-out badge** (shield-style, warning colour — visually distinct from the ordinary `StatusPill` vocabulary so it reads as "privileged", not just another status) in the list row and repeated prominently in the modal, listing the actual role names there (e.g. *Global Administrator*). If the backend reports the grant missing for role resolution, the badge shows "role-assignable — roles unknown" rather than pretending.
* **Detail modal** (click a row): everything from the list plus **Description, Object ID** (copy affordance), **Created on, Owners, Group membership** (the groups this group is nested in), **Members** (paginated within the modal — big groups exist), and the directory-roles list with the badge.
* **Azure Portal link**: an "Open in Azure Portal" button (list row overflow + modal header) deep-linking the group blade — `https://portal.azure.com/#view/Microsoft_AAD_IAM/GroupDetailsMenuBlade/~/Overview/groupId/{objectId}` — new tab, external-link affordance.
* Gate with the existing `RequireSection section="access"` / `require_access_read` — browse-only, no write affordances anywhere; the role matrix remains the place a group becomes *managed*.

Refs: ADR 0045, 0022, 0017; COM-252 (API), `components/nav.ts`, the Access section screens from COM-240/242 as structural models.