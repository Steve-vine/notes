---
id: 01M5G0TBP83NV2WMHFJXGQGMRV
created: 2026-10-21T20:00:39.112192Z
updated: 2026-10-21T20:21:22.302825Z
type: task
title: Every piece of evidence says what it is, which company it belongs to, the period it covers, when it's valid until and who added it — with a fingerprint that proves the file hasn't changed — and every existing file and link is filled in
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1200
sprint: sno3i7m
blocked_by:
- 01M5G1ZBJ86HK9X12M927X940A
assignee: steve
label:
- feature
priority: high
task_status: todo
---
Sprint 82, Evidence (ADR in COM-1198). Builds on COM-1217, the Evidence types rubric. Everything in the register rests on these facts.

**Chain:** on the chain — migration + API

## What people see

- Adding a file anywhere — an assessment, a risk, a plan activity, an incident, a data subject request, a trust centre document — asks for:
  - **What it is**: a short description (optional).
  - **Evidence type**: chosen from the Evidence types rubric (COM-1217), with each type's description as a hint. Defaults to Other.
  - **Period covered**: from and to (optional).
  - **Valid until** (optional; the default comes from the type's validity, COM-1210).
- Wherever files are listed, each one shows its evidence type, the period it covers, who added it and when. The upload date is recorded today but never shown.
- An assessment's **evidence links** become proper items with a title and the same facts, instead of bare web addresses.
- Every file gets a **fingerprint** (SHA-256) when it's added, shown on its detail. A file whose contents don't match its type (an .exe renamed .pdf) is refused. Today only trust centre PDFs are checked; everything else trusts what the browser says.
- **Existing evidence:**
  - Every file and link already in Compass gets its company and an evidence type guessed from where it sits: a trust centre certificate or audit report becomes "Certificate or audit report", a trust centre pen test "Test result", most others "Other". It also keeps its uploader and date as already recorded.
  - Fingerprints are worked out in the background.
  - A file that turns out to be missing from storage is marked missing, not skipped.
  - Nothing is moved or renamed.

## Notes (technical)

- `attachments` gains `company_id` (backfilled from the owner), `evidence_type_id` (FK to `evidence_types`), `description`, `period_start`/`period_end`, `valid_until`, `sha256`.
  - Links get their own evidence-link rows (url, title, same facts).
  - `assessments.evidence_links` is migrated into them; the JSONB stays read-only so revision history keeps reading until COM-1212.
- The SHA-256 is computed on upload. The backfill is an idempotent Celery task that takes ids in batches; missing objects are recorded (the admin Files check already probes for them).
- Magic-byte content check in `core/uploads.py`, the way trust centre uploads already check PDFs.
- `company_id` also lets Activity's company filter find file changes (COM-1204).

**Done when:**
- a new upload in each module records all the facts, its evidence type and its fingerprint;
- every existing attachment and link has a company and an evidence type;
- fingerprints are filled in for every file still in storage;
- a renamed executable is refused.