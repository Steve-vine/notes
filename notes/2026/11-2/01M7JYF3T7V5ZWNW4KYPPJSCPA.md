---
id: 01M7JYF3T7V5ZWNW4KYPPJSCPA
created: 2026-11-16T19:48:40.391304Z
updated: 2026-11-16T22:59:14.021923Z
type: task
title: A check's lookup can read its names from one entry of a list (e.g. the choices of one form field), so they stay current
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1874
sprint: s7nqsy0
assignee: steve
priority: medium
task_status: todo
---
From Steve's testing of round 2 (staging 43d03f09).

**The problem.** A check's lookups turn codes into names, e.g. change status 2 into "Planning". A lookup either re-reads a list from the service on every capture, which keeps it current, or carries a fixed copy. A list read from the service has to be flat: one item per code. Many services instead keep the names somewhere else: as the choices of one entry in a list of form fields, e.g. the "Status" field's choices in the service's list of change form fields. A lookup can't select that entry, so Polaris falls back to a fixed copy. If an admin then renames a value in the service, Compass silently keeps the old name. A new value shows as "7 · no name in …".

Example: on staging, CHK-24 (Test Company) carries fixed copies of Change types, Risk and Change statuses. FreshService admins can edit all three. Approval statuses is built into FreshService, so a fixed list is right for it.

**What to build.** This is a general capability in the configuration language. No code knows about a particular service (ADR 0147 §9).
- A list read from the service can say which of its items to use (e.g. the one whose `name` is `status`), and where that item's names are (e.g. its `choices`, each with a code and a name).
- It is read once per capture, like any list read from the service, under the same limits.
- If the item it names isn't there, the run fails and says which list and which item. It never quietly falls back to codes.

**Done when**
- A lookup can take its names from one entry of a list read from the service. This is shown in plain words on the check's Details, e.g. "the choices of Status in Change form fields, read every capture".
- Polaris prefers this to a fixed list whenever the names live in the service and can be edited there. It keeps a fixed list only for values built into the service (taken from its documentation), and says which kind it chose and why.
- An ADR 0148 amendment records the new capability.
- Polaris proposes a change to CHK-24 on staging (Test Company) that moves Change types, Risk and Change statuses to read every capture. It goes through Review like any reads change, and Steve approves it. After the next capture, renaming a status in FreshService shows the new name in Compass.
- Tests cover: the item is selected; the item is missing (the run fails with a clear message); the names are read once per capture across several lookups that use the same list; and the no-per-service-code test still passes.

**Where** (for the builder): core/collection/lookups.py (`check_lookup`, `_check_read`, `used_lists`, `_names`), the Polaris collection tools and instructions, decisions/0148.