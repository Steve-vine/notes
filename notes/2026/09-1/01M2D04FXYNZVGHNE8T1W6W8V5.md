---
id: 01M2D04FXYNZVGHNE8T1W6W8V5
created: 2026-09-13T09:03:53.790706Z
updated: 2026-09-13T10:56:58.799596Z
type: task
title: Access section reworked — one editable list of role · description · type (Group / User / Local) · account, for technology and data assets
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 704
sprint: skdc1az
comments:
- id: 01M2D6KHV2R4N0AQQ2NV4CDDX6
  author: Steve Vine
  at: 2026-09-13T10:56:58.722366Z
  text: |-
    Done — PR #711 merged to main (squash).

    The Access section on a technology asset is now one table: Role · Description · Type (Group / User / Local) · Account · Holders · edit/remove. "Add access" opens a small modal whose Account control switches with the Type: a security-group search, a directory-people search, or a free-text local account name. A group row opens to its members with the direct / inherited count. The same account may hold two roles, never the same role twice. In the portal the owner keeps User and Local rows; Group rows are read-only there.

    Recertification: a review row is now one per (person, access entry) carrying the role and the path ("Admin · via IT-Admins", "Editor · named user", "Service · local account") — in the instance detail, the portal review page and the evidence CSV. Removals still route by source; a flagged user or local row flags the entry and raises an Inventory action naming the role and account, confirmed from the entry.

    Migration 0199 moved every group grant (role "Member") and manual holder (role = access level, or "Access") into the one table keeping the old ids, so any review open across the deploy still completes and flags the right entry. ADR 0072 §7/§9 amended.

    Smoke: on a technology asset add "Admin / full control / Group / IT-Admins", "Editor / edits content / User / <a person>" and "Service / backups / Local / svc-backup"; expand the group; trigger a recertification and check the rows carry roles.
assignee: steve
label:
- feature
priority: high
task_status: review
---
Requested by Steve, 2026-09-13: the Access section stops being two lists (Entra groups; manual holders) and becomes **one editable list of access entries**. Each row says *what role* an account holds on the asset and *what that role means*, and the account is whichever kind of thing actually holds it. Applies to technology assets now and to data assets when COM-702 adds their Access section — COM-702 builds on this shape, not the old one.

**A row**
* **Role** — free text ("Admin", "Editor", "Read-only", "Service account").
* **Role description** — a larger text box: what the role actually permits ("Can change firewall rules and create users").
* **Type** — select: **Group** · **User** · **Local**.
* **Account** — depends on Type: *Group* → a search box over the mirrored Entra security groups (M365/dynamic refused by kind, ADR 0045 §3); *User* → a search box over directory people (the COM-678 candidates search); *Local* → a free-text box for an account name that lives on the asset ("root", "sa", "svc-backup").
* Optional notes stay off the row — the description carries the meaning; the asset's Notes carry the rest.

**Storage**: one table `asset_access_entries` replacing `container_access_groups` and `container_manual_holders` — `asset_kind` + `asset_id` (the inventory-links polymorphic shape, so data assets reuse it), `role`, `role_description`, `entry_type` (`group | user | local`), `directory_group_id` / `directory_user_id` / `local_account` (exactly one set, a check constraint), `removal_pending`. Audited. Unique on (asset, entry_type, account, role) so the same group can hold two roles but not the same role twice.
* **Migration** (append-only, one head): each `container_access_groups` row → a Group entry with role "Member" and an empty description; each manual holder → a User entry (directory user set) or a Local entry (free text), role from its `access_level` or "Access" when blank, description empty; `removal_pending` carried over. Log the counts. Drop the two old tables — **after** the recert remap below.

**What is derived from the list** (nothing else changes its meaning):
* **Holders** — the people who actually have access: a Group row expands to its effective members (direct + inherited via `core/directory_graph`, each shown with the row's role and "via <group>"); a User row is that person; a Local row is that account name. The section shows the list of entries, and each Group row can be expanded to its members with the direct/inherited count ("14 direct + 3 via nested groups"); a read-only **Holders** roll-up (the `/holders` endpoint) stays for the Access Control user page's Assets section and for recertification.
* **Access methods** and **Configuration details** on the record are unchanged — they describe how authentication works; this list describes who holds what.

**Recertification compatibility — checked against `tasks/recert.py` and `core/container_access.py`, 2026-09-13.** Today a container snapshot is one row per *person* deduplicated across the asset's groups (`group_ids` list on the item) plus one row per manual holder with `source = manual` and a `manual_holder_id`; `mark_manual_pending` flags the holder through that id, and group removals go through the directory write path. Two changes make the new list work with it, and both belong in this task, not a follow-up:
1. **A recert item records the access entry it came from, and the role.** `recert_instance_items` gains `access_entry_id` (replacing `manual_holder_id`, which the migration renames and re-points) and `role`. The snapshot becomes **one row per (person, access entry)**: a Group row yields one item per effective member of that group with the row's role, `source = group`, `group_ids = [that group]` (so the write path removes them from *that* group, the inherited rule choosing the nested group as today); a User or Local row yields one item with `source = manual` (the enum value keeps its name; the meaning is "Compass cannot remove this"). A person in two Group rows, or in a Group row and a User row, appears twice, once per role and path — that is the point: the reviewer decides each grant, and removing one leaves the other. Instance detail, the portal review page and the evidence CSV show the role and the path ("Admin · via IT-Admins" / "Editor · user" / "Service · local").
2. **Open instances survive the migration.** Instances already triggered hold frozen `manual_holder_id`s; the migration carries the old-id → new-entry-id mapping it built while converting holders, and rewrites `access_entry_id` on every open item before dropping the old table, so `mark_manual_pending` on completion still finds the entry. Completed instances are frozen evidence and need nothing. Schedules keyed on the container are unchanged.
* Removal at completion by source: **group** → the directory write path as today; **manual** (User or Local rows) → `removal_pending` on the entry and an Inventory action for the Inventory admins, as today. The Inventory action's title names the role and account.

**Screens**: the Access card on the technology asset detail (and portal, for owners — Group rows stay internal-only to add/remove, as Entra grants do today; User and Local rows are the owner's to manage) becomes a table: Role · Description · Type pill · Account (group name / person name · job title / local account) · holders count for groups · edit / remove. **Add access** opens a small modal with the four fields, the Account control switching with Type. The CSV template's technology sheet does not carry access entries (as before).

**API**: `/api/v1/containers/{id}/access` (list / create / update / delete) replaces the group and manual-holder routes; `/holders` stays; gates unchanged (`inventory.view` / `inventory.manage_access`). Same shape for data assets in COM-702.

**ADR 0072 §7 and §9** rewritten: one list, three account types, holders derived; a recert row is a (person, entry) pair carrying its role; the two-model description is superseded.

Tests: the check constraint; each type's account resolution; holders expansion per type with inherited members; the migration's mapping **including the open-instance remap**; recert snapshot rows carry role, entry and source, a person in two entries yields two rows, removals route by source and a flagged group row removes from that group only; portal scope per type; the modal's Account control switching. Regenerate `schema.d.ts`.

**Acceptance**: a technology asset's Access section is one table; adding "Admin / full control / Group / IT-Admins", "Editor / edits content / User / Alice Owner" and "Service / backups / Local / svc-backup" shows three rows, the group expandable to its members; a recertification of the asset lists every holder with their role and path and, on completion, removes a flagged group member through Entra and raises an action for a flagged local account; an instance open across the upgrade completes normally.