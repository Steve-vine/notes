---
id: 01M02VDQ06KPCSNAY4DW431QNT
created: 2026-08-15T13:57:45.094696Z
updated: 2026-08-15T13:57:51.669695Z
type: task
title: Frontend — Criticality rubric admin tab + criticality picker with definitions on request and engagement forms
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 209
sprint: sbph5q5
blocked_by:
- 01M02VDB867ANRGG857S9HNHF6
assignee: steve
label:
- feature
priority: medium
task_status: todo
---
Frontend half of engagement-level Business Criticality (stacks on COM-208).

- [ ] **New Admin tab "Criticality rubric"** (`pages/AdminPage.tsx`) alongside Maturity / Risk / Data rubric — mirror of `DataRubricSection`'s level editor: the four fixed levels, definitions editable inline, admin-gated.
- [ ] **Reusable criticality picker with definitions**: a Select for Low/Medium/High/Critical with all four rubric definitions rendered below it (fetched from `GET /criticality-levels`), so the chooser has the meanings in front of them.
- [ ] **`RequestVendorModal`**: picker added to the **Engagement** section for new_vendor (and new_engagement); **required** before submit — the requester is best placed to set it, and a blank value slips past `min_criticality` rules. Amend-engagement modal offers `proposed_criticality`.
- [ ] **Internal Engagements card** (vendor detail add/edit engagement modal): same picker + definitions — engagements are where the value lives now.
- [ ] **Vendor criticality read-only**: remove the editable criticality field from internal vendor create/edit forms; display the derived value (pill) with a hint that it derives from the highest active engagement.
- [ ] Tests: admin tab render + edit, request modal requires criticality, engagement modal carries it, vendor form no longer submits it.