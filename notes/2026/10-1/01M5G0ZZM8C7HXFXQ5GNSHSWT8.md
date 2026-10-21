---
id: 01M5G0ZZM8C7HXFXQ5GNSHSWT8
created: 2026-10-21T20:03:43.368885Z
updated: 2026-10-21T20:04:52.756957Z
type: task
title: The assistant can find evidence as the person — search controls and evidence, say what supports a framework control, list what's out of date or missing, and start an audit pack — but never upload, download or delete a file
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1216
sprint: sno3i7m
assignee: steve
label:
- feature
priority: medium
task_status: todo
---
Sprint 82, Evidence (ADR in COM-1198). Last: builds on every other task in the sprint.

**Chain:** independent (assistant tools only, no /api/v1 change). Built last because it reads everything the others add.

## What people see

Someone using an AI assistant connected to Compass can ask:
- "What evidence do we have for ISO 27001 A.5.18?"
- "Which SOC 2 controls have no current evidence?"
- "What's going out of date this month?"
- "What does the firewall review support?"
- "Make an audit pack for ISO 27001, last year."

The assistant answers as the person, with the same permissions and the same restricted-evidence rule as on screen.

**What it can't do:**
- upload, download or delete a file;
- download and delete archived evidence.

As elsewhere (ADR 0109), it gives a link to the screen instead. A finished audit pack comes back as a link to download, as reports do.

**What it can change:** with Manage evidence, an evidence item's details and its linked controls, and archiving with a reason.

## Notes (technical)

- `assistant/tools/audit_*.py`, auto-discovered:
  - search, get evidence, evidence for a core control, evidence for a framework control;
  - list out of date, list archived;
  - update details, link / unlink a control, archive;
  - start a pack, list packs.
- Lookups by control key or ref and framework ref in an `audit_common.py`, following `access_common.py`.

**Done when:** each question above gets the same answer the screens give, and a request to upload or delete is refused with a link to the screen.