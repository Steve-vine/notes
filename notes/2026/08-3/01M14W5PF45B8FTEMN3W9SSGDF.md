---
id: 01M14W5PF45B8FTEMN3W9SSGDF
created: 2026-08-28T19:05:01.668733Z
updated: 2026-09-01T13:55:52.0937Z
type: task
title: The standard governance reports, shipped as definitions
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 493
sprint: s42ntc9
blocked_by:
- 01M14W593XNB6MF34DCTT2F9QM
- 01M14W4VM3TKYMJ608D19AM97K
comments:
- id: 01M16R0J6CARZTQCNACJ0AZYMW
  author: Steve Vine
  at: 2026-08-29T12:30:48.01192Z
  text: |-
    Done and merged to main — PR #505, the last of the sprint.

    **Seventeen reports ship, not seven.** The table in this task is all there, and COM-492's mirror work made ten more expressible on the way past: public groups, personal devices reaching company data, invitations nobody accepted, passwords that never expire, enabled accounts with no licence, accounts privileged by any route, and COM-497's three plus the MFA-unknown population.

    Every one is a stored definition, so §4's constraint held: nothing here is a hand-written endpoint, and nothing needed a special case. Two of them are the reason the catalogue looks as it does, and both are worth knowing:

    **Inactive users.** "Over 90 days ago **or** never" cannot be said with a flat AND-ed condition list. Rather than adding boolean grouping to the definition language for one report, `days_inactive` falls back to the creation date for an account that has been *read* and never signed in — an account made two years ago and never used is two years inactive, which is what a reviewer means. It stays unknown while the sweep has not reached the account, so an unread account never satisfies a threshold.

    **Users without MFA** could not be "MFA registered is No" alone, because an account nobody has read has no answer at all. Nulls do not satisfy a positive comparison, so the unread population is excluded — and gets its own named report, *Accounts whose MFA is unknown*, rather than being folded in. Two reports beats one wrong one, and a population nobody can see is a population nobody chases.

    **"Role is privileged" has no field behind it**, and I did not invent one. Compass's own model (ADR 0061 §5) treats any directory role as privilege, so *Users holding privileged roles* is Role assignments where the holder is a person, with the assignment type as a column so active and eligible can never read as merged. If you want Microsoft's narrower `isPrivileged` flag instead, that is a one-line `$select` plus a column plus a catalogue entry — a small follow-up rather than something to bend this file for.

    **The build now breaks when the catalogue drops a field.** `test_every_standard_report_is_answerable_by_the_catalogue` is parametrised over the seeds and runs *without a database*, so it fails CI immediately rather than breaking a report somebody is relying on six months later in front of an auditor. That is ADR 0062 §3's second property, finally enforceable. There is also an integration test that *runs* every shipped report against an empty mirror — validating is not compiling, and a malformed derived field would otherwise fail the first time somebody opened it.

    **The importer overwrites rather than inserting-if-absent** — the opposite of the rubric seeds, and deliberate: a standard report cannot be edited in the app, so there are no in-app edits to preserve and a fix has to actually land. A report dropped from the tuple is deleted, so retiring one is an edit here rather than an orphan left in every library. An author's duplicate is a different row with no seed key and is never touched, with its own test, because otherwise the whole duplicate-rather-than-edit design is a lie.

    Wired into the Helm import Job last, since it reads nothing the other seeds write.
assignee: steve
label:
- feature
priority: high
task_status: done
---
ADR 0062 §4. The shipped library — written as definitions, seeded through the existing importer, indistinguishable in the library from a report Steve writes himself.

The first set:

| Report | Subject | Condition |
|---|---|---|
| Inactive users | Users | enabled, last sign-in over 90 days ago or never (needs COM-492) |
| Users holding privileged roles | Role assignments | role is privileged; active and eligible both shown, and never merged |
| Non-compliant devices | Devices | compliant = No |
| Groups without members | Groups | member count = 0 |
| Groups without an owner | Groups | owner count = 0 |
| Guest accounts | Users | type = Guest |
| Unattributed memberships | Governed memberships | provenance = unattributed |

**If one of these cannot be expressed, the catalogue is not finished and the fix is in COM-487** — not a hand-written endpoint. That is the whole point of seeding them (ADR 0062 §4): the built-ins are the proof the wizard is expressive enough, and a special case here would quietly demote every report anyone else writes.

Seeds are re-imported on every deploy (see the seed importer's existing behaviour), so a correction to a standard report is a correction to its seed. An author's *duplicate* of one is their own row and is never overwritten.