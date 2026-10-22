---
id: 01M5G0ZMV7BSJNKPHFF0CFQ3YK
created: 2026-10-21T20:03:32.327871Z
updated: 2026-10-22T18:24:39.978246Z
type: task
title: Download and delete archived evidence older than a chosen date — see what would go, download it all first, then delete it for good, with a deletion log that keeps what went, who deleted it and why
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1215
sprint: sno3i7m
blocked_by:
- 01M5G0Z9M6YVT6F5TKS6E3ATEX
comments:
- id: 01M5H0REZ40NSKAJERCK7SAPCE
  author: Steve Vine
  at: 2026-10-22T05:18:51.364819Z
  text: |-
    Done — merged in PR #1229.

    - **Audit ▸ Evidence ▸ Archived** now switches between **Archived** and **Deletion log**. Anyone with Delete archived evidence also gets a red **Download and delete…** button. It doesn't appear on an archived company.
    - **Step 1, pick a date** (a year ago by default). The preview shows how many pieces, how big, a breakdown by where they came from and by type, and what's **never included** and why, e.g. "Incident: 2 pieces — Nothing on an incident is ever deleted".
    - **Step 2, download.** "Build the download" makes a zip of exactly those pieces: a folder per record they came from, plus an index (CSV and text) with fingerprints. Delete only becomes available once the whole zip has downloaded, and only within seven days.
    - **Step 3, delete.** Type the date again, say why, then "Delete N pieces for good". The files are removed from storage. Anything that no longer qualifies by then is kept and counted.
    - **The deletion log** keeps, for every piece: its name, type, version, size, fingerprint, where it came from, the controls it supported, when it was added and archived (and why), and who deleted it, when and why. It can never be changed.
    - **Activity** records the request, the download and each piece deleted.
    - **History still tells the story.** An assessment's version shows "q1.pdf (since deleted for good)", with a "Deleted q1.pdf for good — in the deletion log" entry saying who did it.

    My calls (beyond the task):
    - **Stricter than the task on what's never deleted:**
      - incident evidence, open or closed, because the incident register deletes nothing;
      - plan activity files, because the plan keeps its own record;
      - data subject requests, entirely, which also covers legal holds (only requests have them).
      - What can go: archived assessment and risk files and links, evidence added in Audit, the trust centre's earlier PDFs, and vendors' archived certificates.
    - **What counts as downloaded:** only a download that reached its last byte. One that broke off part-way doesn't unlock delete.
    - **Who can download and delete:** only the person who started the run, as with audit packs. Anyone with View audit can see the runs and the log.
    - **Archived before a date** means before the start of that day, on the person's own clock. A date in the future is refused.
    - **Links made by hand** to a deleted version are unlinked. Links that had already moved to a newer version stay.
assignee: steve
label:
- feature
priority: medium
task_status: done
---
Sprint 82, Evidence (ADR in COM-1198). Builds on COM-1214 (reuses its zip builder) and COM-1211 (archiving).

**Chain:** on the chain — migration + API

## What people see

**Audit ▸ Evidence ▸ Archived ▸ Download and delete…** needs **Delete archived evidence** (marked dangerous).

1. **Pick a date.** Everything archived before it is listed before anything happens: the count, the total size, and a breakdown by where it came from and by evidence type.
2. **What is never included:**
   - evidence that isn't archived;
   - evidence on an open incident or under a legal hold;
   - data subject requests, which have their own retention rules;
   - library content (its versions have their own history).
3. **Download first.** A zip of exactly those items, with an index, is built in the background.
4. **Then delete.** Delete is offered only once that zip has been downloaded. It asks for the date to be typed again and for a reason.

**What delete does:**
- It removes the files from storage for good.
- The **deletion log**, under the Archived tab, keeps for every item: its name, evidence type, where it came from, the controls it supported, its fingerprint, when it was added and archived, and who deleted it, when and why.
- The log can never be changed or deleted.
- Activity records the run.

One company at a time, following the company picker.

Everything else is kept forever (Steve, 2026-10-21).

## Notes (technical)

- Modelled on data privacy retention: an insert-only `evidence_deletion_log` with no foreign keys, so it can't be cascaded away, and an ORM guard on update and delete. It stores the evidence type's name as text, so renaming or retiring a type later doesn't change the log.
- Per-item commits; idempotent Celery task taking the run id; the bytes are deleted from each file's own store (`store_ref`).
- The run records which zip was downloaded, and by whom, before delete is enabled.

**Done when:**
- choosing a date lists only archived items before it (none from open incidents or data subject requests);
- delete stays unavailable until the zip has been downloaded;
- afterwards the files are gone from storage and every one is in the deletion log.