---
id: 01M04TCCKHPWJRM91W3F0RMG9Z
created: 2026-08-16T08:18:01.969137Z
updated: 2026-08-16T10:00:45.781746Z
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
task_status: active
---
A vendor keeps its main owner (`owner_id`) and gains **additional owners** (decided 2026-08-16). Everywhere the portal gates on "is the owner", additional owners count.

- [ ] **Model + migration**: `vendor_additional_owners` M2M (`vendor_id`, `user_id`, unique pair; `ondelete` consistent with `owner_id`'s SET NULL semantics — a deactivated/deleted user just drops out). Main owner stays a distinct single column — not folded into the M2M — so "the accountable owner" remains unambiguous.
- [ ] **Single ownership helper**: `user_is_vendor_owner(vendor, user)` = main owner OR additional owner — the one place the definition lives; portal gates use it (COM-221 contacts write, COM-220 My Vendors filter: vendors where I'm main **or** additional owner).
- [ ] **API**: additional owner ids on vendor read schemas (internal + portal, names resolved via the COM-215 directory); set/replace via vendor update, validated like `_validate_owner`. Main owner may not also be listed as additional (normalise silently).
- [ ] **Frontend (internal details card)**: "Additional owners" multi-select over the user directory, next to the main Owner picker.
- [ ] **Portal management** (decided 2026-08-16, supersedes the internal-only assumption): any owner (main or additional) can **add and remove co-owners from the portal** — portal-router endpoint gated by the ownership helper, picking from the user directory. Directory read must be reachable under portal auth for owners (adjust the COM-215 gating note accordingly).
- [ ] **Main-owner transfer** (added 2026-08-16): the **main owner only** can hand main ownership to another user, from the portal and internally. On transfer the previous main owner becomes a co-owner (call, 2026-08-16: they keep access and can remove themselves after — no accidental lock-out mid-handover); if the new main owner was a co-owner they drop off the co-owner list (normalisation). Co-owners cannot transfer main ownership.
- [ ] **Portal display**: detail page shows Owner + Additional owners by name; owners see the manage controls (co-owner management for all owners, transfer for the main owner).
- [ ] Tests: helper truth table, My Vendors includes co-owned vendors, portal contacts write allowed for additional owner / denied for non-owner, portal co-owner add/remove (owner allowed, non-owner 403), transfer (main owner allowed, co-owner 403, old main becomes co-owner, normalisation), main-owner normalisation.

Stacks on COM-215 (directory + owner picker); COM-220 and COM-221 gates adopt the helper.