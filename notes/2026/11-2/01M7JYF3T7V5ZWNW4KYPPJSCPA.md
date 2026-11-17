---
id: 01M7JYF3T7V5ZWNW4KYPPJSCPA
created: 2026-11-16T19:48:40.391304Z
updated: 2026-11-17T20:31:42.822666Z
type: task
title: A check's lookup can read its names from one entry of a list (e.g. the choices of one form field), so they stay current
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1874
sprint: s7nqsy0
comments:
- id: 01M7MEZ2SFAZRV3TTCZGC1Q4Q3
  author: Steve Vine
  at: 2026-11-17T09:56:15.279028Z
  text: |-
    Done — PR #1886, merged d4c8766c.
    A check's lookup can now take its names from one entry of a list the service gives, such as the Status field's choices in its list of change form fields. The list is read every capture, so a status renamed in the service shows its new name at the next capture. Lookups on different entries of the same list share one read.
    If the entry has gone, the run fails and names the list and the entry ("The list Change statuses has no entry whose name is status…"). It never quietly falls back to codes.
    The check's Details have a new "Names" line saying where each code's names come from, e.g. "status: the choices of Status in Change form fields, read every capture". The card, the review card and the check's history use the same words.
    Polaris now prefers a list read from the service, or one entry of one, wherever the names can be edited in the service. It keeps a fixed list only for values built into the service (from its documentation), and says which kind it chose and why.
    ADR 0148 has a dated amendment. It's all configuration: no code knows FreshService.
    Assumption: moving a fixed list to a read is a new read, so on a live check it waits on Review (the existing rule).
    To do after deploy (coordinator): ask Polaris on staging (Test Company) to change CHC-24 (was CHK-24). Change types, Risk and Change statuses should read every capture, as entries of the change form fields list if that's where the service keeps them; Approval statuses stays a fixed list. The change goes to Evidence Collection ▸ Review for Steve to approve. After the next capture, renaming a status in FreshService should show the new name in Compass.
- id: 01M7MGCBVDJZG43XESBNSTFHBR
  author: Steve Vine
  at: 2026-11-17T10:20:59.117638Z
  text: |-
    Pre-UAT on staging 44d15b9a — Couldn't check (only the after-approval rename is left; nothing failed)
    - Lookup takes its names from one entry of a list, shown in plain words: Passed. As Polaris (staging MCP, acting as Steve) I tried CHC-24 in Test Company with Change types, Risk and Change statuses each read from one entry of FreshService's change form fields (/change_form_fields, items change_fields; the entry whose name is change_type / risk / status; its choices, code id, name value). The real FreshService read worked: 1 Minor, 2 Standard, 3 Major, 4 Emergency; 1 Low … 4 Very High; 1 Open, 2 Planning, 3 Awaiting Approval, 4 Pending Release …, all "read from the service". On the check's page (as E2E Admin A, looking only) the proposal reads e.g. "change.status: 1 → Open, 2 → Planning … from Change statuses (the choices of Status in Change form fields, read from the service)". Details' "Names:" line still shows the live version ("Change types, a fixed list (from FreshService change form fields …)"), which is right until it's approved.
    - Missing entry fails clearly: Passed (a try only, nothing saved). An entry named no_such_field gave "FreshService-SD: The list Change statuses has no entry whose name is no_such_field (GET /change_form_fields): the service's answer changed, or the entry was renamed".
    - Polaris prefers a read list and keeps fixed lists only for built-in values: Passed for Polaris over MCP. The instruction text on main says to use a read list or one entry of one wherever names can be edited in the service, and a fixed list only for values built into the service, and to say which kind it chose and why. Couldn't check Polaris designing a check in the app, because that needs Polaris's AI provider.
    - ADR 0148 amendment: Passed. "Amendment (2026-11-17, COM-1874): a lookup can read its names from one entry of a list" is on main.
    - Polaris proposes the CHC-24 change: Done. It was saved after the try and is waiting on Evidence Collection ▸ Review (Changes): https://compass.citops.net/automation/evidence-collection?tab=review&group=changes&item=a937ae18-2af9-4cc3-b357-ab514cce5134. It moves the three lists to be read every capture. Approval statuses has no lookup on this check: FreshService already sends it as a name ("approved"), so no fixed list was needed or added. I did not approve it.
    - Steve approves it, then renaming a status in FreshService shows the new name after the next capture: Couldn't check. That's Steve's to do: approve the change, rename a change status in FreshService, then Collect (or wait for 22 Nov) and check the Status column.
    - Tests: not re-run here (they're in the PR's CI).
    Observation: the words use the field's own name, so it reads "the choices of Change_type" rather than "Change type". It also says "read from the service" where the task's example says "read every capture".
    Screenshots: ~/compass-uat/s7nqsy0/COM-1874/
assignee: steve
label: null
priority: medium
task_status: done
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