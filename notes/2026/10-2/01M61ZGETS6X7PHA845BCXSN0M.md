---
id: 01M61ZGETS6X7PHA845BCXSN0M
created: 2026-10-28T19:24:05.849229Z
updated: 2026-10-29T05:00:08.612969Z
type: task
title: Polaris works the continuity picture — it drafts a business impact analysis, links runbooks to systems, records an exercise's results, and answers "what can't we recover in time?"
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1414
sprint: stqs5r1
blocked_by:
- 01M61ZG5CMEMCXKME1H911SPTC
assignee: steve
label:
- feature
priority: medium
task_status: active
---
Sprint 95, Business Continuity (ADR 0131, COM-1407). Builds on COM-1408..1413. Polaris works as the person, with exactly their role (ADR 0127).

## What people see

Asking Polaris:
- "Start a BIA for Payroll and Customer support" — it starts one and fills functions, impact grids, targets and dependencies from what it's told, asking for anything missing. Submitting for approval is fine; **it never approves** (a sign-off), and nobody approves their own.
- "Which systems can't we recover in time?" / "What's never been tested?" — the Continuity view's flags, by function.
- "Link the DR-03 runbook to the CRM" — the link.
- "Record the DR test: passed, CRM back in 3 hours, 20 minutes of data lost" — completes the SAP exercise with the result and times, as on screen (evidence files stay on screen, ADR 0115 §14).
- "When was the payroll runbook last tested?" — the Tested card.

## Notes (technical)

- New tools (auto-discovered): `risk_assessments_*` for BIA functions / impacts / targets / dependencies; `inventory_get_continuity` (a system's card), `inventory_link_recovery_runbook` / unlink; `playbook_get_runbook_tests`; `posture_get_continuity`.
- Extend `sap_complete_entry` / `sap_update_entry` / `sap_get_entry` for exercise kind, runbooks, result and times; `risk_assessments_start_assessment` accepts the new kind.
- Destructive / significant flags as the other kinds' tools.

**Chain:** independent (MCP tools only) — merge after the API tasks it reads.

**Done when:** on staging, Polaris drafts a BIA, answers the two questions above from the test data, and records an exercise result that shows on the runbook.