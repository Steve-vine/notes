---
id: 01M2ADJH55DKJ3SFG2DKFFBDNE
created: 2026-09-12T09:01:01.989149Z
updated: 2026-09-12T16:16:32.304823Z
type: task
title: Software on technology assets — install software with a licences-used count; licences used and Deployed on are derived
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 692
sprint: skdc1az
blocked_by:
- 01M2ADJ0RSVANCFWZJ137YX79G
comments:
- id: 01M2AW7G05ZPG9S2QX1DVV6P9Z
  author: Steve Vine
  at: 2026-09-12T13:17:08.99778Z
  text: |-
    Merged to main in PR #700 (2026-09-12).

    A technology asset's detail and portal pages gain an Installed software section: rows of software (ref, title, version, publisher, support pill, licences used with a note) with Add, Edit count and Remove; the picker offers the company's live software not already installed. The modal does not carry it. The CSV technology template takes an optional software column (SFT-12:2; SFT-13). On the software side, Licences used is the sum across live technology assets — a decommissioned one stays listed, greyed, and drops out of the count — and Deployed on lists each asset with kind, environment and count. More used than held on a counted model reads Over-allocated with the numbers on the register and the detail; the software tab gains a Licences filter (Over-allocated / Unused). Software installed anywhere refuses delete and decommissions instead. The activity log names both the register and each installation.

    Tests: the acceptance path (counts 2 and 3 → used 5 and both listed; with 4 held it is over-allocated; used equal to held is not; decommissioning one asset drops its count and keeps the row; a repeat install is refused; installed → delete refused; open source never over-allocates); cross-company refusal; the portal owner's add, edit and remove and the offered list; the audit rows; CSV both spellings and row errors; the card and the Deployed on table on the frontend.

    Deploys to staging with the rest of sprint 59. Smoke: install SFT-12 on two technology assets with counts 2 and 3 → Licences used 5 and both under Deployed on; with 4 held it reads Over-allocated 5 of 4; decommission one asset and the figure drops.
assignee: steve
label:
- feature
priority: high
task_status: done
---
Requested by Steve, 2026-09-12: a technology asset records the software installed on it and how many licences that consumes; the software asset's **Licences used** and **Deployed on** follow from those records rather than being typed.

**The join** (`container_software`, audited): `container_id`, `software_asset_id`, `licences_used` (integer ≥ 0, default 1), optional `notes` ("2 cores", "site licence"). One row per (technology asset, software asset); same company on both sides (422 otherwise).

**Technology asset side**
* Detail page gains an **Installed software** section: rows of software (ref, title, version, publisher, support pill, licences used) with Add / edit count / remove. The picker searches the company's live software assets by title/publisher.
* The modal does not carry it — like dependencies and holders, installed software is managed on the detail page, not in a form among twenty fields.
* Portal: owners may add/remove software and change counts on their technology assets (they know what is installed); shown the same way.
* CSV: an optional `software` column on the technology template (`SFT-12:2; SFT-13` — ref with an optional `:count`, semicolon-separated); the importer resolves refs in the company and rejects unknown ones per row.

**Software asset side, derived**
* `licences_used` = Σ `licences_used` across live technology assets (decommissioned ones excluded — but shown greyed in the list so the history is visible). `deployed_on` = the technology assets, with each one's count.
* **Over-allocation**: when `licences_used > licence_count` (and the model is not OSS) the software list and detail show a red **Over-allocated** pill with the numbers ("14 of 10"); a *Licences* filter on the software tab offers Over-allocated / Unused (count > 0, used = 0).
* **Deployed on** section on the software detail: technology asset ref, name, kind, environment, count — rows link to the asset.
* A software asset with installations refuses delete (409) and decommissions instead; decommissioning a technology asset drops its counts out of the derivation but keeps the rows.

**Elsewhere**: the technology asset's *End of support* (COM-685) stays its own field — an asset's support and its software's support are different facts; a later task may suggest the earliest software date as a hint. Activity log renders install/remove/count changes on both records.

Tests: the sum across live assets only, over-allocation boundary (used = count is not over), cross-company refusal, portal edits, CSV parsing both spellings, both detail sections. Regenerate `schema.d.ts`.

**Acceptance**: installing SFT-12 on two technology assets with counts 2 and 3 shows Licences used 5 on the software record and both assets under Deployed on; with a licence count of 4 it reads Over-allocated 5 of 4; decommissioning one asset drops the figure.