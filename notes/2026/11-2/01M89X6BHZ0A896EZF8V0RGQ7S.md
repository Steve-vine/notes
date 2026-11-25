---
id: 01M89X6BHZ0A896EZF8V0RGQ7S
created: 2026-11-25T17:48:56.76786Z
updated: 2026-11-25T22:31:43.056497Z
type: task
title: Approve their own requests goes only to Access Admin and Admin (and everything-ticked roles), not every role that approves privileged changes
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2170
sprint: s4qjpqd
comments:
- id: 01M8A0JMEY55NT2AR70J39R87H
  author: Steve Vine
  at: 2026-11-25T18:48:04.830189Z
  text: |-
    Merged: PR #2175, migration 0924_self_approval_narrowed. "Approve their own requests" is kept only by Access Admin, Admin, and any role holding everything else Admin holds; it's taken off every other role. A migration test covers the narrowing (including an everything-ticked custom role keeping it) and down/up.

    Seen on staging 2016209cf: E2E Access Manager no longer holds it (their role keeps "Approve a privileged change"). E2E Admin A still does. Browser smoke passed 41/41.

    For Steve: production hasn't run 0922 yet, so on release 0922 then 0924 leave only Access Admin, Admin and everything-ticked roles holding it. Any other role can be given it on screen.
assignee: steve
label:
- bug
priority: urgent
task_status: done
---
Sprint "Access Control Review". Fix-forward found by the staging Browser smoke (from COM-2166).

## Why
Migration 0922 gave "Approve their own requests" to every role holding "Approve a privileged change". On staging, the Access Manager role has that ticked, so E2E Access Manager could approve their own requests. Journey 5's new guard (COM-2169) caught it before anything ran. ADR 0179 §1 says the permission goes to the **Access Admin** role and **Admin**, and nobody else. Production would have widened in the same way for any role with the privileged tick.

## What changes
- A new migration takes the permission off every role except Access Admin, Admin, and any role that holds every other permission Admin holds. Taking it off one of those would quietly stop it counting as an administrator.
- An administrator can still give it to any role on screen afterwards.

## Done when
- On staging, E2E Access Manager no longer holds it, and Browser smoke journey 5 is green.
- A test covers the narrowing, including an everything-ticked custom role keeping it.
- **On the chain** (migration).