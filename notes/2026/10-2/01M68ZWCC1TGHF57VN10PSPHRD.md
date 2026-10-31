---
id: 01M68ZWCC1TGHF57VN10PSPHRD
created: 2026-10-31T12:45:17.569509Z
updated: 2026-10-31T12:45:20.887763Z
type: task
title: Browser journeys 1–3 click "Assign to me" on forms that now start owned by you — the staging Browser smoke went red after the Actions deploy
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1496
sprint: scpaa6p
assignee: steve
label:
- bug
priority: high
task_status: active
---
Sprint 100, Actions. Found by the Browser smoke after the sprint 100 deploy to staging (run 41201724877, 31 Oct 2026, 12:44 GMT).

## What's wrong

- Since COM-1482, the new-gap, new-incident and new-treatment forms start with the person creating them as owner. That makes the "Assign to me" button disabled: you already are the owner.
- Journeys 1 (raise a gap) and 3 (record an incident) still click it, and time out after 15 seconds. Journey 2 (add a risk, treat it) didn't run because it follows journey 1, and it clicks the same button.
- The app is right; the scripted journeys are out of date.

## Fix

The journeys accept a form that is already owned by the account, and click "Assign to me" only when it's still enabled. They also check the owner ends up as that account.

**Chain:** independent (app/e2e only).

**Done when:** the Browser smoke after the next staging deploy is green, with journeys 1, 2 and 3 passing.