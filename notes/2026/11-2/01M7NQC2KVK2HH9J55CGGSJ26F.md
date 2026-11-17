---
id: 01M7NQC2KVK2HH9J55CGGSJ26F
created: 2026-11-17T21:42:24.123067Z
updated: 2026-11-17T21:44:39.010221Z
type: task
title: 'Flowchart swimlanes: lanes for who does each step, named freely or after a business role'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1905
sprint: s6y6p7g
assignee: steve
label:
- feature
priority: medium
task_status: todo
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