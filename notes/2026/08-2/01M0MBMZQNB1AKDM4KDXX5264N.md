---
id: 01M0MBMZQNB1AKDM4KDXX5264N
created: 2026-08-22T09:08:25.973922Z
updated: 2026-08-22T09:08:25.973922Z
type: task
title: Replace the four vendor roles with vendor_admin / vendor_approver / vendor_user
label: feature
assignee: steve
priority: medium
task_status: backlog
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 345
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