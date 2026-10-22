---
id: 01M5G0Z9M6YVT6F5TKS6E3ATEX
created: 2026-10-21T20:03:20.838387Z
updated: 2026-10-22T04:01:18.507487Z
type: task
title: Build an audit pack — choose a framework (or core controls) and a period, and get a PDF index of every framework control with its core controls, assessment, evidence and Evidence of operation, plus a zip of every file with its fingerprint
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1214
sprint: sno3i7m
blocked_by:
- 01M5G0YRAWE31YZBN55V9VEZ53
assignee: steve
label:
- feature
priority: high
task_status: active
---
Sprint 82, Evidence (ADR in COM-1198). Builds on COM-1213 (chain order); uses By framework (COM-1207), out of date (COM-1210), versions (COM-1211) and the export fixes (COM-1204).

**Chain:** on the chain — migration + API

## What people see

**Audit ▸ Evidence ▸ Audit packs ▸ New audit pack:**
- the company (the one picked);
- a framework, or **Core controls**;
- optionally only some of its controls (tick a list, or "only those with evidence");
- optionally only some evidence types (e.g. just certificates and test results);
- the **period**, from and to;
- a **PDF index**, a **zip of files**, or both.

**The PDF index** (house style):
- **Cover**: company, framework, period, made by, made on.
- **Summary**: how many framework controls are covered, how many have current evidence and how many have none, plus a table of all of them and a count by evidence type.
- **Then, for each framework control:**
  - the core controls that cover it (full or partial);
  - each core control's assessment status and last review;
  - its evidence: name, evidence type, period covered, valid until, added by and on, fingerprint, and where the file is in the zip;
  - its Evidence of operation during the period;
  - the policies covering it, with their version.

**Which evidence goes in:**
- everything that was current at any time during the period, including versions since replaced. These are labelled "replaced on …", so the auditor sees what you had then.
- Out-of-date evidence is included and marked.
- Evidence from a restricted incident or a data subject request goes in only if the person making the pack can see it.

**The zip:**
- one folder per core control;
- each file appears once, even if it supports many controls, and the index says which framework controls each one supports;
- each file's fingerprint is in the index, so an auditor can check nothing was changed afterwards.

**Building and keeping:**
- The pack is built in the background, and the person sees it in the list when it's ready.
- The **Audit packs** tab lists every pack: who made it, when, and for what.
- A pack downloads for **30 days** *(my call)*; its record is kept forever.
- Making and downloading a pack are both recorded in Activity.
- Needs **View audit**.

## Notes (technical)

- An `audit_packs` table (company, framework or core, requirement subset, evidence-type filter, period, parts, requested by, output keys and refs recorded on the row as fixed in COM-1204, status). Celery task, idempotent, takes the id. Files are streamed into the zip (no whole-file reads), missing files noted in the index (as the plan's zip does).
- "Current at any time in the period" uses the version dates from COM-1211.
- PDF via the house-style renderer used by the plan export.

**Done when:** a pack for ISO 27001, the last 12 months, gives a PDF whose every framework control lists its evidence, and a zip whose files match the fingerprints in the index; a version replaced mid-period is in it, labelled.