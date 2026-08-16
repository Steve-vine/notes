---
id: 01M067CE6ZZ1Z4P463X4HXPXYF
created: 2026-08-16T21:24:29.535068Z
updated: 2026-08-16T21:24:32.835494Z
type: task
title: 'Request form: Contacts section moves above the Engagement section'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 229
sprint: sbph5q5
assignee: steve
label:
- improvement
priority: medium
task_status: active
---
Follow-up to COM-228 from smoke-testing (2026-08-16): the Contacts section sits at the bottom of the New Vendor request form, below the engagement question set. Move it **above** the Engagement divider, directly under the vendor fields (name / website / description).

Contacts are a vendor-level fact — COM-228 refuses them on the engagement request kinds for exactly that reason — so they belong beside the vendor block rather than trailing the engagement one. The COM-209 engagement question set keeps its internal order; only the Contacts block moves.

- [ ] `RequestVendorModal.tsx`: move the Contacts divider + rows + "Add contact" button above the `Engagement` divider; update the placement comment (its "contacts last, the approver's questions come first" rationale no longer applies).
- [ ] Tests: unchanged in substance — confirm the contact `Name` label still resolves distinctly from `Vendor name`.

Frontend only; no API change.