---
id: 01M26KYPTR3FYM4FR2TKD0HP6P
created: 2026-09-10T21:35:34.74485Z
updated: 2026-09-10T21:35:34.74485Z
type: task
title: Inventory inception — two registers, IDs, access models, recertification, portal, review evidence (ADR)
assignee: steve
label: brief
priority: high
task_status: todo
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 664
---
Write **ADR 0072 — Inventory: the information asset register** and land it first; every other task in sprint 59 builds on it. The full-domain-ADR-then-incremental-schema shape (ADRs 0039, 0045, 0047).

**Decided with Steve, 2026-09-10**

* **Two registers, aligned with ISO 27001 A.5.9.** **Containers** (kind `system | application | datastore`) are the things people access. **Data assets** are the things that carry a classification. A data asset maps to the containers that hold it (including backups and physical locations); that mapping is the join. Access holders and recertification live on containers only — a data asset's access *is* its containers' access, shown read-only on the data asset.
* **Placement**: a new **Inventory** module in the Modules nav section, listed beneath Access Control; two tabs, Containers and Data. Company-scoped like Vendors and Risks.
* **Asset IDs**: `AST-NNN` for containers, `DAT-NNN` for data assets; two deployment-wide sequences (Postgres sequences, not per company) so a reference is unambiguous anywhere; a decommissioned asset keeps its number forever. Never reused, never editable.
* **Classification** follows ADR 0042: a data asset lists the **data types** it contains; its classification is the **highest sensitivity** among them (derived, no override — a dataset that needs a higher level is a missing data type). A container's **highest data classification held** is derived from the data assets mapped to it. **Data subjects / population** draws from the rubric's **data entities** vocabulary (COM-210) — no new list.
* **Criticality** reuses the ADR 0042 follow-on rubric (`vendor_criticality_levels`, Low → Critical). Rename/generalise the model or add a shared alias rather than a second scale — decide in the ADR. RTO and RPO are optional fields on a container; the form prompts for them at Critical.
* **Status**: `in_build | live | deprecated | decommissioned`, each transition dated. Guarded delete: a container with holders, mapped data or links decommissions; a data asset mapped to containers or linked decommissions.
* **Environment**: `production | staging | development`, default production; the register page states its scope.
* **Access models on a container**, both allowed on one record: **Entra groups** (one or more mirrored security groups; holders = effective members via `core/directory_graph`, direct and inherited distinguished per ADR 0048 §5) and a **manual holder list** (a directory user, or free text for local/service accounts, plus an access level/notes). The holder list shows every holder with its source. **Access method** (`sso | local_accounts | api_keys | other`, multi) is descriptive and flags where IAM controls reach.
* **Owners** are directory people resolved to Compass users (the ADR 0047 §2 pattern: warn at save if the person has not been provisioned; no tokenized side door). Additional owners allowed. Making someone an owner **auto-grants a portal role** (`asset_owner`, the `recertifier` precedent) if they hold nothing broader.
* **Recertification**: a container becomes a **recert schedule entity** (ADR 0047 §1 gains `container`); owners default from the container's owners; attestation in the portal's Recertifications tab exactly as for groups. Removals at completion: an Entra-group holder executes through the one directory write path (ADR 0045 §5); a **manual holder becomes an Inventory action** (ADR 0055 source) visible to everyone holding the Inventory admin permission — the recertifier is the owner, so the action cannot go back to them — and the holder shows *removal pending* until an admin marks it done.
* **Portal**: owners see and edit their own containers and data assets in a portal **Inventory** tab. Edits apply immediately and are audited (not the vendor's owner-approves pattern, ADR 0054). Reserved for internal users: owner, status, the links to risks/decisions/controls.
* **Review date / maintenance evidence**: a `last_verified_at` set by an explicit **Confirm accurate** action (portal or internal); a default review interval per register (annual to start), overridable per asset; an overdue review is an action for the owner. This column is the A.5.9 evidence.
* **CSV import** is create-only; a duplicate name is a row error and any row error rejects the whole file.
* **Links**: risks, decisions, vendors (supplier on a container; third-party recipients on a data asset), controls; shown on both ends.
* **Data-asset fields**: personal data flag + special-category flag; `controller | processor | joint`; retention period + trigger; lawful basis and processing purpose; volume (order of magnitude); cross-border transfers as a list of destination country + mechanism; third-party recipients (vendor links).
* **Out of scope, noted for later**: an **Article 30 RoPA export** as an ADR 0062 report definition over the data register — the fields are captured now so the report is a query later; linking an application container to its Entra service principal once the Applications sprint mirrors them.

**Permissions** (brief/permission-catalogue.md gains an Inventory group): `inventory.view`, `inventory.manage_register`, `inventory.manage_access`, `inventory.run_recertification`, `inventory.admin` (the action audience for manual removals and the guarded operations). Write implies view.

**Deliverables**: `decisions/0072-*.md`; the permission catalogue section; a one-paragraph note in `brief/information-architecture.md` on the nav placement; the ten follow-on tasks reference the ADR section numbers.