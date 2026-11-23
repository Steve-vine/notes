---
id: 01M84EST11VSJ57B8GPYDEW9V8
created: 2026-11-23T15:01:13.377307Z
updated: 2026-11-23T15:01:15.942879Z
type: task
title: An audit's trail shows a Restricted register by name to people who can open it
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2108
sprint: ssj8zkq
assignee: steve
label:
- bug
priority: medium
task_status: active
---
Sprint "Registers - Phase 2". Found in the pre-UAT pass of COM-2104 on staging e2248892e (23 Nov 2026). Screenshot: `~/compass-uat/sprint-122/COM-2104/03-admin-request-history.png`.

## The problem
Admin A owns a Restricted register and provides it to an audit request. The request's History and the audit's Activity tab read "Added a Restricted register, as at 23 Nov 2026 to request UAT-4", while the same request lists the register by name just above. The hiding from COM-2104 is applied to people who can open the register as well as those who can't.

## What people see
- Someone who can open the register (its owner, editors, an administrator) reads the line in full, with the register's name.
- Someone who can't still reads "A Restricted register".
- This holds on a request's History and the audit's Activity, and for providing, removing and withdrawing it.

## Done when
- The owner, an editor and an administrator see the register's name on both.
- Someone who can't open it sees only "A Restricted register" on both.
- A line written before the register was restricted follows the same rule.

No migration or API change expected.