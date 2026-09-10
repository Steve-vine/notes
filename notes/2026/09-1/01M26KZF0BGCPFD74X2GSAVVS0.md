---
id: 01M26KZF0BGCPFD74X2GSAVVS0
created: 2026-09-10T21:35:59.499283Z
updated: 2026-09-10T21:35:59.499283Z
type: task
title: Data register — record, DAT ids, GDPR fields, the container mapping and derived classification
priority: high
assignee: steve
label: feature
task_status: todo
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 666
---
The **Data** tab of the Inventory module (ADR 0072): datasets in business language ("employee records", "customer call recordings"), each classified and mapped to the containers that hold it.

**Backend**
* `data_assets` — same composition as containers: `asset_ref` (`DAT-NNN`, its own deployment-wide sequence), `name`, `description`, `owner_id` + additional owners, `status` (`in_build | live | deprecated | decommissioned`) + dates, `personal_data` (bool), `special_category` (bool, only when personal), `processing_role` (`controller | processor | joint`), `retention_period` + `retention_trigger` (text), `lawful_basis`, `processing_purpose`, `volume` (order of magnitude enum or text), `last_verified_at`, `review_interval_days`.
* `data_asset_data_types` — the ADR 0042 vocabulary; **classification is derived**: the highest sensitivity among its data types (blank when none). No stored level, no override.
* `data_asset_data_entities` — data subjects / population from the rubric's data entities (COM-210).
* `data_asset_containers` — the join to containers, with an optional `role` (`primary | backup | physical`). A container's **highest classification held** is derived from this mapping and shown on the container list/detail and as a pill on both records.
* `data_asset_transfers` — cross-border transfers: `destination_country`, `mechanism` (`adequacy | idta_sccs | binding_corporate_rules | other`), notes.
* Audited; guarded delete (mapped or linked → decommission).
* `/api/v1/data-assets` CRUD + status transition; `inventory.view` / `inventory.manage_register`.

**Frontend**
* List: ref, name, owner, classification pill, personal data (with a special-category marker), processing role, containers count, status, last verified.
* Detail: record; classification section (data types with their sensitivities and the derived level, data subjects); GDPR section (personal data, processing role, lawful basis, purpose, retention, volume, transfers); containers section (mapped containers with role, links to each); audit trail. Add/Edit modal.
* Container detail gains a **Data held** section listing mapped data assets and the derived classification pill.

**Acceptance**: a data asset with a Restricted data type shows Restricted; mapping it to a container makes that container show Restricted; removing the mapping reverts the container; the RoPA fields are all captured (the export itself is a later report — ADR 0072 out-of-scope note).