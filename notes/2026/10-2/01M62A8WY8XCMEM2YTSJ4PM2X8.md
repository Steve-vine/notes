---
id: 01M62A8WY8XCMEM2YTSJ4PM2X8
created: 2026-10-28T22:32:12.488949Z
updated: 2026-10-29T13:23:47.333971Z
type: task
title: The request list — an audit's evidence requests, added by hand or imported from the auditor's spreadsheet, each tied to requirements, with an owner, a due date and a status; owners see theirs in Actions
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1427
sprint: swcbxt0
blocked_by:
- 01M62A88NQZZ9XE6GFATXQQBRY
assignee: steve
label:
- feature
priority: high
task_status: active
---
Sprint 97, Audit Management (ADR 0133, COM-1425).

## What people see

- **Audit ▸ <audit> ▸ Requests:** a table showing the auditor's ref, request, requirements (chips), owner, due date, status and evidence count.
  - Progress across the top: "48 requests · 31 accepted · 9 provided · 6 open · 2 need more".
  - Filters by status, owner and framework; overdue shown in red; sortable.
- **Add a request:**
  - the auditor's ref (e.g. "A.5.15-01") and wording;
  - **requirements**: picked from the audit's frameworks, searchable by ref or text. Core controls can be picked too;
  - owner, due date, and an internal note.
- **Import from spreadsheet** (CSV or Excel):
  - upload the file, pick the sheet, then **match the columns** (ref, request, requirement refs, due date, owner email); Compass guesses from the headings;
  - a **preview** shows each row as it will be added, with requirement refs that weren't recognised flagged (kept as text, matched later);
  - importing again with the same refs **updates** those rows and adds new ones, never duplicates.
- **Bulk:** assign an owner and set a due date across selected requests.
- **Status:** Open → Provided → Accepted, or **Need more** → Provided again; or **Withdrawn** (with a reason). Accepted and Need more are set by the auditor (COM-1430 / COM-1432). Provided is set by providing evidence (COM-1428).
- **Actions:** each owner sees "Provide evidence for AUD-12 request A.5.15-01, due 14 Nov". Overdue requests escalate to the audit lead. Need more puts the request back in the owner's Actions with the auditor's comment.
- **Export** the list as Excel, in the auditor's column order, with status and the names of the evidence provided.

## Who can do what

- *Manage audits* adds, imports, edits, withdraws and assigns.
- The owner of a request sees it and works it without *Manage audits*.
- *View audit* reads everything.

## Notes (technical)

- New table `audit_requests(audit_id, auditor_ref, text, owner_id, due_on, status, withdrawn_reason, internal_note)`, plus `audit_request_targets(request_id, framework_requirement_id | core_control_id, unmatched_ref)`.
- The import parses in the worker, previews in the API, then applies. It's idempotent on (audit, auditor_ref). Reuse the DDQ spreadsheet reader if it fits (sprint 84/85 Excel handling).
- Add an Actions source for request owners and overdue requests, as ADR 0055 says: declare a source, don't write `notify()`.
- Requirements: look them up by the framework's own ref, scoped to the audit's frameworks. Keep unmatched refs as text so a later library change can match them.

**Chain:** on the chain (migration + API).

**Done when:** on staging, Steve imports a 40-row PBC spreadsheet, fixes two unmatched refs, assigns owners in bulk, and an owner sees their requests in Actions.