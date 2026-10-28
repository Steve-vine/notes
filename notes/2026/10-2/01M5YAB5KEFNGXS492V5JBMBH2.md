---
id: 01M5YAB5KEFNGXS492V5JBMBH2
created: 2026-10-27T09:16:29.166532Z
updated: 2026-10-28T00:27:50.795857Z
type: task
title: Bring in a pen-test report — upload the PDF against its SAP testing entry, the report is kept as evidence, and its findings are reviewed in one screen before they enter the register
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1378
sprint: ssp4evc
blocked_by:
- 01M5YA9GHNHTXNSZ3JMFTWECB9
- 01M5YA6ZNQ5Q5CGV8DXB00MQ41
assignee: steve
label:
- feature
priority: high
task_status: active
---
Sprint 92, Vulnerabilities - Scanner sources (ADR in COM-1374). Builds on sprint 91. This is the screen Polaris fills in the next task. It is useful on its own, typed by hand.

## What people see

- **Vulnerabilities ▸ Register ▸ Import ▸ Pen-test report** opens a window asking for:
  - the PDF;
  - the tester (a vendor from the register);
  - the test dates;
  - the scope (free text);
  - the **SAP testing entry** it belongs to, offered from this company's open and recent testing entries, or none.
- **On upload:**
  - the report is stored as **evidence**, in Audit ▸ Evidence, classified **Confidential** by default;
  - it is linked to the SAP entry, so the entry's evidence shows it;
  - a **pen-test import** is opened: a page titled with the tester and date.
- **The import page:**
  - the report on the left, page by page;
  - on the right, a list of **proposed findings**, each with:
    - title;
    - severity;
    - CVSS;
    - CVEs;
    - kind;
    - affected systems (chosen from technology assets), plus where exactly (hosts, URLs);
    - description;
    - recommendation;
    - the page it's on.
  - Each can be added, edited or dropped.
  - **Confirm** turns every confirmed finding into vulnerabilities (one per system), with the source "Pen test: <tester>, <date>" and first seen as the report date.
  - Until confirmed, nothing is in the register. The import can be left and resumed, and is listed under Import ▸ Pen-test reports with its status.
- **The SAP entry** can be completed with this report as its evidence, and shows "N findings recorded" linking to them. That replaces raising each finding there as a gap or risk by hand.

## Who can do what

- Uploading and confirming need work vulnerabilities.
- Classification follows the evidence rules.

## Notes (technical)

- The import is its own small record (company, evidence item, SAP entry, tester, dates, status, proposed findings as rows). Audited.
- Extend `sap_entry_findings` to allow a vulnerability as a finding kind, or link through the import. Settle which in the PR.
- PDF pages render with the existing PDF viewer if there is one, otherwise with pdf.js. Size limit as for evidence.

**Chain:** on the chain (migration + API).

**Done when:**
- a report uploaded against an SAP entry becomes evidence on it;
- findings typed into the import become vulnerabilities on confirm;
- an unconfirmed import adds nothing to the register.