---
id: 01M7X6RVVV9HY82XMTZ1PH1E0Q
created: 2026-11-20T19:26:12.859162Z
updated: 2026-11-20T22:45:55.066516Z
type: task
title: Printing a content page from the browser prints the document, not a blank page
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2037
sprint: s9hexqn
comments:
- id: 01M7XJ6D6VNCAYZ2NHG9MNTYNG
  author: Steve Vine
  at: 2026-11-20T22:45:50.939326Z
  text: |-
    Fixed and merged to main (PR #2033).

    Cause: the Library reader's print rule ("hide everything except the reader") loaded with the app on every page, so printing any other page hid the whole app.

    What changes:
    - Printing a content page from the browser prints the whole document again, on the Read and Edit tabs, over as many pages as it needs. The top bar and the Polaris window are left off the paper.
    - The Library reader still prints only the document.
    - Every other screen prints as it did before the Library reader. The blank page is gone everywhere.

    I checked it by printing to PDF in headless Chromium against staging data, with this build:
    - Content page, Read tab: was 1 blank page, now 6 pages, the whole document.
    - Content page, Edit tab: was 1 blank page, now 4 pages, the form and the whole editor.
    - Library reader: 6 pages, document only, unchanged.
    - Risks register: was blank, now prints as before.

    The PDFs and screenshots are in ~/compass-uat/s9hexqn/COM-2037/. Tests cover the reader's print scoping and the content page's print mode, plus a check over all stylesheets that no print rule reaches the whole app without being tied to the page it's for.

    Calls for you to overturn: a content page prints the whole document, not one screenful (other screens still print one screen, as before), and the top bar is left off on paper.
assignee: steve
label:
- bug
priority: high
task_status: review
---
Found by Claude's pre-UAT tester during sprint 118 round 4 checks (staging 514c4649). It isn't caused by the flowchart work. It looks like it comes from the Library reader (sprint 119).

**Steps:** open any content page (Read tab) and print it from the browser (Ctrl+P).

**Expected:** the document prints. **Seen:** an empty page.

The Library reader prints correctly, and Compass's own Print preview / PDF export is unaffected.

**Technical:** the Library reader's print rule ("hide everything except `.library-reader`") is in the app's main stylesheet. So on every other page, the app root is hidden when printing.

**Evidence:**
- ~/compass-uat/s6y6p7g/COM-2034/r4re-browser-print-content-page.pdf (blank)
- ~/compass-uat/s6y6p7g/COM-2034/r4re-browser-print-library-reader.pdf (correct)

**Done when**
- Printing a content page from the browser prints its contents, on both the Read and Edit tabs.
- The Library reader still prints only the document, as now.
- Other screens print as they did before the Library reader.
- A test covers print styles on a content page and in the Library reader.