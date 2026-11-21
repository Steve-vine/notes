---
id: 01M7YNGQGCQFBX9QX9R6HY691E
created: 2026-11-21T09:03:09.324389Z
updated: 2026-11-21T09:03:12.910728Z
type: task
title: 'A finding''s closing evidence can be added inside Compass: Add evidence shows once the corrective action plan is accepted'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2053
sprint: s9hexqn
assignee: steve
label:
- bug
priority: high
task_status: active
---
Found in Claude's pre-UAT pass of the Evidence Improvements sprint (staging 7e04d3f5e, 2026-11-21), on COM-2044.

**Steps:** as E2E Admin A on AUD-1, add finding AUD-1-F2 and give it a corrective action owner. Write and submit the plan, then accept it. Open the finding as E2E Admin A or E2E Admin B.
**Expected:** Closing evidence has Add evidence, which opens "Add evidence to AUD-1-F2" with Link existing filtered to the finding's controls, and Submit for closure.
**Seen:** "Closing evidence: None yet." and no button. The User Portal's corrective-action owner can add closing evidence, and linking through the server works.
**Cause (technical):** the screen shows the button only when the finding allows plan writing *and* the plan is accepted. The server allows plan writing only while the finding is Open, so the two are never true together. The rule dates from 29 Oct, so it may predate the sprint; either way, it blocks the window here.
**Screenshot:** ~/compass-uat/s9hexqn/COM-2044/finding-closing-evidence-no-button.png

**Done when**
- Once a finding's plan is accepted, people who may add its closing evidence (as the server allows today) see Add evidence on Closing evidence, and it opens the window filtered to the finding's controls.
- A test covers the button's rule against the finding's real states.

On the chain: frontend (and the server's rule if that's where it's wrong).