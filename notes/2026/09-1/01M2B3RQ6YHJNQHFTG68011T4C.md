---
id: 01M2B3RQ6YHJNQHFTG68011T4C
created: 2026-09-12T15:28:53.470501Z
updated: 2026-09-13T07:06:52.169016Z
type: task
title: Software assets gain an Edition, and identity is title + edition + version — "Windows Server Standard 2019" is not "Windows Server Datacenter 2019"
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 694
sprint: skdc1az
comments:
- id: 01M2B8HSC2NMMN75RZNYG9FKBB
  author: Steve Vine
  at: 2026-09-12T16:52:29.186371Z
  text: |-
    Done — PR #703, merged to main.

    A software asset now has an Edition, and its identity is title, edition and version together. "Windows Server" Standard 2019, Datacenter 2019 and Standard 2022 all save; a second "windows server" Standard 2019 is refused with "Windows Server Standard 2019 already exists in this company (SFT-NN)", landing on the Title field. A blank edition or version is a value, so "Windows Server", "Windows Server 2019" and "Windows Server Standard 2019" coexist. The rule is also a partial unique index in the database; the migration fails and lists offenders if any live rows already clash (none can, through the API). The portal edit is held to the same rule (it had no uniqueness check before).

    Wherever the software is named as one string (the detail and portal headings, Installed software rows and picker, search, link cards, activity, the review-due action) it reads "Windows Server Standard 2019". The register keeps Title, Edition and Version as columns. The CSV template has an edition column and the importer applies the triple against the register and within the file.

    Smoke: New software asset → Title, Edition, Version on one row; create the three Windows Server variants, then repeat one in different case and see the 409 on Title; open a technology asset's Installed software and the picker to see the one-string names; download the software CSV template.
assignee: steve
label:
- bug
priority: high
task_status: done
---
Smoke finding, 2026-09-12 (Steve): the Software Assets register refuses a second "Windows Server" because the title must be unique within the company — but Version is its own field, so two versions of one product cannot both be registered. Extended the same day: an **Edition** is needed too, and it is part of the identity — "Windows Server Standard 2019" is not "Windows Server Datacenter 2019". The title-only rule was copied from the other registers' *name* rule (COM-691); a software product's identity is **title, edition and version together**.

**The new field**: `software_assets.edition` (Text, nullable). On the form it sits between Title and Version (the order the name reads in: *Windows Server · Standard · 2019*); on the list a column after Title; on the detail a `Fact`; editable by owners in the portal; a `edition` column on the CSV template and importer. Migration append-only, one head.

**The rule**: unique on (`company_id`, lower(`title`), lower(coalesce(`edition`, '')), lower(coalesce(`version`, ''))) among live rows. Case-insensitive, whitespace-trimmed; a blank edition or version is a value, so "Windows Server" with nothing else, "Windows Server 2019" and "Windows Server Standard 2019" all coexist, while a second blank-blank "Windows Server" is refused.

* `_validate_title` in `api/v1/software_assets.py` becomes `_validate_identity(title, edition, version)`; the 409 names the triple and the record: "Windows Server Standard 2019 already exists in this company (SFT-14)".
* Put the rule in the database as well as the API — a partial unique index on the lowered triple where `deleted_at IS NULL` — so a race or a future write path cannot slip a duplicate past (the other registers rely on the API check alone; software gets the index because three fields are involved and the check is easier to get wrong). If existing rows already violate it, the migration fails loudly with the triples listed rather than picking one.
* The CSV importer's duplicate rule for software (COM-693) uses the same triple — within the file and against the register.
* **Display**: wherever a software asset is named as one string — `display_name` on the model (`title` today), the *Installed software* rows and picker on a technology asset, *Deployed on*, search results, link cards, activity entries, the review-due action title — show **title, edition, version** in that order ("Windows Server Standard 2019"), blanks omitted. The register keeps Title, Edition and Version as separate columns; search matches on edition too.
* The modal validates on save only (a triple check per keystroke is noise); the error lands on the Title field with the message above.

Tests: same title different editions and versions accepted; same triple refused (case/whitespace variants); blank edition/version as values; edit to a colliding triple refused; the importer's in-file and against-register checks; display name with each part present or blank. Regenerate `schema.d.ts`.

**Acceptance**: "Windows Server" Standard 2019, "Windows Server" Datacenter 2019 and "Windows Server" Standard 2022 all save; a second "windows server" Standard 2019 is refused naming SFT-NN; pickers and search show "Windows Server Standard 2019"; the CSV template carries an edition column.