---
id: 01M7NQEK0RP30YVYFW4TXPBDFJ
created: 2026-11-17T21:43:46.456599Z
updated: 2026-11-17T21:43:46.456599Z
type: task
title: Import a flowchart from draw.io (diagrams.net)
label: feature
assignee: steve
task_status: todo
priority: medium
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1911
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