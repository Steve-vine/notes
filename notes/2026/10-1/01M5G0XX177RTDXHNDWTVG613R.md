---
id: 01M5G0XX177RTDXHNDWTVG613R
created: 2026-10-21T20:02:35.17542Z
updated: 2026-10-21T20:04:45.157294Z
type: task
title: Replacing evidence archives the old version — it stays, can still be opened, and still shows what it supported and when; removing a file from an assessment or risk becomes archiving it with a reason; an Archived tab lists it all
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1211
sprint: sno3i7m
assignee: steve
label:
- feature
priority: high
task_status: todo
---
Sprint 82, Evidence (ADR in COM-1198). Builds on COM-1210.

**Chain:** on the chain — migration + API

## What people see

**Replace with a new version** on any standing evidence:
- Upload the new file, or give the new link.
- The new version takes the old one's place, kind, description and linked controls.
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