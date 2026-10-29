---
id: 01M61Y8GY7PVADPVQBHPVZ9FQ1
created: 2026-10-28T19:02:17.28742Z
updated: 2026-10-29T08:13:36.60658Z
type: task
title: The Statement of Applicability, the Coverage report and the audit pack say when a control is excepted — who approved it, why, what compensates and until when
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1404
sprint: s81z16q
blocked_by:
- 01M61Y81PRT1YSFJ5BV01875S5
comments:
- id: 01M62MK40Z4EJTPERSNECN40GS
  author: Steve Vine
  at: 2026-10-29T01:32:33.183689Z
  text: |-
    Done — PR #1421 merged.

    What's in it:
    - Statement of Applicability (CSV and XLSX): a requirement whose only shortfalls are excepted controls reads "Excepted". A new last column, "Exception", reads e.g. "R-14 — approved by Jo Bloggs on 3 Mar 2026, until 3 Mar 2027. Why: <rationale>. Compensating: ACC.3, ACC.9". An exception still awaiting approval isn't listed.
    - Coverage report (CSV and PDF): Excepted per row. The summary line now reads "… N met (x%), excepted N (y%), partial …, unmet …, not assessed …, out of scope …".
    - Audit pack: each excepted control's line reads "Partly implemented — excepted until 3 Mar 2027 (R-14, approved by Jo Bloggs)". A new "Exceptions" section lists each with why, compensating controls, owner, approver and date, until, and next review. It's read for the period's last day, so a pack for a past period shows the exceptions that stood then.

    My calls:
    - The Exception column is the SoA's last column, so the columns before it keep their places for anyone reading the file by position.
    - A past-period audit pack uses each acceptance's approval date and expiry. If an acceptance was later closed early, the pack can't know it was still open on that day; it uses the current state.
assignee: steve
label:
- feature
priority: medium
task_status: done
---
Sprint 94, Control Exceptions (ADR 0130, COM-1398). Builds on COM-1403 (the Excepted requirement state). This is what an auditor reads, so the exception must be on the page, not a click away.

## What people see

- **Statement of Applicability** (CSV and XLSX):
  - a requirement that's excepted shows status **Excepted**;
  - a new **Exception** column on every row with one: "R-14 — approved by Jo Bloggs on 3 Mar 2026, until 3 Mar 2027. Why: <rationale>. Compensating: ACC.3, ACC.9";
  - an awaiting one isn't listed (it isn't an exception yet).
- **Coverage report** (CSV and PDF): Excepted joins Met / Partial / Unmet / Not assessed / Out of scope in the counts and per row; the PDF's summary shows met % and excepted %.
- **Audit pack:** each excepted control's line reads "Partial — excepted until 3 Mar 2027 (R-14, approved by Jo Bloggs)", and the pack gains an **Exceptions** section listing each with its justification, compensating controls, owner, approver, dates and review date.

## Notes (technical)

- `api/v1/soa.py` (status labels ~L96, `_build_rows`), `api/v1/reports.py` coverage CSV/PDF, `core/audit_pack.py` (`_STATUS_WORDS`, `_assessment_line`).
- All read the exception rule from COM-1400 for the report's as-of day (an audit pack built for a past period reads the exceptions standing then, from the acceptance's approved/expiry dates).
- MCP tools that parse these CSVs (`overview_statement_of_applicability`, `overview_coverage_report`) are updated in the Polaris task.

**Chain:** on the chain (API output).

**Done when:** Steve downloads the SoA, the Coverage report PDF and an audit pack on staging and each shows the test exception as above.