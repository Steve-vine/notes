---
id: 01M7NQF6NX90J3297G7TACBTEW
created: 2026-11-17T21:44:06.589969Z
updated: 2026-11-17T21:44:06.589969Z
type: task
title: Import a flowchart from Lucidchart (its CSV export)
priority: medium
assignee: steve
task_status: todo
label: feature
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1912
---
Builds on COM-1905 (needs lanes). Steve, 2026-11-17: import from Lucidchart is in this sprint. Lucidchart's own file format isn't open, so the import reads its **File ▸ Export ▸ CSV of shape data** file.

**Steve's sample: `~/docs/incident-management.csv`** (the "Incident Management" Lucidchart document). Use it to develop and check against, but **don't commit it**. The test fixture is a made-up file with the same structure. What it shows:
- **One file, several pages:** Documentation, IM Triage, Minor Technology, Major Technology, Page 5. Each page is one flowchart.
- **No positions.** The file says what's connected to what, not where anything sat, so Compass lays the flow out with Tidy up (lanes kept).
- **Lanes** are a "Swim lane" shape whose lane names are its text fields (e.g. Service Desk / Infrastructure / Platform). Each step names the lane it's in. One page (Major Technology) has **two lane blocks** with mostly the same names (Incident Owner, Incident Manager, Security Manager, …); they come in as one set of lanes, merged by name, in the order first seen.
- **Shapes:** Process and Block → Step, Decision → Decision, TerminatorBlock → Start/End, Sticky note and Curly brace note → Note. A curly-brace note ("Repeat every 12 hours") spans a group of steps, but the file doesn't say which ones, so it comes in as a free Note and is listed.
- **Connections** have labels (Yes / No). Some are drawn with the arrow at the start, and those come in pointing the way the arrow points.
- **Things that don't come across:** a page holding only a table (IM Triage: the Incident Priority Matrix) has "nothing to import on this page", and tables elsewhere are listed. Steps with no label come in as blank Steps and are listed.

**What people see**
- **Import ▸ Lucidchart (CSV)** on an empty canvas, and **Create ▸ Flowchart ▸ Import from Lucidchart**, with a one-line hint on how to export from Lucidchart.
- The pages are listed with a count of shapes on each, and pages with nothing importable are greyed out. The person picks one.
- Before saving, the same kind of summary as the draw.io import (COM-1911): what came in, what didn't, and Cancel.
- The result is a draft. Nothing is published by importing.

**Done when**
- The sample's Minor Technology page imports as Start → steps → two decisions with Yes/No, in its three lanes.
- Major Technology imports with its two lane blocks merged into one set of lanes, every step in its lane, and the blank steps and brace notes listed.
- A reversed-arrow connection points the right way. IM Triage reports nothing to import.
- A CSV that isn't a Lucidchart shape export is refused with a plain message.

Independent: read in the browser, so no API change. Branch from main after COM-1905 lands. Shares the summary screen with COM-1911, so whichever lands second reuses it.