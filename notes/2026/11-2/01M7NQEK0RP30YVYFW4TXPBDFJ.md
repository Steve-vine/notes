---
id: 01M7NQEK0RP30YVYFW4TXPBDFJ
created: 2026-11-17T21:43:46.456599Z
updated: 2026-11-19T18:45:28.594088Z
type: task
title: Import a flowchart from draw.io (diagrams.net)
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1911
sprint: s6y6p7g
blocked_by:
- 01M7NQC2KVK2HH9J55CGGSJ26F
comments:
- id: 01M7PFMC9TYH1DAV347F56RVFW
  author: Steve Vine
  at: 2026-11-18T04:46:22.010196Z
  text: |-
    Done — PR #1905, merged 6196996.
    On an empty flowchart canvas there's now Import ▸ draw.io file…. Choose a .drawio file (compressed or not; a .drawio.svg works too) and it's read in the browser.
    A file with several pages lists them with a count of shapes; a page with nothing to import is greyed out. Each page is one flowchart.
    Shapes come in as the nearest Compass shape, labels lose their formatting, connections keep their labels and the way their arrow points, and pools and lanes become lanes with each shape in its lane. Positions are kept; Tidy up lays it out afresh.
    Before anything is kept, a summary shows the flowchart, "N shapes, N connections, N lanes imported", what came in but needs a look (e.g. shapes Compass doesn't have, brought in as Steps; steps outside every lane, put in "Not in a lane"), and what didn't come across (pictures, tables, freehand shapes, loose connections, colours and styling). Cancel leaves the flowchart as it was; Undo takes an import back.
    A file that isn't draw.io gets a plain "This isn't a draw.io file" message.
    Assumptions: Import is offered only on an empty canvas (just the Start), since it replaces what's there. A shape drawn over a lane without being put in it counts as in that lane. Lanes from two pools stay separate, not merged by name.
    To check on staging: import a real .drawio with lanes from Confluence. Create ▸ Flowchart ▸ Import from draw.io belongs on COM-1907's standalone flowchart page, which isn't on main yet — lane D adds it there.
- id: 01M7PVEA1H1QZRS82783X6JPST
  author: Steve Vine
  at: 2026-11-18T08:12:46.001143Z
  text: |-
    Pre-UAT on staging faf46f33 — Passed
    As E2E Admin A in E2E Test Company. The test files are my own made-up .drawio files (two lanes in a pool, a terminator, a decision, a parallelogram, labelled connections, a picture, a loose connection, bold text and a fill colour), in ~/compass-uat/s6y6p7g/_scripts/B/.
    - Lanes, decisions and labelled connections all come across: New content ▸ Flowchart ▸ Import from… ▸ draw.io file… said "5 shapes, 5 connections, 2 lanes imported". On "E2E pre-UAT COM-1911 draw.io import" the steps read: Requester: Change needed → Raise the change (Submit) → Approver: Approved? No → 2; Yes → Make the change (Record it) → Requester: Change record. Every step is in its lane, the ellipse is a Start/End, the rhombus a Decision, the parallelogram an Input/Output, and the bold formatting is gone. Passed.
    - Compressed and uncompressed both import, and a multi-page file asks: the compressed two-page file listed "Change flow — 5 shapes" and "Second page — 2 shapes". The uncompressed single-page file went straight to the summary. The compressed file also imported into a document's own flowchart (canvas with just Start), and Import is no longer offered once the canvas has shapes. Passed.
    - The summary lists what didn't come across, and Cancel changes nothing: it listed "Pictures: an unnamed picture", "Connections with a loose end: 'dangling'", and "Colours, line styles and text formatting". Cancel in New content left the dialog at "Or start with an empty canvas". Cancel on a document's canvas left just "Start". Passed.
    - Not draw.io: a plain-text .drawio got "This isn't a draw.io file. Choose a .drawio file saved from draw.io or diagrams.net." Passed.
    Observation: in the summary preview, the decision's label shows cut short ("Approve…").
    Screenshots: ~/compass-uat/s6y6p7g/COM-1911/
assignee: steve
label:
- feature
priority: medium
task_status: done
---
Builds on COM-1905 (needs lanes). Steve, 2026-11-17: import from draw.io is in this sprint. The .drawio file is also what Confluence's draw.io add-on saves.

**What people see**
- **Import ▸ draw.io file** on an empty canvas (a document's own flowchart, or a new standalone flowchart once COM-1907 lands), and **Create ▸ Flowchart ▸ Import from draw.io**.
- A file with several pages asks which page to import. Each page is one flowchart; importing another page is another import.
- **What comes across:** shapes as their nearest Compass shape (process → Step, rhombus → Decision, terminator/ellipse → Start/End, document → Document, parallelogram → Input/Output, off-page reference → Hand-off, note/comment → Note), labels with formatting removed, connections with their labels and direction, and pools and lanes as lanes, with each shape in its lane. Positions are kept, and Tidy up is offered.
- **Before anything is saved**, a summary: "38 shapes, 27 connections, 6 lanes imported". **What didn't come across** is listed by name: pictures, tables, freehand shapes, connections with a loose end, and styling. Unknown shapes come in as Steps and are listed. The person can cancel.
- An imported flowchart is a draft like any other. Nothing is published by importing.

**Done when**
- A draw.io file with lanes, decisions and labelled connections imports with every shape, connection and lane, each step in its lane.
- Compressed and uncompressed .drawio files both import, and a multi-page file asks which page.
- The summary lists what didn't come across, and Cancel leaves the flowchart as it was.
- A file that isn't draw.io is refused with a plain message.

Independent: read in the browser, so no API change. Branch from main after COM-1905 lands. Test files are made up, not real company documents.