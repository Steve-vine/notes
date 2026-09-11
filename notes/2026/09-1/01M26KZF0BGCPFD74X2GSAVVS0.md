---
id: 01M26KZF0BGCPFD74X2GSAVVS0
created: 2026-09-10T21:35:59.499283Z
updated: 2026-09-11T19:27:53.569057Z
type: task
title: Data register — record, DAT ids, GDPR fields, the container mapping and derived classification
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 666
sprint: skdc1az
blocked_by:
- 01M26KZ3K106KB0HJSKK03TJCQ
comments:
- id: 01M26R4H3209AEWFDJBRMQNCFC
  author: Steve Vine
  at: 2026-09-10T22:48:39.777892Z
  text: |-
    Done — PR #674 merged to main.

    Backend: `data_assets` + co-owners, `data_asset_data_types` / `data_asset_data_entities` (the ADR 0042 vocabulary), `data_asset_containers` (the one join between the registers, audited, with a role), `data_asset_transfers` (migration 0179, DAT- sequence). `/api/v1/data-assets` CRUD. Classification is derived in one place (core/inventory_reads): the asset's from its data types, the container's from the data mapped to it — returned as {rank, name} from the rubric's current wording, blank when nothing is recorded. Article 30 fields captured; special-category cleared when not personal. Guarded delete both ways (mapped asset 409; container holding data 409). 8 integration tests, including the acceptance path Restricted type → asset → container → unmapped → blank.

    Frontend: Data tab on the Inventory register; detail page at /inventory/data/:id with classification, personal-data/processing (transfers table), held-in, lifecycle and audit trail; container detail gains the Data held card and the derived pill; SensitivityPill coloured by rank so a reworded level keeps its meaning; add/edit modal with data type and subject pickers, container mapping with roles, transfers editor, and deliberately no classification field.
assignee: steve
label:
- feature
priority: high
task_status: done
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