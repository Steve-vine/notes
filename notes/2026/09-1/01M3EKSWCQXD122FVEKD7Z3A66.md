---
id: 01M3EKSWCQXD122FVEKD7Z3A66
created: 2026-09-26T10:22:33.879483Z
updated: 2026-09-26T10:24:08.185273Z
type: task
title: 'When Compass can''t make a change itself, it becomes a to-do: on-premises groups first'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 762
sprint: ss8v7d0
assignee: steve
label:
- feature
priority: high
task_status: todo
---
Most of the tenant is synced from on-premises Active Directory. On staging (2026-09-26): 1,441 of 1,551 accounts, 152 of 766 assigned security groups, 1,288 of 1,437 distribution lists, 21 of 72 mail-enabled security groups. Microsoft only allows changes to a synced object in AD, and Compass has no connection to AD. Today a role can still map an on-premises group: **15 are mapped on staging**. A joiner, mover or leaver touching one fails at the write.

This task makes that kind of change a **manual step**: a to-do for a person, which Compass then confirms by seeing the change arrive. It builds the mechanism and applies it first to on-premises **security groups**. Later tasks reuse it for synced accounts (leavers), distribution lists and reversals.

**Carries an ADR** (next free number): *a change Compass cannot make is a to-do, and it is confirmed by observation, never by a tick.* It amends ADR 0045 §3/§5 so that an on-premises group can be mapped and governed, with the write carried out by a person.

## What people see

**On a request.** When the request executes, Compass does everything it can straight away. Each on-premises change shows a new **Manual — in AD** pill instead of Applied or Failed. While any manual step is open, the request reads **Waiting on N manual steps**, not Executed. When the last step is confirmed, the request completes as normal.

**The to-do.** Assigned to anyone holding a new permission, **Carry out on-premises changes**. It sits on their **Actions** list and is emailed like other actions. There is one to-do per person per request, covering all of that person's on-premises changes:

```
Add Sam Jones to 2 on-premises groups
Joiner · request #212 · approved by Deb Wharton, 26 Sep
AD account: sjones

  SG-Sales-Files     add       waiting
  SG-Leeds-Printers  add       waiting

[ I've done this ]   [ Can't do this… ]
```

- **Confirmed by observation.** When the directory refresh shows the change, that line turns **Applied**. When every line is Applied, the to-do closes. Nobody's tick can make a line Applied.
- **I've done this** takes the to-do off the list while Compass waits to see the change. If it hasn't appeared within **24 hours**, the to-do comes back to them, saying it was marked done but not yet seen.
- **Can't do this…** needs a reason. The line fails on the request with that reason, and the request ends **Failed** like any other failed change.
- **Urgency.** Removals for a leaver are urgent: emailed at once, overdue the next working day. Everything else goes in the digest and is overdue after two working days.

**No to-do for work that's already done.** If the mirror already shows the change when the request executes, the line is Applied and no to-do is raised.

**Migrating to the cloud tidies up.** If a group with an open line is converted in place from on-premises to cloud (same object, source flips), Compass makes the change itself on its next pass. It then closes the line, and the to-do if that was the last one. No role or request needs editing.

**In the role editor**, an on-premises group carries an **On-premises** pill. A short note says its changes are done by hand in AD.

## Out of scope

- Connecting Compass to AD.
- Accounts (the next task), distribution lists, and reversals of unrequested changes. Those are later tasks and reuse this mechanism.

## Notes

- Action source in `core/actions/access.py` (ADR 0055): module work, not one person's. Readers hold `access.carry_out_onprem`, a new permission in `core/permissions.py` alongside the other `access.*` ones. Urgency `immediate` for a leaver's removals, `digest` otherwise. Do **not** write a `notify()`.
- A manual line is its own outcome on the per-subject change trail. Record who marked it done and when Compass saw it, so the ledger tells the truth about who did what.
- Observation hooks onto the directory sync pass (`tasks/directory_sync.py`), which already refreshes `source` from `onPremisesSyncEnabled` every pass. The source flip is detected there too.
- Why a membership exists stays derived (ADR 0063). A line confirmed by observation is role-derived like any other.

**Done when:** a joiner whose role maps an on-premises group executes, the cloud parts apply, and a to-do appears for a permission holder. Adding the person in AD then (after sync) closes the to-do and completes the request, with no tick needed. Tests cover the 24-hour return, Can't do this, the already-there case and the in-place conversion, using the fake directory.