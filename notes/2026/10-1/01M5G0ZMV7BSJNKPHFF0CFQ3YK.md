---
id: 01M5G0ZMV7BSJNKPHFF0CFQ3YK
created: 2026-10-21T20:03:32.327871Z
updated: 2026-10-21T20:05:19.851395Z
type: task
title: Download and delete archived evidence older than a chosen date — see what would go, download it all first, then delete it for good, with a deletion log that keeps what went, who deleted it and why
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1215
sprint: sno3i7m
blocked_by:
- 01M5G0Z9M6YVT6F5TKS6E3ATEX
assignee: steve
label:
- feature
priority: medium
task_status: todo
---
Sprint 82, Evidence (ADR in COM-1198). Builds on COM-1214 (reuses its zip builder) and COM-1211 (archiving).

**Chain:** on the chain — migration + API

## What people see

**Audit ▸ Evidence ▸ Archived ▸ Download and delete…** needs **Delete archived evidence** (marked dangerous).

1. **Pick a date.** Everything archived before it is listed before anything happens: the count, the total size, and a breakdown by where it came from.
2. **What is never included:**
   - evidence that isn't archived;
   - evidence on an open incident or under a legal hold;
   - data subject requests, which have their own retention rules;
   - library content (its versions have their own history).
3. **Download first.** A zip of exactly those items, with an index, is built in the background.
4. **Then delete.** Delete is offered only once that zip has been downloaded. It asks for the date to be typed again and for a reason.

**What delete does:**
- It removes the files from storage for good.
- The **deletion log**, under the Archived tab, keeps for every item: its name, kind, where it came from, the controls it supported, its fingerprint, when it was added and archived, and who deleted it, when and why.
- The log can never be changed or deleted.
- Activity records the run.

One company at a time, following the company picker.

Everything else is kept forever (Steve, 2026-10-21).

## Notes (technical)

- Modelled on data privacy retention: an insert-only `evidence_deletion_log` with no foreign keys, so it can't be cascaded away, and an ORM guard on update and delete.
- Per-item commits; idempotent Celery task taking the run id; the bytes are deleted from each file's own store (`store_ref`).
- The run records which zip was downloaded, and by whom, before delete is enabled.

**Done when:**
- choosing a date lists only archived items before it (none from open incidents or data subject requests);
- delete stays unavailable until the zip has been downloaded;
- afterwards the files are gone from storage and every one is in the deletion log.