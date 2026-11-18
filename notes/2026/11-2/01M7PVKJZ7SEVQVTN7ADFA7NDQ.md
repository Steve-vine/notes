---
id: 01M7PVKJZ7SEVQVTN7ADFA7NDQ
created: 2026-11-18T08:15:38.983879Z
updated: 2026-11-18T08:47:36.856554Z
type: task
title: A reader who can't open business roles sees a role lane or link as the role's name, never "no business role called …"
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1934
sprint: s6y6p7g
comments:
- id: 01M7PXE1GKS6KH3HWJW4HC5WGZ
  author: Steve Vine
  at: 2026-11-18T08:47:34.419543Z
  text: |-
    Done — PR #1917, merged 9a958a37.
    - Anyone who can read a document now gets a straight answer on whether the selected company has a business role of a lane's or a step link's name. They get only the role's name, never its groups or members.
    - Someone who can open business roles still gets the role's name as a link to the role.
    - A reader who can't (E2E Viewer) sees the name as plain text with no note. The page no longer asks for the business roles list, so there's no failed request and no console error.
    - "No business role called X in <company>" now appears only where the company really has no role of that name. That holds for both kinds of reader, and also for a role that has been deleted or belongs to another company.
    Assumptions: a retired role still counts as the company's role, as before. The lane and step-link editors still suggest role names from the roles list, because they're for authors.
    To check on staging: as E2E Viewer, open "E2E pre-UAT COM-1904 flowchart document" in E2E Test Company. The "E2E Starter" lane and the role link should read "E2E Starter" with no note. As an admin, the same name should open the role.
assignee: steve
label:
- bug
priority: high
task_status: review
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