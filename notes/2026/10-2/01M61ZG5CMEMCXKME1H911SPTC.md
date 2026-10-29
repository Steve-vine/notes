---
id: 01M61ZG5CMEMCXKME1H911SPTC
created: 2026-10-28T19:23:56.180573Z
updated: 2026-10-29T05:54:19.687058Z
type: task
title: 'Posture ▸ Continuity — one view per company: each business function, the systems it needs, how fast they''re needed back against what IT can do, their runbook and its last test, with every gap flagged and an export'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1413
sprint: stqs5r1
blocked_by:
- 01M61ZFSWDG9MGVJE4MKCXBF2C
comments:
- id: 01M633JD2J9NWR99F8NVY5SJ7T
  author: Steve Vine
  at: 2026-10-29T05:54:18.322453Z
  text: |-
    Done — merged to main (PR #1430).

    What's there:
    - Posture ▸ Continuity (new item in the left menu under Posture, /continuity), for the selected company: "Read from RA-12 · …, approved …, next due …", with cards for Functions · Systems needed · Flagged. With no approved BIA: "No approved business impact analysis for <company>" and Start one.
    - One row per function → system, grouped by function (its owner, tolerable period, RTO, RPO on the heading): needed back within with IT's RTO beneath (red when IT's is longer), the same for data loss / RPO, recovery runbooks, last test (SAP entry, result, date, kind, time against target) and next test due. A system reached through another shows "through AST-1 · CRM".
    - Flags as pills (click one to filter by it): Can't meet the business need · No recovery target · No recovery runbook · Never tested · Not tested in 12 months · Last test failed / partly · Recovered outside target · No test planned. Filters for function, flag and owner; "Only flagged" is on by default when anything is flagged.
    - Export CSV, and PDF (house style, made in the background and opened in a new tab).
    - Dashboard: a Continuity card (systems flagged, systems needed) once the company has an approved BIA.
    - Needs View risk assessments; without View the plan, the test columns and test flags are left out, with a note saying why.

    My calls:
    - A row's "needed back within" is that function's own RTO/RPO (so each function's row is judged against what it needs); a system's card in Inventory shows the strictest across all functions.
    - "Not tested in 12 months" is counted from the last test's completion date.
    - The PDF is the view as the person who asks for it sees it (so no test columns without View the plan).
    - Also fixed in this PR: the new PDF job has a plain name in System status.
assignee: steve
label:
- feature
priority: medium
task_status: review
---
Sprint 95, Business Continuity (ADR 0131, COM-1407). Builds on COM-1409, COM-1410, COM-1411, COM-1412. The page an auditor (ISO 22301, ISO 27001 A.5.29–5.30, SOC 2 A1.3) asks to see.

## What people see

- **Posture ▸ Continuity**, a tab for the selected company.
- **Header:** the BIA it's read from (RA-12, approved 3 Mar 2026, next due 3 Mar 2027 — or **No approved business impact analysis** with **Start one**), and counts: functions · systems needed · flagged.
- **One row per function → system** (grouped by function, tolerable period and RTO/RPO on the group heading):
  - system, **needed back within** vs **IT's RTO**, **data loss tolerated** vs **IT's RPO**;
  - **recovery runbook(s)**;
  - **last tested** (date, kind, result) and **achieved** times against target;
  - **next test due**.
- **Flags** per row, each a pill that filters: Can't meet the business need · No recovery target · No recovery runbook · Never tested · Not tested in 12 months · Last test failed / partly · Recovered outside target · No test planned.
- **Filters:** function, flag, owner; **Only flagged** on by default when there are any.
- **Export:** CSV of the rows, and a **PDF** in the house style with the header, the BIA's functions and targets, and the table — for the auditor's file.
- **Dashboard:** a small **Continuity** card — flagged count, linking here — shown once a company has an approved BIA.

## Who can do what

Anyone who can see the company's risk assessments sees the tab; runbook test columns need `sap.view`, blank without it (with a note saying why).

## Notes (technical)

- `GET /continuity?company=` assembled from COM-1409's target function, the runbook links and SAP results; one place computes the flags so the tab, Dashboard and Polaris agree.
- Screen conventions: SortableTh, tab title, pill rules.

**Chain:** on the chain (API).

**Done when:** on staging, with the test BIA, runbook and exercise from the earlier tasks, every flag above can be made to appear and clear, and the PDF matches the screen.