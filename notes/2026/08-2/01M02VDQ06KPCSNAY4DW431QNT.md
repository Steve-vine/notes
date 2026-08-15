---
id: 01M02VDQ06KPCSNAY4DW431QNT
created: 2026-08-15T13:57:45.094696Z
updated: 2026-08-15T14:30:50.5047Z
type: task
title: Frontend — standardised engagement question set, criticality + data-entity pickers, rubric admin
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 209
sprint: sbph5q5
blocked_by:
- 01M02VDB867ANRGG857S9HNHF6
- 01M02X9MWV1K06A3WPCGC1KSEF
assignee: steve
label:
- feature
priority: medium
task_status: todo
---
Frontend half of engagement-level Business Criticality and Data Entities (stacks on COM-208 + COM-210), plus the standardised engagement question set (decided 2026-08-15 — the new-vendor and new-engagement forms had drifted apart in COM-195 with no recorded reason).

**Standard engagement question set, in order, on BOTH request forms** (new_vendor's Engagement section and RequestEngagementModal):

1. Scope
2. Justification
3. Business Criticality — picker with rubric definitions below, **required**
4. Data Types
5. Data Entities — multi-select from the new vocabulary (COM-210)
6. Data Residency
7. Access Requirements
8. Sub Processors

(Justification stays a request-level payload field — the ordering is layout only. Residency/access/sub-processors are the three fields the new-vendor form was missing; all optional, as on the engagement form today.)

- [ ] **New Admin tab "Criticality rubric"** (`pages/AdminPage.tsx`) alongside Maturity / Risk / Data rubric — mirror of `DataRubricSection`'s level editor: the four fixed levels, definitions editable inline, admin-gated.
- [ ] **Data rubric tab gains a "Data entities" section** — admin-definable values (add / edit / disable), name + description, mirroring the data-types editor.
- [ ] **Reusable criticality picker with definitions**: a Select for Low/Medium/High/Critical with all four rubric definitions rendered below it (fetched from `GET /criticality-levels`), so the chooser has the meanings in front of them. A blank value slips past `min_criticality` rules — hence required.
- [ ] **`RequestVendorModal` + `RequestEngagementModal`** rebuilt to the standard question set above.
- [ ] **`AmendEngagementModal`**: can propose criticality and data entities alongside the existing five fields (sparse overlay unchanged).
- [ ] **Internal Engagements card** (vendor detail add/edit engagement modal): same pickers — criticality + entities live on the engagement now; engagement detail/cards display entities.
- [ ] **Vendor criticality read-only**: remove the editable criticality field from internal vendor create/edit forms; display the derived value (pill) with a hint that it derives from the highest active engagement.
- [ ] Tests: admin editors (criticality levels, data entities), both request modals enforce required criticality + carry the full field set in order, amendment modal proposes new fields, vendor form no longer submits criticality.