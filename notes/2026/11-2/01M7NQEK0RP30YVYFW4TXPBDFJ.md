---
id: 01M7NQEK0RP30YVYFW4TXPBDFJ
created: 2026-11-17T21:43:46.456599Z
updated: 2026-11-18T04:46:25.368714Z
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
assignee: steve
label:
- feature
priority: medium
task_status: review
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