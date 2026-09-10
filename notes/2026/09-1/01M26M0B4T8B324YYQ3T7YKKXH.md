---
id: 01M26M0B4T8B324YYQ3T7YKKXH
created: 2026-09-10T21:36:28.314275Z
updated: 2026-09-10T21:36:28.314275Z
type: task
title: Access holders on a container — Entra groups from the mirror, a manual holder list, one combined view
priority: high
task_status: todo
label: feature
assignee: steve
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 669
---
Who has access to a container (ADR 0072). Both models may coexist on one record — a system with SSO plus local admin accounts is one asset.

* **`container_access_groups`** — the mirrored security groups that grant access (Entra object id → `directory_groups`; the business-role-group mapping shape). M365/dynamic groups refused by kind (ADR 0045 §3). Effective holders are computed at read time via `core/directory_graph` — **direct and inherited distinguished** ("N direct + M via nested groups", ADR 0048 §5).
* **`container_manual_holders`** — a hand-maintained list: `directory_user_id` (nullable) **or** `label` (free text for local/service accounts: "root", "svc-backup"), `access_level` (text, e.g. admin / read), `granted_at`, `notes`, `removal_pending` (set by recertification, cleared when an admin confirms removal — the recert task). Audited.
* **Holders endpoint** `GET /api/v1/containers/{id}/holders` — one list: person (or label), source (`group:<name>` / `manual`), direct/inherited, access level; plus counts. The UI's **Access** section on the container detail: the groups (add/remove, group modal links to Access Control), the manual list (add/edit/remove), the combined holder table, and the access-method pills.
* Person view: the Access Control user page (Users browse) gains an **Assets** section — containers this person holds access to, via which source. Read-only, `inventory.view`.
* Gated: reads `inventory.view`; group and manual-list writes `inventory.manage_access`.

**Acceptance**: a container with one Entra group and two manual holders shows all holders with their source; a user in a nested group appears as inherited; removing the group from the container changes nothing in the tenant.