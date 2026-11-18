---
id: 01M7NQF6NX90J3297G7TACBTEW
created: 2026-11-17T21:44:06.589969Z
updated: 2026-11-18T08:12:56.25211Z
type: task
title: Import a flowchart from Lucidchart (its CSV export)
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1912
sprint: s6y6p7g
blocked_by:
- 01M7NQC2KVK2HH9J55CGGSJ26F
comments:
- id: 01M7PG3928B3SYF3K061QCW0SJ
  author: Steve Vine
  at: 2026-11-18T04:54:30.215947Z
  text: |-
    Done — PR #1908, merged db14a0e.
    On an empty flowchart canvas, Import ▸ Lucidchart (CSV)… sits beside draw.io, with a hint: in Lucidchart, choose File ▸ Export ▸ CSV of Shape Data.
    The file's pages are listed with a count of shapes; a page with nothing importable (only a table) is greyed out. Pick one and the flowchart is laid out by Tidy up (the file has no positions), each step kept in its lane.
    Lane blocks on one page merge into one set of lanes by name, in the order first seen; lanes with no steps still come in. A step outside every lane goes into "Not in a lane". A connection drawn with its arrow at the start points the way the arrow points.
    The summary lists, for a look: brace notes (the file doesn't say which steps they span), steps with no label of their own, steps connected to nothing; and, left out: tables, pictures, loose connections. A CSV that isn't a Lucidchart shape export is refused plainly.
    Checked locally against your incident-management.csv (not committed): Minor Technology comes in exactly as the Done-when says (first five in Service Desk, Escalate? and the stray Process in Not in a lane, Process listed); Major Technology's two lane blocks merge into 7 lanes with the blank steps and brace notes listed; IM Triage has nothing to import.
    Assumption: Lucidchart lanes come in running across (flow left to right) — the file doesn't say which way they ran.
    To check on staging: import incident-management.csv. Create ▸ Flowchart ▸ Import from Lucidchart belongs on COM-1907's standalone flowchart page, not on main yet — lane D adds it there.
- id: 01M7PVEM1WVW9JPHAF77W4N9DY
  author: Steve Vine
  at: 2026-11-18T08:12:56.251905Z
  text: |-
    Pre-UAT on staging faf46f33 — Passed
    As E2E Admin A in E2E Test Company. Steve's incident-management.csv was only read in the browser and cancelled; nothing from it was kept. The repo's made-up fixture (from lucidchart.test.ts) was imported and kept.
    - Steve's file, Minor Technology: the pages list showed Documentation 19, IM Triage "Nothing to import on this page" (greyed out, can't be clicked), Minor Technology 7, Major Technology 44, Page 5 12. Minor Technology: "7 shapes, 6 connections, 3 lanes". Minor Technology Incident → Assign Incident to Agent → Investigate Incident → Resolved? (Yes → Close Incident; No → Escalate?), and Escalate? No → Investigate Incident. The first five are in Service Desk; Infrastructure and Platform came in empty; Escalate? and the stray Process are in "Not in a lane". Listed: "Steps with no label of their own: Process", "Not connected to anything: Process", and "Outside every lane: Process, Escalate?". Passed.
    - Major Technology: "44 shapes, 27 connections, 7 lanes". It has one set of lanes (Incident Owner, Incident Manager, Security Manager, Resolver Group, Communications Manager, Ops Board Lead, Operations Lead), with each step in its lane. Listed: "an unlabelled Step ×4", and the brace notes ("Repeating cycle", "One Hour into Incident. Repeat every 12 Hours", "Every Hour", "As new information becomes availailable") as free Notes. Then Cancel, and Cancel on New content: no flowchart was created. Passed.
    - Reversed arrow and IM Triage: with the fixture, the line drawn backwards (14→13, arrow at the start) came in as "Look into it, then reply → Sorted?". Its table-only page "Matrix" read "Nothing to import on this page", the same as Steve's IM Triage. Passed.
    - A CSV that isn't a Lucidchart export ("Name,Email" rows) got "This isn't a Lucidchart shape export. In Lucidchart, choose File ▸ Export ▸ CSV of Shape Data, and import that file." Passed.
    - Fixture kept as "E2E pre-UAT COM-1912 Lucidchart fixture import" (a draft): Front desk / Engineering / Suppliers / Not in a lane, and the steps match the test exactly. Passed.
    Observation (worth a look): the laid-out picture runs some connections through other steps. On Minor Technology, the line from Escalate? (No) back to Investigate Incident goes up through Close Incident, so it reads as if Close Incident leads back to Investigate. Major Technology has several lines through boxes. See 02b-minor-technology-zoom.png and 03b-major-technology-zoom.png.
    Screenshots: ~/compass-uat/s6y6p7g/COM-1912/
