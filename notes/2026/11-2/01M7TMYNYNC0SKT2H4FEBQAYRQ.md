---
id: 01M7TMYNYNC0SKT2H4FEBQAYRQ
created: 2026-11-19T19:36:20.181749Z
updated: 2026-11-20T14:05:05.078482Z
type: task
title: 'More flowchart shapes: Data (database cylinder) and the other common ones'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1992
sprint: s6y6p7g
comments:
- id: 01M7TXKWF7HV6QT8NGMJN4RG9Z
  author: Steve Vine
  at: 2026-11-19T22:07:43.591185Z
  text: |-
    Done — PR #1992, merged 0f6dc32b.
    Eight new shapes are on the shapes bar down the left, each with a hint: Data (cylinder), Subprocess (box with bars), Documents (stack), Manual input (sloped top), Manual task (trapezium), Preparation (hexagon), Delay (D) and Connector (small circle). Click or drag them in.
    Each is a step: it connects (lines meet its own outline), takes fill, border and text styles, resizes, and its words wrap and grow the shape rather than hide.
    The canvas, reading view, PNG/SVG and PDF/Word all draw the same outline. The plain text names each one ("Data: Customer records"), and Compare says "changed from a Step to Data".
    Polaris can draw and read them. Imports from draw.io, Lucidchart and Mermaid bring their matching symbols in as these shapes.
    On the bar they're grouped: Start/End, Step, Decision · Subprocess, Manual task, Preparation, Delay · Document, Documents, Data, Input/Output, Manual input · Hand-off, Connector · Note, Text, Group.
    Assumptions: Compass has no Visio import (ADR 0160 left it open), so "Visio" is covered where a Visio drawing has been opened in draw.io. draw.io's "process" shape (the one with bars down each side) now comes in as a Subprocess rather than a Step, and Mermaid's [[ ]] likewise.
    To check on staging: add one of each, connect them, resize one with a long label, then look at the reading view and a PDF.
- id: 01M7V3T3R05NW4TBFM3NMDBK1B
  author: Steve Vine
  at: 2026-11-19T23:55:59.103705Z
  text: |-
    Pre-UAT on staging 7ea67f64 — Passed
    - Each new shape on the left bar with a hint; click or drag it in: Passed. As E2E Admin A, all eight are there with hints: Data, Subprocess, Documents, Manual input, Manual task, Preparation, Delay, Connector. I clicked each one in, and dragged Preparation onto the canvas and Delay onto a line.
    - Each is a step: connects, takes styles, resizes, words wrap and never hide: Passed. All eight sit in a connected chain on E2E pre-UAT COM-1992 all shapes standalone. Each Style panel offers fill, border and text. A long label on Data ("Customer records held in the CRM database…") wrapped over five lines and the cylinder grew to fit. One thing: it then overlapped the shape below until I pressed Tidy up (r3-03). A Step changed to Data from the Shape list.
    - Same look on canvas, reading view, PNG/SVG and PDF/Word, light and dark: Passed. Every outline matches across the canvas (light and dark), the saved picture, the PNG and SVG downloads, the PDF and the Word image: cylinder, barred box, stack, sloped top, trapezium, hexagon, D and circle.
    - Plain text names each one: Passed. The .txt export reads e.g. "Data: Customer records…", "Subprocess: Run the triage flow", "Manual task: …", "Preparation: …", "Delay: …", "Documents: …", "Manual input: …", "Connector: A".
    - Imports bring matching symbols in as these shapes: Passed.
      - draw.io: my own file had cylinder3, process, multi-document, manualInput, trapezoid, hexagon, delay and on-page_reference. They came in as Data, Subprocess, Documents, Manual input, Manual task, Preparation, Delay and Connector, and a plain rectangle stayed a Step.
      - Lucidchart: a made-up CSV with Database, Predefined process, Multiple documents, Manual input, Manual operation, Preparation, Delay and Connector mapped the same way, 8 shapes and 5 connections.
      - Visio: not offered, as the builder said.
    - Polaris can draw and read them: Read Passed. Through the Compass-staging assistant tools, read_flowchart names each shape (Preparation, Documents, Data, Manual input, Connector, Delay, Subprocess, Manual task). Drawing: not tried, since it would have Polaris write to staging.
    - Older flowcharts unchanged: Passed. COM-1904's and COM-1907's flowcharts open and draw as before.
    - Compare: Passed. From v1 to v2 it reads "“Log the request” changed from a Step to Data".
    - Tests: Passed. moreShapes.test.tsx is new, the draw.io, Lucidchart and Mermaid import tests have additions, and there's a backend test.
    See COM-1996: a connection fixed to a Manual input's sloped top crashes the whole flowchart page. That crash is logged under 1996, the connection-points task.
    Observations: the plain text shows a connection's label run on after the step name, as in "Delay: Wait until morning next day → 12". A Text shape is listed as "Note: Text". Both look older than this task.
    Screenshots: ~/compass-uat/s6y6p7g/COM-1992/
assignee: steve
label:
- improvement
priority: medium
task_status: done
---
Steve's smoke test of round 2: add more flowchart shapes, including Data (a database cylinder) and a few other common ones.

The shapes today are Start/End, Step, Decision, Document, Input/Output, Hand-off, Note, Group and Text.

New shapes, with the standard flowchart symbol for each:
- **Data**: a cylinder. A database or other stored data the flow reads or writes.
- **Subprocess**: a box with a double line down each side. A step that is a flow of its own, described elsewhere.
- **Documents**: a stack of documents. Several documents or records.
- **Manual input**: a box with a sloping top. Someone types or enters something.
- **Manual task**: a trapezium. A step done by hand, not by a system.
- **Preparation**: a hexagon. Setting up for a later step.
- **Delay**: a D shape. Waiting, such as for an approval or a set time.
- **Connector**: a small circle. Joins one part of the flow to another on the same page.

**Done when**
- Each new shape is on the shapes bar down the left of the canvas (COM-1993) with a hint saying what it's for. You can click it or drag it in.
- Each new shape is a step in the flow. It connects like any other step, takes styles (fill, border, text), resizes, and its words wrap and never hide.
- Each looks the same on the canvas, in the reading view, in the PNG and SVG downloads, and in the PDF and Word files, on light and dark canvases.
- The plain-text version of the flowchart names each one, e.g. "Data: Customer records".
- Imports from draw.io, Visio and Lucidchart turn their matching symbols into these shapes instead of plain steps.
- Polaris (the assistant) can draw and read the new shapes.
- Older flowcharts are unchanged.
- Tests cover drawing, the picture, the plain text and import mapping for each new shape.

Assumption (Claude): the set above is the usual flowchart set. Display, merge/extract and off-page connector are left out, and Hand-off already covers off-page.

On the chain: it adds shape kinds the server checks and the assistant's tools describe.