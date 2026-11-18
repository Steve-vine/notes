---
id: 01M7PVKJZ7SEVQVTN7ADFA7NDQ
created: 2026-11-18T08:15:38.983879Z
updated: 2026-11-18T08:15:43.115965Z
type: task
title: A reader who can't open business roles sees a role lane or link as the role's name, never "no business role called …"
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1934
sprint: s6y6p7g
assignee: steve
label:
- bug
priority: high
task_status: todo
---
Pre-UAT, 2026-11-18 (tester A, COM-1905/1906):
- Signed in as E2E Viewer, the document "E2E pre-UAT COM-1904 flowchart document" shows the "E2E Starter" lane and a step's role link as plain text, with the hover note "No business role called E2E Starter in E2E Test Company".
- The role does exist. The Viewer can't read business roles, so the page's request for them fails (403) and logs a console error.
Screenshot: ~/compass-uat/s6y6p7g/COM-1905/11-viewer-role-lane.png

**Decided (no question for Steve):**
- Whether a role of that name exists in the company is answered for anyone who can read the document, through the same "what does each link point to" check the step links use (POST /api/v1/flowcharts/links/resolve). Only the role's name is answered, never its groups or members.
- A reader who can open the role gets a link. A reader who can't sees the name as plain text with no note.
- "No business role called X in <company>" appears only when there is genuinely none.

**Done when**
- As Viewer, a role lane and a role link show the role's name, with no "doesn't exist" note, no failed request and no console error.
- As someone who can open business roles, they link to the role, as before.
- A lane naming a role the company doesn't have still shows the note, for both.
- Tests cover all three cases.

Independent unless the resolve check changes its response (then on the chain).