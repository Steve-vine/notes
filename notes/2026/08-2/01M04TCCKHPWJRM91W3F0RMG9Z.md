---
id: 01M04TCCKHPWJRM91W3F0RMG9Z
created: 2026-08-16T08:18:01.969137Z
updated: 2026-08-16T08:18:09.223252Z
type: task
title: Vendor additional owners — main owner + co-owners, honoured by the portal
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 222
sprint: sbph5q5
blocked_by:
- 01M0313XDNMV364QN18S8MNTRJ
assignee: steve
label:
- feature
priority: medium
task_status: todo
---
A vendor keeps its main owner (`owner_id`) and gains **additional owners** (decided 2026-08-16). Everywhere the portal gates on "is the owner", additional owners count.

- [ ] **Model + migration**: `vendor_additional_owners` M2M (`vendor_id`, `user_id`, unique pair; `ondelete` consistent with `owner_id`'s SET NULL semantics — a deactivated/deleted user just drops out). Main owner stays a distinct single column — not folded into the M2M — so "the accountable owner" remains unambiguous.
- [ ] **Single ownership helper**: `user_is_vendor_owner(vendor, user)` = main owner OR additional owner — the one place the definition lives; portal gates use it (COM-221 contacts write, COM-220 My Vendors filter: vendors where I'm main **or** additional owner).
- [ ] **API**: additional owner ids on vendor read schemas (internal + portal, names resolved via the COM-215 directory); set/replace via vendor update, validated like `_validate_owner`. Main owner may not also be listed as additional (normalise silently).
- [ ] **Frontend (internal details card)**: "Additional owners" multi-select over the user directory, next to the main Owner picker. Management is internal-only for now (assumption 2026-08-16 — portal honours but does not manage; say the word for portal-side management).
- [ ] **Portal display**: detail page shows Owner + Additional owners by name.
- [ ] Tests: helper truth table, My Vendors includes co-owned vendors, portal contacts write allowed for additional owner / denied for non-owner, main-owner normalisation.

Stacks on COM-215 (directory + owner picker); COM-220 and COM-221 gates adopt the helper.