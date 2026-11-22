---
id: 01M7YNGQGCQFBX9QX9R6HY691E
created: 2026-11-21T09:03:09.324389Z
updated: 2026-11-22T08:13:22.271509Z
type: task
title: 'A finding''s closing evidence can be added inside Compass: Add evidence shows once the corrective action plan is accepted'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2053
sprint: s9hexqn
comments:
- id: 01M7YRT2ZBBQM0KSGWY66R5H1G
  author: Steve Vine
  at: 2026-11-21T10:00:41.707584Z
  text: |-
    Done and merged to main (PR #2046). No migration.

    Cause: the screen was wrong. It showed the closing-evidence buttons only when the plan was still editable *and* already accepted, which can never both be true. That's been so since COM-1429 (29 Oct), before this sprint. An old test fixture hid it by giving an accepted plan a flag the server never sends.

    What changes:
    - Once the auditor accepts a finding's corrective action plan, the finding's Closing evidence shows Add evidence and Submit for closure. Add evidence opens "Add evidence to AUD-n-Fn", with Link existing filtered to the finding's controls.
    - They show only to the people Compass already lets add closing evidence: the finding's owner, its corrective action's owner, and Manage audits. Someone who can only read the audit sees the evidence but no buttons.
    - They show only between the plan being accepted and the finding being submitted for closure. After that the section is read-only.
    - The User Portal's corrective action page is unchanged.

    Call for you to overturn: Compass itself still accepts closing evidence at other stages (open, plan submitted, closure submitted), which is how the portal and Polaris work today. Only the screen holds to "plan accepted, not yet submitted for closure". Tightening Compass's own rule too would change what the portal allows, so I didn't.
- id: 01M7YVZW1V7JGEYK8W21F7NFFF
  author: Steve Vine
  at: 2026-11-21T10:56:16.955668Z
  text: |-
    Passed (pre-UAT recheck, staging d4a5f0b5a, 21 Nov, E2E Test Company, as E2E Admin A)

    Steps and what I saw:
    1. Audits ▸ AUD-1 ▸ Findings ▸ AUD-1-F2 (status Plan accepted). Closing evidence now has Add evidence on its heading line, lists EVD-62 and EVD-73 with Take off, and has Submit for closure underneath.
    2. Add evidence opens "Add evidence to AUD-1-F2". Link existing evidence opens filtered "On NES.1, NES.3" (the finding's controls; the chip clears the filter), 5 pieces. EVD-73, already on the finding, is ticked and greyed with "Already on AUD-1-F2".
    3. Ticked Wireless Communication Policy and pressed Link 1. It appeared straight away under Closing evidence ("Policy or procedure · provided by E2E Admin A, 21 Nov 2026 · In the register") with Take off.
    I didn't submit for closure, and left the policy linked to the finding.

    Not checked: that someone who can only read the audit sees no buttons.

    Screenshots: ~/compass-uat/s9hexqn/COM-2053/ (finding-closing-evidence-buttons.png, link-existing-filtered.png, closing-evidence-section.png, after-link.png)
assignee: steve
label:
- bug
priority: high
task_status: done
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