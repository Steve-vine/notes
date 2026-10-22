---
id: 01M5G0ZZM8C7HXFXQ5GNSHSWT8
created: 2026-10-21T20:03:43.368885Z
updated: 2026-10-22T05:41:00.263317Z
type: task
title: The assistant can find evidence as the person — search controls and evidence, say what supports a framework control, list what's out of date or missing, and start an audit pack — but never upload, download or delete a file
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1216
sprint: sno3i7m
blocked_by:
- 01M5G0ZMV7BSJNKPHFF0CFQ3YK
comments:
- id: 01M5H20ZN73RT2H4ZFG24GT8D9
  author: Steve Vine
  at: 2026-10-22T05:40:59.175746Z
  text: |-
    Done — merged in PR #1230.

    - With **View audit**, an assistant can:
      - list a company's evidence, filtered by where it came from, its type or its status;
      - open one piece of evidence with its versions, fingerprint, what it supports (core controls → framework controls) and earlier links;
      - search controls and evidence;
      - list what's out of date or due soon, what's archived, and the deletion log.
    - It can show evidence by core control and by framework control, including "which controls have no evidence" and "which ISO controls have no current evidence". It can open one control or framework control with its assessment, evidence, Evidence of operation and policies.
    - With **Manage evidence**, it can change a file's or link's details (type, what it is, period, valid until, or clear the date so it's worked out from the type again). It can also link evidence to another control or unlink one, and archive with a reason.
    - **Audit packs:** it can make one (a framework or core controls, a period, chosen controls and evidence types, PDF and/or zip). When it's ready, the maker gets the download links; anyone else is told only the maker can download it.
    - It never uploads, downloads, replaces or adds a file, and never runs download-and-delete. It says those are done on screen.

    My calls (beyond the task):
    - **16 tools.** None is marked as destructive: archiving keeps the evidence, and unlinking keeps the history.
    - **Making a pack needs only View audit**, as on screen.
    - **Links:** adding or replacing a link isn't offered through the assistant; the task didn't list it.
    - **Finding evidence:** it's found by name, file name, address or id, current first and then archived. If a name matches more than one, it lists them and asks which.
    - **Big lists** show up to 100 rows and say when there are more.
assignee: steve
label:
- feature
priority: medium
task_status: review
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