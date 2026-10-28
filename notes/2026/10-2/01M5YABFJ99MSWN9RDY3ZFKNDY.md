---
id: 01M5YABFJ99MSWN9RDY3ZFKNDY
created: 2026-10-27T09:16:39.369257Z
updated: 2026-10-28T00:42:09.297963Z
type: task
title: Polaris reads the pen-test report and fills in the proposed findings — title, severity, CVSS, affected hosts and systems, description and recommendation, each pointing at its page — for a person to check and confirm
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1379
sprint: ssp4evc
blocked_by:
- 01M5YAB5KEFNGXS492V5JBMBH2
assignee: steve
label:
- feature
priority: high
task_status: active
---
Sprint 92, Vulnerabilities - Scanner sources (ADR in COM-1374). Builds on the pen-test import task. The AI-first pattern of DDQ reading (ADR 0125): Polaris does the reading, a person decides.

## What people see

- **On the import page, "Read with Polaris"**, shown when Polaris is on:
  - Polaris reads the report and fills the proposed-findings list;
  - each finding gets a **page reference** and a confidence of "read clearly" or "check this", e.g. when severity was inferred, not stated;
  - progress shows as it works, page by page;
  - a long report can be stopped and resumed.
- **Systems:** Polaris suggests a technology asset for each host or URL it finds, from names, matching rules and discovered resources. Suggestions are marked as suggestions until a person accepts them. Hosts it can't place are left for the person.
- **Nothing enters the register until a person confirms.** Confirming all at once is offered only after each "check this" item has been opened.
- **Without Polaris** (off, or no key), the button isn't offered, and the import works by hand as in the previous task.
- **A scanned report** with no text says "this report has no readable text — enter its findings by hand". Compass has no OCR.

## Rules

- What Polaris reads from the report is untrusted text. Instructions inside a report are data, never followed.
- The report goes to the organisation's own AI provider, as DDQs do. The window says so the first time.

## Notes (technical)

- New Polaris tools:
  - `vulnerabilities_read_report`: returns the PDF's text page by page with pypdf text extraction, and tables as best it can;
  - `vulnerabilities_propose_findings`: writes the proposed rows, never vulnerabilities.
- The turn runs in-API like other Polaris work (ADR 0127), with spend limits applying.
- Test with two fixture reports written for the purpose (fake company, fake hosts): one tidy, one messy. Assert the proposed rows, with the model faked at the adapter.

**Chain:** on the chain (API; no migration if the import stores proposals already).

**Done when:**
- a real pen-test report on staging is read into proposed findings with page references;
- a person corrects and confirms them;
- the vulnerabilities match what was confirmed.