assignee: steve
label:
- feature
priority: medium
task_status: review
---
Builds on COM-1905 (needs lanes). Steve, 2026-11-17: import from Lucidchart is in this sprint. Lucidchart's own file format isn't open, so the import reads its **File ▸ Export ▸ CSV of shape data** file.

**Steve's sample: `~/docs/incident-management.csv`** (the "Incident Management" Lucidchart document). Use it to develop and check against, but **don't commit it**. The test fixture is a made-up file with the same structure. What it shows:
- **One file, several pages:** Documentation, IM Triage, Minor Technology, Major Technology, Page 5. Each page is one flowchart.
- **No positions.** The file says what's connected to what, not where anything sat, so Compass lays the flow out with Tidy up (lanes kept).
- **Lanes** are a "Swim lane" shape whose lane names are its text fields (e.g. Service Desk / Infrastructure / Platform). Each step names the lane it's in. One page (Major Technology) has **two lane blocks** with mostly the same names (Incident Owner, Incident Manager, Security Manager, …); they come in as one set of lanes, merged by name, in the order first seen. Lanes with no steps (Infrastructure and Platform on Minor Technology) still come in.
- **A step outside every lane** on a page that has lanes (e.g. "Escalate?" on Minor Technology) goes into an added lane called "Not in a lane", is listed, and can be dragged to its lane. Compass never guesses a lane.
- **Shapes:** Process and Block → Step, Decision → Decision, TerminatorBlock → Start/End, Sticky note and Curly brace note → Note. A curly-brace note ("Repeat every 12 hours") spans a group of steps, but the file doesn't say which ones, so it comes in as a free Note and is listed.
- **Connections** have labels (Yes / No). Some are drawn with the arrow at the start, and those come in pointing the way the arrow points.
- **Things that don't come across, or come across flagged:** a page holding only a table (IM Triage: the Incident Priority Matrix) has "nothing to import on this page", and tables elsewhere are listed. Steps with no label, or still called just "Process", come in as Steps and are listed. A step connected to nothing (the stray "Process" on Minor Technology) is listed as "not connected to anything".

**What people see**
- **Import ▸ Lucidchart (CSV)** on an empty canvas, and **Create ▸ Flowchart ▸ Import from Lucidchart**, with a one-line hint on how to export from Lucidchart.
- The pages are listed with a count of shapes on each, and pages with nothing importable are greyed out. The person picks one.
- Before saving, the same kind of summary as the draw.io import (COM-1911): what came in, what didn't or was flagged, and Cancel.
- The result is a draft. Nothing is published by importing.

**Done when**
- The sample's Minor Technology page imports as: Minor Technology Incident → Assign Incident to Agent → Investigate Incident → Resolved? (Yes → Close Incident; No → Escalate?), and Escalate? No → back to Investigate Incident. Its first five shapes are in Service Desk, Escalate? is in "Not in a lane", and the stray "Process" is listed.
- Major Technology imports with its two lane blocks merged into one set of lanes, every step in its lane, and the blank steps and brace notes listed.
- A reversed-arrow connection points the right way. IM Triage reports nothing to import.
- A CSV that isn't a Lucidchart shape export is refused with a plain message.

Independent: read in the browser, so no API change. Branch from main after COM-1905 lands. Shares the summary screen with COM-1911, so whichever lands second reuses it.