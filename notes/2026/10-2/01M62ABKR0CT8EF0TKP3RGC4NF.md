---
id: 01M62ABKR0CT8EF0TKP3RGC4NF
created: 2026-10-28T22:33:41.376736Z
updated: 2026-10-30T08:01:13.288808Z
type: task
title: Polaris and audits — Polaris can read an audit's progress, set up its request list from the auditor's spreadsheet or email, suggest evidence for each request, and draft corrective action plans; it never gives an auditor's verdict
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1434
sprint: swcbxt0
blocked_by:
- 01M62AB9KWXSEJVKQKG17M97BS
comments:
- id: 01M64CE4MHYGFQF8ZVNEZTVAKC
  author: Steve Vine
  at: 2026-10-29T17:48:30.224617Z
  text: |-
    Done — PR #1451 (stacked on #1450). No migration.

    What's there: nine Polaris tools (also over MCP) — audit_list_audits and audit_get_audit ("how is the ISO audit going?": counts, overdue and who owns it, unowned, waiting on the auditor, findings by grade); audit_list_requests; audit_preview_requests_import then audit_import_requests (Polaris sets out the auditor's list, shows what it will add or update and asks about references it didn't recognise before adding anything); audit_suggest_request_evidence and audit_provide_evidence; audit_list_findings and audit_draft_corrective_action (saved as a draft; the screen says "Drafted by Polaris — check it before submitting"). The MCP instructions have an Audit ▸ Audits paragraph. In the Polaris window on any /audit page, these are the tools it reaches for first.

    My calls, for you to overturn:
    1. Adding evidence through Polaris always asks first (the owner's agreement), and doesn't mark the request Provided — the owner does that on screen.
    2. Polaris sets up requests from rows it reads out of a pasted list or spreadsheet text; it doesn't open uploaded spreadsheets itself (the screen's Import does that).
    3. No tool exists for verdicts, recording verdicts, inviting/extending/revoking auditors, submitting a plan or closure, or closing an audit — not offered at all, rather than offered with a question.
assignee: steve
label:
- feature
priority: medium
task_status: done
---
Sprint 97, Audit Management (ADR 0133, COM-1425).

## What people see

In Polaris (and over MCP), someone can ask:
- "How is the ISO audit going?" Polaris gives counts by status, what's overdue and who owns it, and what's waiting on the auditor.
- "Here's the auditor's PBC list" (a spreadsheet or pasted email). Polaris sets up the requests, matches requirement refs, and asks about anything it couldn't match. The import preview rules apply: Polaris shows what it will add before adding it.
- "What evidence do we have for A.8.15?" Polaris lists the suggestions with their dates and flags the out-of-date ones. With the owner's agreement, it provides them to the request.
- "Draft a corrective action plan for F3." Polaris writes the correction, root cause and corrective action from the finding, the gap and the control's guidance, and saves them as a draft. A person submits it to the auditor.

Polaris **never**:
- gives or records an auditor's verdict;
- invites, extends or revokes an auditor;
- submits a plan or closure to the auditor;
- closes an audit.

These are sign-offs or reach outside the organisation (ADR 0127's ask-before-change rules: these aren't even offered).

## Who can do what

Polaris acts as the person, with their permissions (ADR 0109).

## Notes (technical)

- Tools, auto-discovered:
  - `audit_list_audits`, `audit_get_audit`;
  - `audit_list_requests`, `audit_preview_requests_import`, `audit_import_requests`;
  - `audit_suggest_request_evidence`, `audit_provide_evidence`;
  - `audit_list_findings`, `audit_draft_corrective_action`.
- Add them to the in-API Polaris tool list (ADR 0127), and add an Audit paragraph to the MCP server instructions.
- Pasted email text is data, not instructions, the same as DDQ questionnaires.

**Chain:** on the chain (API: MCP tool list).

**Done when:** on staging, Polaris sets up an audit's requests from a pasted list, suggests evidence for one request, and drafts a corrective action plan that Steve then submits.