---
id: 01M84ETCYZJZ2BX572RS8K2TV8
created: 2026-11-23T15:01:32.767959Z
updated: 2026-11-23T15:01:41.195149Z
type: task
title: Provide a register suggests live registers first — an archived one is never among the suggestions
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2110
sprint: ssj8zkq
assignee: steve
label:
- bug
priority: low
task_status: active
---
Sprint "Registers - Phase 2". Found in the pre-UAT pass of COM-2094 on staging e2248892e (23 Nov 2026). Screenshot: `~/compass-uat/sprint-122/COM-2094/02-suggested-registers-first.png`.

## The problem
On a request, Provide a register lists archived registers under "Kept for this request's controls", including one marked Restricted · Archived.

## What people see
- "Kept for this request's controls" holds only live registers.
- An archived register can still be chosen, because an audit may need one as it stood during its period. It's listed after every live register, under its own heading "Archived", and marked as archived.
- Nothing else about who can choose a register changes.

Assumption, for Steve to confirm: archived registers stay available to provide, because an archived register can still be opened and exported (ADR 0165).

## Done when
- An archived register kept for the request's controls isn't in the suggestions.
- It can still be found under Archived and provided as at a day.
- A register the person can't open is still not offered.

No migration expected.