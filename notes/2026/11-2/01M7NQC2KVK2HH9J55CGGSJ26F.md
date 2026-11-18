---
id: 01M7NQC2KVK2HH9J55CGGSJ26F
created: 2026-11-17T21:42:24.123067Z
updated: 2026-11-18T08:13:51.299399Z
type: task
title: 'Flowchart swimlanes: lanes for who does each step, named freely or after a business role'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1905
sprint: s6y6p7g
blocked_by:
- 01M7NQBT1PQQHXG3JV194TXDE0
comments:
- id: 01M7PDFGB3X6B2HN9ZZ0DY5NGF
  author: Steve Vine
  at: 2026-11-18T04:08:45.154866Z
  text: |-
    Done — PR #1903, merged 523661ca.
    On the flowchart canvas, the side panel's Lanes list adds lanes, renames them, reorders them (drag, or the arrows), and names one after a business role of the selected company (it shows a role mark). Lanes run across for a left-to-right flow and down for a top-to-bottom one; switching direction turns them. A lane is resized by dragging its edge on the canvas.
    A step belongs to the lane it sits in: dragging it into another lane hands it over, and Tidy up keeps every step in its own lane (lanes grow to fit). Removing a lane that still has steps asks whether to move them to another lane or remove them.
    Lane names stay in sight while the canvas, or a zoomed flowchart in the document, is panned. In the document a role lane opens that company's role; where the company has none it reads as plain text with "No business role called X in <company>".
    PDF and Word show the lanes with their names; the plain text says who does each step ("3. Service Desk: Assign the incident"), and Compare versions says when a step moved lane.
    Assumptions: typing a lane's own name stops it naming a role; a step dragged past the last lane stays in the last.
    To check on staging: build a flowchart with a role lane in E2E Test Company, publish, then view the document with a company that has that role and one that doesn't.
- id: 01M7PVG9T38V2DYVM00CWDZ7CK
  author: Steve Vine
  at: 2026-11-18T08:13:51.299204Z
  text: |-
    Pre-UAT on staging faf46f33 — Failed
    Same document as COM-1904. I worked as E2E Admin A, and read it as E2E Viewer, in E2E Test Company.
    - Lanes in either direction, one named freely and one after a business role: Passed. I added three lanes: "Customer" (typed), "E2E Starter" (picked from the business roles; it shows the role mark) and "Service Desk" (typed). Lanes run down the page for a top-to-bottom flow and across for a left-to-right one, and switching direction turns them. The arrows reorder a lane and its steps move with it. Removing a lane that still has a step asks "Move them to another lane / Remove them with the lane" (05-remove-lane-asks.png). Note: the role picker accepts only E2E Test Company's roles. A typed role name it doesn't know is dropped.
    - With a company that has the role, the role lane opens the role; with one that doesn't, plain text with the note: Failed for a Viewer (defect below). As Admin A, the "E2E Starter" lane in the Read tab links to /access/roles/… and opens the role (08-role-lane-opens-role.png). I can only use E2E Test Company, so for the "no such role" case I made a lane from a role I created, "E2E pre-UAT COM-1905 role", published, then deleted the role. That lane now reads as plain text, with the hover note "No business role called E2E pre-UAT COM-1905 role in E2E Test Company" (10-role-lane-no-role.png).
      DEFECT: as E2E Viewer, the "E2E Starter" lane is plain text, and hovering it says "No business role called E2E Starter in E2E Test Company", which isn't true. The page's request for the company's business roles fails with 403, and an error shows in the console. A step's role link in the same flowchart shows the same false note. Steps: sign in as E2E Viewer and open /content/e2e-pre-uat-com-1904-flowchart-document. Screenshot 11-viewer-role-lane.png.
    - Moving a step between lanes changes who does it, and Tidy up respects lanes: Passed. A step dragged into another lane shows "In the lane E2E Starter". Tidy up kept every step in its lane, both ways (03-, 04-tidy-in-lanes-*.png). The plain text says "6. E2E Starter: Do the work".
    - PDF, Word and plain text show the lanes: Passed. The PDF and Word file show the lanes with their names, repeated on each part when the flowchart is split (v2.pdf, v2.docx). The plain text puts the lane in front of each step. Compare versions lists "moved lane: Customer → …".
    - Observation: a lane can't be resized. Dragging its edge does nothing, because the edge never receives the pointer. This is in the task body and the builder's note, but not in the Done-when.
    Screenshots: ~/compass-uat/s6y6p7g/COM-1905/
assignee: steve
label:
- feature
priority: medium
task_status: review
---
Builds on COM-1904. Steve, 2026-11-17: a lane's name is typed freely, and a Compass business role is optional.

**What the author sees**
- **Add lanes** on the canvas. Lanes run across (one per row) or down (one per column), and the whole flowchart uses one direction. Lanes can be added, renamed, reordered by dragging, resized and removed.
- **A lane's name** can be typed (e.g. "Customer", "Third-party supplier"), or picked from the business roles, where it shows a role marker. Business roles are kept per company and a flowchart is shared, so the lane keeps the role's **name**:
  - viewed with a company selected, a role lane links to that company's role of that name;
  - where the company has no role of that name, the lane reads as plain text, with a hover note "No business role called X in <company>".
- **A step belongs to the lane it sits in.** Dragging a step into another lane hands it over, and Tidy up keeps steps inside their lanes.
- Removing a lane that still has steps asks what to do: move its steps to another lane, or remove them.
- A flowchart can have no lanes, as before.

**What a reader sees**
- Lane names stay visible while the flowchart is panned. PDF and Word show the lanes with their names.
- The plain-text form, search and Polaris say who does each step: "3. Service Desk: Assign the incident".

**Done when**
- An author can build a flowchart with lanes in either direction, name one freely and name one after a business role.
- With a company that has that role selected, the role lane opens the role. With one that doesn't, it reads as plain text with the note.
- Moving a step between lanes changes who does it, and Tidy up respects lanes.
- PDF, Word and plain text show the lanes.

On the chain: the flowchart's stored form gains lanes.