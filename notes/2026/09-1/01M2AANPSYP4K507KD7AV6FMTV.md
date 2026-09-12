---
id: 01M2AANPSYP4K507KD7AV6FMTV
created: 2026-09-12T08:10:20.350452Z
updated: 2026-09-12T08:10:22.658034Z
type: task
title: Data asset ▸ technology asset roles become Primary, Hot standby, Cold standby, Backup
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 687
sprint: skdc1az
assignee: steve
label:
- improvement
priority: low
task_status: todo
---
Requested by Steve, 2026-09-12: on the data asset form, the role a technology asset plays for the data it holds is **Primary · Hot standby · Cold standby · Backup** — the resilience vocabulary, not the storage-medium one. "Physical" goes.

* `DataAssetContainerRole` (`primary | backup | physical`) → `primary | hot_standby | cold_standby | backup`, in that display order. The Postgres enum gains the two new values; `physical` stays in the enum (cannot be dropped) but the API stops offering it and `CONTAINER_ROLE_LABELS` lists four.
* Migration: existing `physical` mappings → `backup` (the closest meaning: a filing cabinet or tape store holds a copy, not the system of record); logged with a count. Append-only, one head.
* Labels on the data asset modal's *Held in* rows, the data asset detail's technology assets section, the technology asset detail's *Data held* section, the CSV template's role column (accepts the four labels or identifiers; `physical` on import is a row error), and the portal edit form.
* ADR 0072 §1 one-line amendment; model docstring updated.
* Tests: the four options round-trip, the migration's mapping, the importer rejecting `physical`. Regenerate `schema.d.ts`.

**Acceptance**: the *Held in* role picker offers exactly Primary, Hot standby, Cold standby, Backup in that order; existing Physical mappings read Backup; both detail pages show the new words.