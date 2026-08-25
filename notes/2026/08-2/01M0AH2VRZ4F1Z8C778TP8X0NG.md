---
id: 01M0AH2VRZ4F1Z8C778TP8X0NG
created: 2026-08-18T13:30:59.231845Z
updated: 2026-08-25T18:43:27.156003Z
type: task
title: View Groups screen — searchable inventory, detail modal, directory-role badge, Azure Portal link
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 253
order: 2.875
sprint: s5gwx0s
blocked_by:
- 01M0AH2AG3TCTJ223ZXN26Q9Y0
comments:
- id: 01M0BFSGTNX5R4MWA9FQJVA4H9
  author: Steve Vine
  at: 2026-08-18T22:27:38.965069Z
  text: |-
    Built and merged to main (PR #259, CI green).

    View Groups is live in the Access nav below Recertification (/access/groups): a paginated read-only inventory (Name, Group type, Membership type, Email, Source; 50/page) with debounced name search, type/membership/source selects and a grants-directory-roles toggle. Privileged groups carry an orange shield badge (deliberately not a StatusPill) in rows and the modal; when role resolution is unavailable it honestly reads "Roles unknown" / "grant missing" rather than pretending.

    The detail modal shipped as a shared component (access/GroupDetailModal) from day one — COM-257's matrix pills and COM-255's user modal reuse it without extraction work. It shows description, copyable Object ID, created on, type/membership (+ dynamic rule), source, email, owners, member-of and nested groups, the resolved role names, and members paginated inside the modal (25/page). Vanished groups render an explicit "no longer in the directory" state. Azure Portal deep links on each row and the modal header.

    No write affordances anywhere — the role matrix remains where a group becomes managed.
assignee: steve
company: null
label:
- feature
priority: medium
task_status: done
---
New **View Groups** entry in the Access section nav, below Recertification (remember the `App.tsx` placeholder-exclusion gotcha). Read-only inventory of all discovered groups over the COM-252 API.

* **List**: paginated table — **Name, Group type, Membership type, Email, Source** — with a filter bar at the top: free-text name search (debounced), selects for group type / membership type / source, and a "grants directory roles" toggle. Empty/loading per house patterns.
* **Directory-role badge**: groups that grant Entra directory roles get a **stand-out badge** (shield-style, warning colour — visually distinct from the ordinary `StatusPill` vocabulary so it reads as "privileged", not just another status) in the list row and repeated prominently in the modal, listing the actual role names there (e.g. *Global Administrator*). If the backend reports the grant missing for role resolution, the badge shows "role-assignable — roles unknown" rather than pretending.
* **Detail modal** (click a row): everything from the list plus **Description, Object ID** (copy affordance), **Created on, Owners, Group membership** (the groups this group is nested in), **Members** (paginated within the modal — big groups exist), and the directory-roles list with the badge.
* **Azure Portal link**: an "Open in Azure Portal" button (list row overflow + modal header) deep-linking the group blade — `https://portal.azure.com/#view/Microsoft_AAD_IAM/GroupDetailsMenuBlade/~/Overview/groupId/{objectId}` — new tab, external-link affordance.
* Gate with the existing `RequireSection section="access"` / `require_access_read` — browse-only, no write affordances anywhere; the role matrix remains the place a group becomes *managed*.

Refs: ADR 0045, 0022, 0017; COM-252 (API), `components/nav.ts`, the Access section screens from COM-240/242 as structural models.