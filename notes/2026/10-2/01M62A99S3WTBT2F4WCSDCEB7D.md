---
id: 01M62A99S3WTBT2F4WCSDCEB7D
created: 2026-10-28T22:32:25.635938Z
updated: 2026-10-29T14:51:58.156815Z
type: task
title: Providing evidence for a request — pick it from the Evidence register (Compass suggests what's already filed against the requirement), or upload it once into the register; what's provided is frozen as the auditor saw it
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1428
sprint: swcbxt0
blocked_by:
- 01M62A8WY8XCMEM2YTSJ4PM2X8
comments:
- id: 01M642AVRR8BFCNTDJN2C16WCS
  author: Steve Vine
  at: 2026-10-29T14:51:57.080114Z
  text: |-
    Done — PR #1445 (auto-merge on). Migration 0734.

    What's there: in a request's panel, Evidence provided and Add evidence — Suggested (what the register holds against the request's requirements, newest first, amber when it doesn't cover the audit's period, a warning before adding restricted evidence), Search the register, From Compass (the control's Evidence of operation and check history over the audit's period, made as a PDF and filed in the register as a report), and Upload (into the register, linked to the request's controls). Provide / Provide again. Each piece is pinned to the version provided; "A newer version exists: X" offers Provide this one too. Take off before the auditor has seen it; Withdraw with a reason after.

    My calls, for you to overturn:
    1. A request's owner can upload into the register for their own request without Manage evidence; choosing from the register needs View audit.
    2. The audit's period is the SOC 2 observation period, otherwise the planned end; for generated evidence, the twelve months up to the planned end.
    3. Generated evidence is offered per control the request is about.
    4. Adding evidence doesn't mark the request Provided — Provide is its own button, so the owner decides when it's complete.
    5. Before Provide, the note to the auditor is a shared comment (COM-1430), not a field on Provide.
assignee: steve
label:
- feature
priority: high
task_status: review
---
Sprint 97, Audit Management (ADR 0133, COM-1425).

## What people see

- **A request's panel** (from the Requests table): the request, its requirements, its comments (COM-1430), and **Evidence provided**.
- **Suggested evidence**: Compass lists what the register already holds against the request's requirements and their mapped core controls, newest first. Each item shows its type, the period it covers and whether it's in date.
  - **Out of date** for the audit's period is marked in amber ("Covers to 30 Jun; the audit covers to 30 Sep").
  - **Evidence of operation** and **check history** (sprint 96) for those controls are offered as generated evidence. Compass renders them as a PDF for the period when provided.
- **Add evidence:**
  - **choose** from the suggestions or search the whole register;
  - or **upload** a new file, which goes into the register with its type, period and valid-until (ADR 0122 §4) and is linked to the request's controls there too.
- **Provide**: marks the request **Provided** (or Provided again after Need more), with who and when. Before providing, the owner can add a **note to the auditor**, a shared comment.
- **Frozen as provided:** what the auditor sees is the exact version provided. If the evidence is later replaced in the register, the request shows "A newer version exists". The owner can provide the newer one as well. The first stays.
- **Removing** evidence from a request is allowed only before the auditor has seen it (no portal view, no Accepted). After that it's **withdrawn**, with a reason, and the auditor sees it marked withdrawn.
- **Restricted evidence** (a restricted incident, a DSR) can't be provided unless the person providing can see it, and it warns: "This will be visible to the auditors of AUD-12".

## Who can do what

- The request's owner or anyone with *Manage audits* can provide evidence.
- Choosing from the register needs *View audit*; uploading needs *Manage evidence*, or the owner's existing right to the evidence's home.

## Notes (technical)

- New table `audit_request_evidence(request_id, attachment_id, attachment_version_id, provided_by, provided_at, withdrawn_at, withdrawn_reason, seen_by_auditor_at)`, which pins the attachment version.
- Suggestions come from the register's existing by-framework-requirement and by-core-control queries (`api/v1/audit_evidence.py`). Don't build a second evidence search.
- Generated evidence (Evidence of operation, check history) is rendered to PDF at provide time and stored as an attachment of type "Report or export", so it's frozen.

**Chain:** on the chain (migration + API).

**Done when:** on staging, an owner provides two suggested files and one new upload for a request. The upload appears in Audit ▸ Evidence, and replacing a file in the register shows "A newer version exists" on the request.