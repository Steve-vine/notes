---
id: 01M02VDQ06KPCSNAY4DW431QNT
created: 2026-08-15T13:57:45.094696Z
updated: 2026-08-16T16:18:22.769158Z
type: task
title: Frontend — standardised engagement question set, criticality + data-entity pickers, rubric admin
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 209
sprint: sbph5q5
blocked_by:
- 01M02VDB867ANRGG857S9HNHF6
- 01M02X9MWV1K06A3WPCGC1KSEF
comments:
- id: 01M033J84GDYR65RTDZHA90RTW
  author: Steve Vine
  at: 2026-08-15T16:20:02.320257Z
  text: |-
    Done — PR #208 (feature/com-209-engagement-question-set, stacked on #207 → #206). Every checklist item landed; the question set is in the specified order on both forms.

    Two reusable pickers: CriticalityPicker (four levels with all four rubric definitions rendered beneath — the definitions are the whole point, since the word chosen decides which approvals fire) and DataEntityPicker (mirrors DataTypePicker including alsoAllow, so editing an old engagement can't silently drop a since-disabled entity). Criticality is required on both request forms and the internal engagement modal.

    Admin: new "Criticality rubric" tab; Data rubric tab gains a "Data entities" section. The criticality editor deliberately offers no name field — each level IS a VendorCriticality value rendered as a StatusPill across the app, so renaming one would leave every pill saying something else. There's a test asserting the name is not editable, so a future "helpful" addition of a name input fails.

    The vendor's criticality now renders as a derived pill with "Derived from the highest of this vendor's active engagements" where the editable field used to be (the field itself was removed in COM-208, since the contract change forced it).

    One shared-test addition worth knowing about: selectOption() in test-utils scopes a Mantine Select's options to its own listbox via aria-controls. Mantine keeps dropdowns mounted once rendered, so with a criticality picker beside the register's criticality filter, getByRole('option', {name: 'High'}) is ambiguous. Three test files needed it, so it went in the helper rather than being copied three times.

    Frontend suite: 261 passing across 51 files. No API change — OpenAPI drift check clean.
assignee: steve
label:
- feature
priority: medium
task_status: done
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