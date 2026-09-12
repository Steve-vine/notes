---
id: 01M2AANPSYP4K507KD7AV6FMTV
created: 2026-09-12T08:10:20.350452Z
updated: 2026-09-12T12:31:03.552032Z
type: task
title: Data asset ▸ technology asset roles become Primary, Hot standby, Cold standby, Backup
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 687
sprint: skdc1az
comments:
- id: 01M2ASK397TRK2Z4WDQN6TEJSP
  author: Steve Vine
  at: 2026-09-12T12:31:03.463037Z
  text: |-
    Merged to main in PR #696 (2026-09-12).

    The role a technology asset plays for the data it holds is now Primary · Hot standby · Cold standby · Backup, in that order, on the data asset modal's Held in rows, both detail pages and the portal edit form. Physical is retired from the API; the migration re-labelled every existing Physical mapping as Backup and logged the count. The CSV technology_assets column takes an optional role after a colon (AST-1:hot_standby), by identifier or label; physical on import is a row error naming its replacement. ADR 0072 §1 amended.

    Tests: the four roles round-trip and Physical is refused; a populated-database migration test asserts the re-labelling and the log line; the importer accepts a role and rejects physical; the modal offers exactly the four options in order.

    Deploys to staging with the rest of sprint 59. Smoke: the Held in role picker offers the four words in order; an old Physical mapping reads Backup.
assignee: steve
label:
- improvement
priority: low
task_status: review
---
Requested by Steve, 2026-09-12: on the data asset form, the role a technology asset plays for the data it holds is **Primary · Hot standby · Cold standby · Backup** — the resilience vocabulary, not the storage-medium one. "Physical" goes.

* `DataAssetContainerRole` (`primary | backup | physical`) → `primary | hot_standby | cold_standby | backup`, in that display order. The Postgres enum gains the two new values; `physical` stays in the enum (cannot be dropped) but the API stops offering it and `CONTAINER_ROLE_LABELS` lists four.
* Migration: existing `physical` mappings → `backup` (the closest meaning: a filing cabinet or tape store holds a copy, not the system of record); logged with a count. Append-only, one head.
* Labels on the data asset modal's *Held in* rows, the data asset detail's technology assets section, the technology asset detail's *Data held* section, the CSV template's role column (accepts the four labels or identifiers; `physical` on import is a row error), and the portal edit form.
* ADR 0072 §1 one-line amendment; model docstring updated.
* Tests: the four options round-trip, the migration's mapping, the importer rejecting `physical`. Regenerate `schema.d.ts`.

**Acceptance**: the *Held in* role picker offers exactly Primary, Hot standby, Cold standby, Backup in that order; existing Physical mappings read Backup; both detail pages show the new words.