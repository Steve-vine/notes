---
id: 01M0MBMZQNB1AKDM4KDXX5264N
created: 2026-08-22T09:08:25.973922Z
updated: 2026-08-25T18:42:51.197647Z
type: task
title: Replace the four vendor roles with vendor_admin / vendor_approver / vendor_user
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 345
sprint: sbph5q5
blocked_by:
- 01M0MBMMPRWVG5GGDRPDH3XJ1B
comments:
- id: 01M0ME5SAJ5308J4N7K121YANC
  author: Steve Vine
  at: 2026-08-22T09:52:33.618054Z
  text: |-
    Done — merged as #347 (38964ac).

    **Migration 0091** is the 0019/0034/0050 promote pattern run forward. One thing the ticket's plan didn't have: `user_role` is carried by **two** tables — `user_roles` and `sso_group_role_mapping_roles` (ADR 0046 §5 group→role policy) — so both columns are swapped, and both need the owner/portal de-dupe first, since both have a composite PK including `role`. The mapping happens *inside* the `USING` cast rather than as an UPDATE before the type swap, which is one statement per column instead of two passes and leaves no instant at which an account holds nothing.

    **Capability sets** are as specified. `_VENDOR_ASSESS` gaining `vendor_admin` needed no code change in `decide_from_body` — it already checks area membership for everyone who is not a *global* admin, so a vendor-admin must list themselves. That is exactly §2's rule, already enforced.

    **The narrowing bit.** `vendor_user` losing internal register read broke 17 integration tests, all of the same shape: a vendor-owner proving "reads the sub-resource but cannot write it". `viewer` is that role now, so those moved to it rather than being deleted. Two changed meaning rather than actors: the linked-risks test asserted the reader lacked Company read (a `viewer` has it, so the risk-side listing is now 200), and the approvals-queue gating test now asserts the requester *cannot* read the internal queue — they follow their request from the portal.

    `cli.py` needed nothing — it only ever seeds `admin`.

    **Left for COM-347 deliberately:** COM-225's `can_decide` field. Removing it here would have orphaned the payload for one commit; its test is updated to the new truth (vendor_admin holds assess) with a pointer to §5.

    Verified: 622 integration + 144 unit passing, mypy strict, ruff, 513 frontend tests, tsc, eslint, prettier, and `check-openapi-drift.sh` regenerated `schema.d.ts`.
assignee: steve
company: null
label:
- feature
priority: medium
task_status: done
---
The implementation parent for the role consolidation ADR. One coordinated change: enum, capability sets, guards, routers, frontend role names.

## Migration

- [ ] Forward **rebuild of `user_role`** under a temp name (the 0019/0034/0050 promote pattern, run forward this time): drop `vendor_owner` / `vendor_manager` / `vendor_assessor` / `vendor_portal`, add `vendor_admin` / `vendor_approver` / `vendor_user`.
- [ ] Migrate grants **before** the type swap: `vendor_manager → vendor_admin`, `vendor_assessor → vendor_approver`, `vendor_owner → vendor_user`, `vendor_portal → vendor_user` (dedupe a user holding both).
- [ ] Remember the enum-reuse gotcha: `postgresql.ENUM(create_type=False)` where later migrations touch the type.

## Capability sets (`models/user.py`)

- [ ] `_VENDOR_READ` = {admin, viewer, vendor_admin} — owners no longer read the internal register; viewer keeps app-wide read.
- [ ] `_VENDOR_WRITE` = {admin, vendor_admin}.
- [ ] `_VENDOR_SUBMIT` = {admin, vendor_admin, vendor_user}.
- [ ] `_VENDOR_ASSESS` (decide) = {admin, vendor_admin, vendor_approver} — role gates the surface; area membership still gates the work, and now **vendor_admin must be listed too** (only global admin bypasses, in `decide_from_body`).
- [ ] `_PORTAL_ONLY` = {vendor_user, vendor_approver, recertifier}; `_PORTAL_READ` recomposed accordingly.

## Everything downstream

- [ ] Guards in `core/auth.py` unchanged in shape; every router already goes through them — verify the reference-data routers (approval areas, criticality levels, data sensitivity, data types, business roles) land where intended (vendor_admin write, register-reader read).
- [ ] Frontend: role names in types/nav/guards; admin-portal Vendors section is vendor_admin (+ viewer read-only); assessor-specific internal surfaces retire in favour of the portal (formalised by the portal Requests task).
- [ ] `cli.py` role seeding/help text; OpenAPI/schema.d.ts regen; the full test sweep (role fixtures everywhere).

Likely wants to land as a small stack rather than one PR — migration+model first, surfaces on top.