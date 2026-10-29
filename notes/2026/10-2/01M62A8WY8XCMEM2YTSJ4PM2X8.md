---
id: 01M62A8WY8XCMEM2YTSJ4PM2X8
created: 2026-10-28T22:32:12.488949Z
updated: 2026-10-29T14:11:44.32864Z
type: task
title: The request list — an audit's evidence requests, added by hand or imported from the auditor's spreadsheet, each tied to requirements, with an owner, a due date and a status; owners see theirs in Actions
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1427
sprint: swcbxt0
blocked_by:
- 01M62A88NQZZ9XE6GFATXQQBRY
comments:
- id: 01M64016GNNTM8R099NE4MS158
  author: Steve Vine
  at: 2026-10-29T14:11:43.253196Z
  text: |-
    Done — PR #1444 (auto-merge on). Migration 0733.

    What's there: the audit's Requests tab (progress line, filters, sorting, overdue in red, unrecognised references flagged), Add request, Import from spreadsheet (sheet, heading row and columns guessed and changeable, a preview with problems, then Import — re-importing updates by the auditor's reference and never duplicates), Bulk owner and due date, Withdraw with a reason, Export for the auditor. Actions: the owner gets "Provide evidence for AUD-n request X"; the lead gets requests nobody owns ("Assign an owner…") and overdue ones.

    My calls, for you to overturn:
    1. A request's owner who can't otherwise see audits can open the audit and see only their own requests (no trail, no register).
    2. The export for the auditor leaves out owners' names and internal notes.
    3. Unrecognised references are kept as text and shown as "X.1 ?" until someone picks what they meant.
    4. A reference missing from a later import is left alone (not withdrawn).
    5. The import reads the file in the request, not on the worker — files are small and the preview is instant. The task note said worker.
    6. The request opens in a side panel over the list; the Actions link opens it directly.
    7. Status colours: Open blue, Provided cyan, Accepted teal, Need more orange, Withdrawn grey.

    Known: if a different company is selected when an owner opens an Actions link, the audit page says "not found" — fixed in COM-1430's screens (the page finds the audit's company).
assignee: steve
label:
- feature
priority: high
task_status: review
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