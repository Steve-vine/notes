---
id: 01M2AB1ZDGCDEXSKAT6XH51X2B
created: 2026-09-12T08:17:02.384222Z
updated: 2026-09-12T08:17:04.736748Z
type: task
title: Data asset form loses the Personal data / Special category flags — personal data is a property of the data type
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 688
sprint: skdc1az
assignee: steve
label:
- improvement
priority: medium
task_status: todo
---
Requested by Steve, 2026-09-12: the *Contains personal data* / *Special category* controls come off the data asset form — the data types already say what the data is, and asking twice invites the two answers to disagree.

**Shape (the ADR 0042 rule, applied once more: record the fact on the type, derive it on the record)**
* The **Data Rubric** gains a per-data-type marker: **Personal data** (`none | personal | special_category`), set by an admin beside the type's sensitivity on Admin ▸ Data Rubric. Ships as `none` for existing types; the admin marks the ones that are personal. Revisioned like the sensitivity link is not — it is a plain column; the activity log covers the table already.
* A data asset's **personal-data status is derived**: *special category* if any of its data types is; else *personal* if any is; else *none*. Same "highest wins" rule as classification (§4). Returned as `personal_data_state` on the data asset shapes; nothing stored on the asset.
* `data_assets.personal_data` and `special_category` are **dropped**. Migration logs any asset whose stored flag was set but whose data types (after the admin marks them) would not derive it — the admin marks types before upgrading, or reads the log after; either way nothing disappears silently.
* **Surfaces keep working, now derived**: the Personal data column and filter on the data assets tab, the pills on the detail and portal pages, the Article 30 fields section (which still shows processing role, lawful basis etc. — those stay typed, they are properties of the processing, not of the data). The CSV template loses the two columns; the importer rejects them with a row error naming the replacement ("mark the data type in the Data Rubric").
* Admin ▸ Data Rubric: the data types table gains a Personal data column and the edit modal a three-way select. Reads are already open to portal readers; nothing to widen.
* ADR 0072 §14 and ADR 0042 §2 each get a one-line amendment.

**Simpler alternative, rejected unless Steve prefers it**: drop the flags and every surface that used them (column, filter, pills), leaving the reader to infer personal data from type names. Rejected because "which datasets hold personal data" is the GDPR question the register exists to answer, and a name is not a fact Compass can filter on.

Tests: derivation (none / personal / special, highest wins), the rubric edit, the filter, the migration's log, the importer's error. Regenerate `schema.d.ts`.

**Acceptance**: the data asset form has no personal-data controls; marking a data type as special category makes every data asset holding it show Special category and appear under the filter; the CSV template has no personal-data columns.