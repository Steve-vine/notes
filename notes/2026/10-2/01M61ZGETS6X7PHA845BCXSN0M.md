---
id: 01M61ZGETS6X7PHA845BCXSN0M
created: 2026-10-28T19:24:05.849229Z
updated: 2026-10-29T08:13:28.02806Z
type: task
title: Polaris works the continuity picture — it drafts a business impact analysis, links runbooks to systems, records an exercise's results, and answers "what can't we recover in time?"
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1414
sprint: stqs5r1
blocked_by:
- 01M61ZG5CMEMCXKME1H911SPTC
comments:
- id: 01M634K1SPC5PWA77F8VFKW9PP
  author: Steve Vine
  at: 2026-10-29T06:12:08.118827Z
  text: |-
    Done — merged to main (PR #1431).

    What Polaris can now do:
    - "Start a BIA for Payroll and Customer support": starts one (kind business_impact_analysis, from nothing or from the last approved one) and adds each business function — owner, what it does, the impact grid (level numbers or the scale's words like "Major"), tolerable period, RTO/RPO in plain lengths ("4 hours", "a day"), systems/data assets (AST-n, DAT-n or names), vendors, people and sites. It asks for what's missing and explains a refusal plainly (e.g. RTO longer than the tolerable period). It can submit for approval; there is no approve tool — approving stays the approver's own act on screen. Removing a function asks first.
    - "Which systems can't we recover in time?" / "What's never been tested?": reads Posture ▸ Continuity by function, flagged only or one flag.
    - "Link the DR-03 runbook to the CRM": links it (unlink asks first); it can also read a system's Continuity card.
    - "Record the DR test: passed, CRM back in 3 hours, 20 minutes of data lost": sets the exercise up if needed (kind + runbooks) and marks it done with the result and per-system times — Mark done still asks before it acts. Evidence files stay on screen.
    - "When was the payroll runbook last tested?": the runbook's test record (or "Never tested" / "No test planned").
    - Its instructions now describe the BIA, runbooks, exercises and Continuity.

    My calls:
    - A bare number for a length of time ("4") is refused rather than guessed as hours or days.
    - A runbook is found by slug, exact title, part of the title, then all the words given — so "DR-03" finds "DR-03 Restore the CRM".
    - Correcting an exercise's result/times through Polaris wasn't added (not asked for); it's on screen.
assignee: steve
label:
- feature
priority: medium
task_status: done
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