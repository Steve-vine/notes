---
id: 01M2D04FXYNZVGHNE8T1W6W8V5
created: 2026-09-13T09:03:53.790706Z
updated: 2026-09-13T09:04:01.453936Z
type: task
title: Access section reworked — one editable list of role · description · type (Group / User / Local) · account, for technology and data assets
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 704
sprint: skdc1az
assignee: steve
label:
- feature
priority: high
task_status: todo
---
Requested by Steve, 2026-09-13: the Access section stops being two lists (Entra groups; manual holders) and becomes **one editable list of access entries**. Each row says *what role* an account holds on the asset and *what that role means*, and the account is whichever kind of thing actually holds it. Applies to technology assets now and to data assets when COM-702 adds their Access section — COM-702 builds on this shape, not the old one.

**A row**
* **Role** — free text ("Admin", "Editor", "Read-only", "Service account").
* **Role description** — a larger text box: what the role actually permits ("Can change firewall rules and create users").
* **Type** — select: **Group** · **User** · **Local**.
* **Account** — depends on Type: *Group* → a search box over the mirrored Entra security groups (M365/dynamic refused by kind, ADR 0045 §3); *User* → a search box over directory people (the COM-678 candidates search); *Local* → a free-text box for an account name that lives on the asset ("root", "sa", "svc-backup").
* Optional notes stay off the row — the description carries the meaning; the asset's Notes carry the rest.

**Storage**: one table `asset_access_entries` replacing `container_access_groups` and `container_manual_holders` — `asset_kind` + `asset_id` (the inventory-links polymorphic shape, so data assets reuse it), `role`, `role_description`, `entry_type` (`group | user | local`), `directory_group_id` / `directory_user_id` / `local_account` (exactly one set, a check constraint), `removal_pending`. Audited. Unique on (asset, entry_type, account, role) so the same group can hold two roles but not the same role twice.
* **Migration** (append-only, one head): each `container_access_groups` row → a Group entry with role "Member" and an empty description; each manual holder → a User entry (directory user set) or a Local entry (free text), role from its `access_level` or "Access" when blank, description empty; `removal_pending` carried over. Log the counts. Drop the two old tables.

**What is derived from the list** (nothing else changes its meaning):
* **Holders** — the people who actually have access: a Group row expands to its effective members (direct + inherited via `core/directory_graph`, each shown with the row's role and "via <group>"); a User row is that person; a Local row is that account name. The section shows the list of entries, and each Group row can be expanded to its members with the direct/inherited count ("14 direct + 3 via nested groups"); a read-only **Holders** roll-up (the `/holders` endpoint) stays for the Access Control user page's Assets section and for recertification.
* **Recertification** snapshot = the holders roll-up, one row per (holder, role, source). Removal at completion by source: a holder who came from a **Group** row → the directory write path removes them from that group (the inherited-member rule from ADR 0048 §5 stands: the row says which nested group is edited); a **User** or **Local** row → Compass cannot remove it → `removal_pending` on the entry and an Inventory action for the Inventory admins, exactly as manual holders today.
* **Access methods** and **Configuration details** on the record are unchanged — they describe how authentication works; this list describes who holds what.

**Screens**: the Access card on the technology asset detail (and portal, for owners — Group rows stay internal-only to add/remove, as Entra grants do today; User and Local rows are the owner's to manage) becomes a table: Role · Description · Type pill · Account (group name / person name · job title / local account) · holders count for groups · edit / remove. **Add access** opens a small modal with the four fields, the Account control switching with Type. The CSV template's technology sheet does not carry access entries (as before).

**API**: `/api/v1/containers/{id}/access` (list / create / update / delete) replaces the group and manual-holder routes; `/holders` stays; gates unchanged (`inventory.view` / `inventory.manage_access`). Same shape for data assets in COM-702.

**ADR 0072 §7** rewritten: one list, three account types, holders derived; the two-model description is superseded.

Tests: the check constraint; each type's account resolution; holders expansion per type with inherited members; the migration's mapping; recert snapshot rows carry role and source and removals route by source; portal scope per type; the modal's Account control switching. Regenerate `schema.d.ts`.

**Acceptance**: a technology asset's Access section is one table; adding "Admin / full control / Group / IT-Admins", "Editor / edits content / User / Alice Owner" and "Service / backups / Local / svc-backup" shows three rows, the group expandable to its members; a recertification of the asset lists every holder with their role and, on completion, removes a flagged group member through Entra and raises an action for a flagged local account.