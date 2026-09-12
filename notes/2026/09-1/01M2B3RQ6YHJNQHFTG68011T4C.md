---
id: 01M2B3RQ6YHJNQHFTG68011T4C
created: 2026-09-12T15:28:53.470501Z
updated: 2026-09-12T15:28:56.69332Z
type: task
title: Software asset uniqueness is title plus version — "Windows Server 2019" and "Windows Server 2022" are two records
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 694
sprint: skdc1az
assignee: steve
label:
- bug
priority: high
task_status: todo
---
Smoke finding, 2026-09-12 (Steve): the Software Assets register refuses a second "Windows Server" because the title must be unique within the company — but Version is its own field, so two versions of one product cannot both be registered. The rule was copied from the other registers' *name* rule (COM-691); a software product's identity is **title and version together**.

**The rule**: unique on (`company_id`, lower(`title`), lower(coalesce(`version`, ''))) among live rows. Case-insensitive, whitespace-trimmed; a blank version is a value, so "Windows Server" with no version and "Windows Server 2019" coexist, while a second blank "Windows Server" is refused.

* `_validate_title` in `api/v1/software_assets.py` becomes `_validate_identity(title, version)`; the 409 says which pair exists: "Windows Server 2022 already exists in this company (SFT-14)".
* Put the rule in the database as well as the API — a partial unique index on the lowered pair where `deleted_at IS NULL` — so a race or a future write path cannot slip a duplicate past (the other registers rely on the API check alone; software gets the index because two fields are involved and the check is easier to get wrong). Migration append-only, one head; if existing rows already violate it, the migration fails loudly with the pairs listed rather than picking one.
* The CSV importer's duplicate rule for software (COM-693) uses the same pair — within the file and against the register.
* **Display**: wherever a software asset is named as one string — `display_name` on the model (`title` today), the *Installed software* rows and picker on a technology asset, *Deployed on*, search results, link cards, activity entries, the review-due action title — show **title and version** ("Windows Server 2019"), version omitted when blank. The register's Title and Version stay separate columns.
* The modal validates on save only (a pair check per keystroke is noise); the error lands on the Title field with the message above.

Tests: same title different versions accepted; same pair refused (case/whitespace variants); blank version as a value; edit to a colliding pair refused; the importer's in-file and against-register checks; display name with and without version. Regenerate `schema.d.ts` if the error shape or `display_name` changes.

**Acceptance**: "Windows Server" 2019 and "Windows Server" 2022 both save; a second "windows server" 2019 is refused naming SFT-NN; pickers and search show "Windows Server 2019".