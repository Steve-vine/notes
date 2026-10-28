---
id: 01M5YABFJ99MSWN9RDY3ZFKNDY
created: 2026-10-27T09:16:39.369257Z
updated: 2026-10-28T18:16:56.115052Z
type: task
title: Polaris reads the pen-test report and fills in the proposed findings — title, severity, CVSS, affected hosts and systems, description and recommendation, each pointing at its page — for a person to check and confirm
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1379
sprint: ssp4evc
blocked_by:
- 01M5YAB5KEFNGXS492V5JBMBH2
comments:
- id: 01M6036F5YYK5F14A295B4WCR5
  author: Steve Vine
  at: 2026-10-28T01:50:03.966245Z
  text: |-
    Built — PR #1395, merged to main (no migration).

    What's there:
    - On a pen-test import being reviewed, "Read with Polaris". It shows only while Polaris is on and can answer, to someone who works vulnerabilities.
      - It opens the Polaris window with the request ready to send. The page says the report's text goes to your organisation's own AI provider, so sending is your click.
    - Polaris reads the report ten pages at a time and fills the findings list. Each finding gets its page and a mark: "Read clearly" or "Check this".
    - The page shows "Polaris has read N of M pages" and refreshes while it reads. A long report can be stopped and carried on ("Carry on reading with Polaris").
    - Systems:
      - Compass suggests a technology asset for each host or URL Polaris finds, from asset names and aliases, discovery and matching rules;
      - it shows as "Suggested: … — edit to accept";
      - hosts it can't place are left for you.
    - Nothing enters the register until you confirm, and Confirm waits until every "Check this" finding has been opened (clicked or edited).
    - A scanned report says "This report has no readable text — enter its findings by hand."
    - Without Polaris, the button isn't there and the import works by hand.

    Rules: the report's text is handed to Polaris as the report's words, never as instructions. One test report deliberately carries an "ignore all previous instructions" line. Polaris's own instructions now say it never confirms; a person does.

    My call: the button prepares the request and you press send, rather than sending on the click. It keeps "this goes to your AI provider" a deliberate act.

    Tested with two reports written for the purpose, a tidy one and a long messy one, using made-up hosts. Not yet tried with a real report or a real AI key. To try on staging: open an import, Read with Polaris, send, then check and confirm what it proposes.
assignee: steve
label:
- feature
priority: high
task_status: done
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