---
id: 01M5G0XX177RTDXHNDWTVG613R
created: 2026-10-21T20:02:35.17542Z
updated: 2026-10-22T18:24:39.951312Z
type: task
title: Replacing evidence archives the old version — it stays, can still be opened, and still shows what it supported and when; removing a file from an assessment or risk becomes archiving it with a reason; an Archived tab lists it all
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1211
sprint: sno3i7m
blocked_by:
- 01M5G0XHFREVF80S514XTW0HTY
comments:
- id: 01M5GT4991BV606WQ3B30PJ9YE
  author: Steve Vine
  at: 2026-10-22T03:22:58.721745Z
  text: |-
    Done — merged in PR #1225.

    - **New version.** Assessment and risk files, evidence added in Audit ▸ Evidence, and links can all get a new version. The new one keeps the old one's type, what it is and the controls it was linked to. The old one is archived ("Replaced by a newer version") and still opens and downloads.
    - **Versions** are listed on the evidence's page, each with the dates it was current, its fingerprint and a download.
    - **Remove is now Archive** on assessment and risk files, and it always asks why. Taking a link off an assessment archives it as "Taken off the assessment".
    - Each card shows "N archived", folded away, with what each file was, why it was archived, when and by whom.
    - **Audit ▸ Evidence ▸ Archived** lists everything archived, newest first, with why, when, by whom and the reason given. "Include archived" in search now finds archived evidence.
    - An archived version's page says it's archived and why, links to the current version, and can't be changed, linked or replaced.
    - **Trust centre:** replacing a PDF keeps the old one as an earlier version, with its own issued and valid-until dates.
    - **Library:** replacing an uploaded policy's file keeps the previous one under "Earlier files" on its page, downloadable.
    - Activity says "archived attachment X on ACC.4 — Superseded" and "replaced attachment X … with version 2", not "deleted".

    My calls (beyond the task):
    - **Files removed before this change** show in Archived as "Removed before archiving existed". Files a plan activity, incident or data subject request removes under its own rules show as "Removed from its record"; those modules' rules are unchanged.
    - **Controls move with a replacement.** Linked controls move to the new version, and an archived version still shows the ones it supported while it was current.
    - **What carries over:** the new version's period and valid-until are its own. Its type and description carry over unless new ones are given.
    - **Not in the Archived tab:** a library document's earlier files (they're on its own page) and a deleted trust centre document's files.
assignee: steve
label:
- feature
priority: high
task_status: done
---
Sprint 82, Evidence (ADR in COM-1198). Builds on COM-1210.

**Chain:** on the chain — migration + API

## What people see

**Replace with a new version** on any standing evidence:
- Upload the new file, or give the new link.
- The new version takes the old one's place, evidence type, description and linked controls.
- The old one becomes **Archived**: "Replaced by v3 on 21 Oct 2026 by Steve Vine".

**Versions** are listed on the evidence's detail (v1, v2, v3). Each one can be downloaded and shows its fingerprint and the dates it was the current version.

**Archive instead of remove:**
- **Remove** on an assessment's or risk's file becomes **Archive**, and asks for a reason. Nothing disappears without a trace.
- The card shows "2 archived", which expands.
- Modules that already lock their evidence — the plan, incidents, data subject requests — keep their own rules.

**The Archived tab** lists everything archived for the company, with why (replaced, archived with a reason, or its control retired), when and by whom. View audit can open and download all of it.

**Trust centre documents:** replacing a PDF already keeps the old file. Now it's listed as an archived version with its own issued and valid-until dates; today those dates are overwritten.

**Policy library:** uploading a new file for an uploaded policy keeps the previous file as an archived version, reachable from the policy's versions. Today the old file is lost from view.

**Archived evidence** never counts as current and never warns.

## Notes (technical)

- On evidence rows: `version`, `replaces_id` / `replaced_by_id`, `archived_at`, `archived_by`, `archive_reason`, `archive_cause` (replaced / archived / control retired).
- The existing soft-deleted attachments are migrated to Archived, with cause "removed before archiving existed".
- `content_versions` gets the file reference for uploaded content (`api/v1/content.py` currently overwrites `storage_key`).
- Trust centre `replace_file` keeps the old dates on the archived version.

**Done when:**
- replacing an assessment file leaves v1 archived and downloadable, with v2 current and supporting the same controls;
- removing a risk file asks for a reason and leaves it in Archived;
- a policy's previous uploaded file can be downloaded from its versions.