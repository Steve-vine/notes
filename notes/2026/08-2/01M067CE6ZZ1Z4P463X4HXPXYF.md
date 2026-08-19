---
id: 01M067CE6ZZ1Z4P463X4HXPXYF
created: 2026-08-16T21:24:29.535068Z
updated: 2026-08-19T14:51:25.619439Z
type: task
title: 'Request form: Contacts section moves above the Engagement section'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 229
sprint: sbph5q5
comments:
- id: 01M068GEZ4HTPXYPM259EC4B6M
  author: Steve Vine
  at: 2026-08-16T21:44:09.956093Z
  text: |-
    Shipped: PR #229, merged and deployed — image `staging-20260816-2141` (`866764c`), smoke check green.

    The Contacts block moved above the `Engagement` divider, directly under name / website / description. Form order is now: Vendor name · Website · Description → **Contacts** → Engagement (Scope · Justification · Criticality · Data types · Data entities · Residency · Access · Sub-processors).

    The placement comment was rewritten — COM-228's "contacts last, the approver's questions come first" rationale no longer applies, and the better argument is the one the API already makes: contacts are a vendor-level fact (the request schema refuses them on the engagement kinds for exactly that reason), so they belong beside the vendor's own fields rather than trailing questions about one piece of work.

    Nothing else moved: the COM-209 engagement question set keeps its internal order, and no API call was touched. Frontend only, no migration.

    **Tests:** added one asserting Contacts precedes Engagement in the DOM, so placement cannot silently regress on the next edit to the modal — this task exists because a JSX move is invisible to a reviewer otherwise. Existing COM-228 tests unchanged and still passing, which also confirms the contact `Name` label still resolves distinctly from `Vendor name` after the move. Full frontend suite green (311).
assignee: steve
label:
- improvement
priority: medium
task_status: done
---
Follow-up to COM-228 from smoke-testing (2026-08-16): the Contacts section sits at the bottom of the New Vendor request form, below the engagement question set. Move it **above** the Engagement divider, directly under the vendor fields (name / website / description).

Contacts are a vendor-level fact — COM-228 refuses them on the engagement request kinds for exactly that reason — so they belong beside the vendor block rather than trailing the engagement one. The COM-209 engagement question set keeps its internal order; only the Contacts block moves.

- [ ] `RequestVendorModal.tsx`: move the Contacts divider + rows + "Add contact" button above the `Engagement` divider; update the placement comment (its "contacts last, the approver's questions come first" rationale no longer applies).
- [ ] Tests: unchanged in substance — confirm the contact `Name` label still resolves distinctly from `Vendor name`.

Frontend only; no API change.