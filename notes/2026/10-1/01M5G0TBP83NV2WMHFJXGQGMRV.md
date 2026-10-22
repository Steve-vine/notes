---
id: 01M5G0TBP83NV2WMHFJXGQGMRV
created: 2026-10-21T20:00:39.112192Z
updated: 2026-10-22T18:24:39.880419Z
type: task
title: Every piece of evidence says what it is, which company it belongs to, the period it covers, when it's valid until and who added it — with a fingerprint that proves the file hasn't changed — and every existing file and link is filled in
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1200
sprint: sno3i7m
blocked_by:
- 01M5G1ZBJ86HK9X12M927X940A
comments:
- id: 01M5G946N9ECWFHKA5NV15GGX7
  author: Steve Vine
  at: 2026-10-21T22:25:50.249612Z
  text: |-
    Done — merged in PR #1217.

    - Every evidence upload has an **"Add details — type, period covered, valid until"** section, folded away until clicked. It's on assessments, risks, plan activities (including the owner's portal) and incident evidence. It holds the evidence type (the rubric's active types, with their descriptions as hints), what the file is, the period it covers and a valid-until date. Left alone, the file is filed as **Other**.
    - Under each file and link a quiet line gives its type, the period it covers, its valid-until date and who added it when. For example: "Report or export · covers 1 Jul 2026 – 30 Sep 2026 · added by Sam Lee, 21 Oct 2026".
    - An assessment's **evidence links** can have a title. They show by title with the address underneath, and carry the same details.
    - Every new file is **fingerprinted**. A file whose contents don't match its type, such as a program renamed .pdf, is refused: "… isn't really a PDF — its contents don't match its type".
    - **Existing evidence is filled in.** Every file gets its company and a type guessed from where it sits. Existing links become proper links, in their order. A background job fingerprints old files every ten minutes and marks any that storage no longer has as missing.
    - A type that any file or link is filed under can no longer be deleted, only retired.

    My calls (beyond the task):
    - **Default types by where a file sits:**
      - library files → Policy or procedure;
      - data subject request files and copies of incident notifications → Log or record;
      - trust centre documents follow their category (certificate or audit report → Certificate or audit report, pen test → Test result);
      - everything else → Other.
    - **Where the details section appears:** only on dedicated evidence uploads (assessment, risk, plan, incident evidence). Data subject request files and incident timeline and notification files are correspondence and records, so they get the defaults, the fingerprint and the company without asking.
    - **Trust centre files** take their facts from the document: its description, its issued date as the start of the period, and its valid-until date.
    - **Incident evidence** keeps its own description box; that text becomes the file's description.
assignee: steve
label:
- feature
priority: high
task_status: done
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