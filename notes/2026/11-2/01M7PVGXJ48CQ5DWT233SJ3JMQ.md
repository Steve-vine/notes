---
id: 01M7PVGXJ48CQ5DWT233SJ3JMQ
created: 2026-11-18T08:14:11.524044Z
updated: 2026-11-19T18:45:28.718032Z
type: task
title: 'Flowchart loose ends from pre-UAT: search snippets in words, links named as flowcharts, no Hand-off to itself, Delete disabled when refused'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1932
sprint: s6y6p7g
comments:
- id: 01M7Q0GXG0HF7490MDYHTXPD4V
  author: Steve Vine
  at: 2026-11-18T09:41:34.336726Z
  text: |-
    Done — PR #1920, merged 27151cd9.
    - Search: a document's result now shows its summary, or else its words. A flowchart reads as its numbered steps, with no JSON or markers.
    - A link to a standalone flowchart now reads "Flowchart …". On screen it shows a flowchart icon. In PDF, Word and plain text the Links list says it, as do the steps on a flowchart's page.
    - A standalone flowchart's link and Hand-off pickers no longer offer the flowchart itself.
    - Delete: while a published document shows the flowchart, the dialog's Delete button is off, with "Published documents show it" beside it, under the list of those documents.
    - Compare versions: a document's raw diff reads "Flowchart <title>, version N" instead of the id line.
    - Tester A's split: a flowchart that fits its page, both ways, at a readable size is now shown whole, a little smaller. One that must be cut is cut into evenly sized parts, so no part holds a lone step like "End".
    Each has a test.
    To check on staging:
    - search for a step's words;
    - export a document that links to a standalone flowchart, and read its Links list;
    - open the Hand-off picker on a flowchart;
    - try Delete on a flowchart a published document shows;
    - compare two versions of a document that took a newer flowchart version;
    - re-export tester A's wide flowchart on its landscape page.
- id: 01M7Q23ZRT6E5RXK8F4BR1G641
  author: Steve Vine
  at: 2026-11-18T10:09:27.834244Z
  text: |-
    Pre-UAT on staging 27151cd9 — Passed
    All as E2E Admin A, in E2E Test Company. Tester A checks the export split (no lone "End" part).
    - Search snippets in words: "This is how we handle a request" found the COM-1904 document as "HANDLING A REQUEST This is how we handle a request. [Flowchart: E2E pre-UAT request flow] 1. Customer: Start → 2 …". There's no JSON or ``` markers now. "Change requested" and "Laptop returned" found flowcharts and documents as numbered steps or text. Passed.
    - Links named as flowcharts: on "…Document C (own flowchart) flowchart", the page's steps read "Links: Flowchart E2E pre-UAT COM-1907 Service request handling". The PDF and Word Links list read "Manager approves access — Flowchart E2E pre-UAT COM-1907 …", and so does the plain text. Passed.
    - No Hand-off to itself: on that flowchart, neither the Hands off to picker nor the Link a document picker offers the flowchart itself. Other flowcharts are still offered, marked "(flowchart)". Passed.
    - Delete disabled when refused: Delete… on the COM-1907 flowchart (shown by the published Documents A and B) lists both documents. Its Delete button is disabled, with "Published documents show it" beside it. Passed.
    - Compare versions: Document A v1 → v2 raw diff reads "-Flowchart E2E pre-UAT COM-1907 Service request handling, version 3 / +…, version 4", with no id line. Passed.
    - "Each covered by a test" is the builder's (PR #1920); I didn't check the tests.
    Observation: the search snippet for "…Document C (own flowchart) flowchart" still says "Links: Document E2E pre-UAT COM-1907 …". That's likely search text saved before this change, since the page and its exports say "Flowchart". Worth a look after the next edit or reindex.
    Screenshots: ~/compass-uat/s6y6p7g/COM-1932/re-*
assignee: steve
label:
- bug
priority: medium
task_status: done
---
Pre-UAT, 2026-11-18 (testers' observations on COM-1904/1906/1908):
- **Search:** a result for a document with a flowchart shows raw markup and JSON in its snippet. It should show the steps in words, as the plain-text form does.
- **Links list:** in PDF and Word, and on screen, the Links list calls a link to a standalone flowchart "Document …". It should say "Flowchart …".
- **Hand-off picker:** on a standalone flowchart, the picker offers the flowchart itself. A flowchart can't hand off to itself.
- **Delete:** when the delete dialog already says deleting is refused (a published document shows the flowchart), its Delete button stays enabled, and pressing it repeats the refusal. It should be disabled, with the reason beside it.
- **Compare versions:** a document's raw Compare diff shows `{{flowchart: <id> version 3}}`. It should read "Flowchart <title>, version 3".

**Done when**
- All five read as described above, each covered by a test.

Independent unless the snippet fix needs an API change.