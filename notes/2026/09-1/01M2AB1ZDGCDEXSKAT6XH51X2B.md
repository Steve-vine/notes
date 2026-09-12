---
id: 01M2AB1ZDGCDEXSKAT6XH51X2B
created: 2026-09-12T08:17:02.384222Z
updated: 2026-09-12T16:16:29.45704Z
type: task
title: Data asset form loses the Personal data / Special category flags — controlled data categories are ticked on the data type
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 688
sprint: skdc1az
comments:
- id: 01M2ATY3NM12JSX1RZCST8AJX5
  author: Steve Vine
  at: 2026-09-12T12:54:32.884618Z
  text: |-
    Merged to main in PR #698 (2026-09-12).

    The Contains personal data / Special category controls are gone from the data asset form. Each data type in Admin ▸ Data Rubric now carries tick boxes for four controlled data categories — PII, Special category PII, Health data, Payment card data — a fixed set, with a Controlled data column of pills in the types table. A data asset's controlled data is derived as the union across its types and shown as small pills on the data assets tab (with a filter per category), the data asset detail and portal pages, and the technology asset's Data held rows. The migration logged every asset whose old flag was set, by ref, so the right types can be ticked, then dropped the two columns. The CSV template loses the two columns; a file still carrying them is refused with a message naming the Data Rubric. The dashboard tile counts technology assets holding card or health data with no recertification schedule. ADR 0042 §2 and ADR 0072 §14 amended.

    Tests: rubric round trip and ordering; derivation across types and onto Data held, with a tick on the type reaching every asset at once; a populated-database migration test asserting the log lines; the importer's refusal; the tile; the rubric modal, register pills and filter, and the form having no personal-data controls.

    Deploys to staging with the rest of sprint 59. Smoke: no personal-data controls on the form; tick Payment card data on a type and every asset holding it shows a Card pill, the filter finds it, and its technology assets show it under Data held. Note the log from the migration lists the assets that were flagged before — those types need ticking.
assignee: steve
label:
- improvement
priority: medium
task_status: done
---
Requested by Steve, 2026-09-12: the *Contains personal data* / *Special category* controls come off the data asset form — the data types already say what the data is, and asking twice invites the two answers to disagree. Refined the same day: rather than a single personal-data marker, the Data Rubric gets **tick boxes for controlled data categories** on each data type, and a data asset inherits whatever its types carry.

**Shape (the ADR 0042 rule, applied once more: record the fact on the type, derive it on the record)**
* Each **data type** in the Data Rubric carries a set of **controlled data categories**, ticked by an admin beside the type's sensitivity on Admin ▸ Data Rubric. The four to start:
  * **PII** — personal data (UK GDPR Art. 4)
  * **Special category PII** — Art. 9 data
  * **Health data** — patient/medical data (ISO 27001 A.5.34, and the HIPAA framework where it applies)
  * **Payment card data** — cardholder data in PCI DSS scope
  A type may carry several (a medical record is PII, special category and health data). Ships with nothing ticked; the admin marks types once.
* Storage: a fixed enum `controlled_data_category` (`pii | special_category_pii | health_data | payment_card_data`) and a join table `data_type_controlled_categories`. Fixed, not admin-extendable: these are regulatory scopes and a new one is a migration plus, probably, a framework mapping — the deliberate decision an ADR records. The data types table is already audited.
* A data asset's **controlled categories are derived**: the union across its data types, returned as `controlled_categories` on the data asset shapes (list, detail, portal, CSV export). Nothing stored on the asset.
* `data_assets.personal_data` and `special_category` are **dropped**. Migration logs every asset whose stored flag was set so the admin can tick the right types (the ADR 0042 §5 rule: nothing cleared silently). Append-only, one head.
* **Surfaces, now derived**: the data assets tab's *Personal data* column becomes **Controlled data** — one small pill per category (PII · Special · Health · Card); its filter offers the four categories. Same pills on the data asset detail and portal pages, and on the technology asset detail's *Data held* rows (a system holding card data is the PCI question). The Article 30 section keeps processing role, lawful basis etc. — properties of the processing, not the data.
* The CSV template loses the two flag columns; the importer rejects them with a row error naming the replacement ("tick the categories on the data type in the Data Rubric").
* Admin ▸ Data Rubric: the data types table gains a Controlled data column (pills) and the edit modal four tick boxes. Reads are already open to portal readers.
* Dashboard tile: technology assets holding card data or health data with no recertification schedule — added to the tile's list if it is cheap; otherwise a follow-up.
* ADR 0072 §14 and ADR 0042 §2 each get a short amendment naming the four categories and the fixed-enum decision.

Tests: derivation (union across types, none when no type carries any), the rubric edit, the list filter per category, the migration's log, the importer's error. Regenerate `schema.d.ts`.

**Acceptance**: the data asset form has no personal-data controls; ticking Payment card data on a data type makes every data asset holding it show a Card pill and appear under the filter, and its technology assets show it under Data held; the CSV template has no personal-data columns.