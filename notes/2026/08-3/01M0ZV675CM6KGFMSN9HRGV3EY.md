---
id: 01M0ZV675CM6KGFMSN9HRGV3EY
created: 2026-08-26T20:11:38.028324Z
updated: 2026-08-27T14:07:42.989619Z
type: task
title: Click the orange pill — a directory role gets a page, and it lists everyone who holds it
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 445
sprint: s5gwx0s
assignee: steve
company:
- moneypenny
label:
- feature
priority: medium
task_status: active
---
The orange shield pill names a privilege and then stops. "Compliance Administrator" on someone's Account details, "Grants Entra directory roles" on a group — both dead ends. The obvious next question is *who else has this*, and there is nowhere to click.

Stacks on COM-444, which gives Compass the record to read.

## What changes for the reader

**The pill is a link.** Click a role and you land on the role: what it is, and everyone who holds it — each person named, each marked as holding it directly or through a group, with the group named. From there you can open the person or the group, the way the rest of Access Control already lets you move between things.

Clicking the groups-list pill takes you to the roles that group grants, so the pill that says "grants directory roles" finally says which.

## Scope

**A role's page**, reached from any pill: the role's name and description, whether it is built-in, and its holders. If COM-444 lands eligible assignments as well as active ones, the page says which a person has — an eligible Global Administrator is not the same as an active one, and the page should not blur them.

**A list of roles**, so the roles in the tenant can be browsed rather than only stumbled on from a pill. A tab on Access Control is the natural home — the sprint's COM-437 puts the screen title above that tab bar, so a new tab lands cleanly.

**The pills become links** at both call sites — Account details (`access/UserDetailModal.tsx`) and the shared `DirectoryRoleBadge` on the groups list and group modal. COM-443 is already folding those two into one component; do that first and this is one change, not two.

Where a role's holders could not be resolved, the page says so rather than showing an empty list — the mirror's "unknown" carries all the way to the screen.

Read-only, on the existing access-read permission. Nothing here grants, revokes or requests a role.

## Tests

Component tests for the page and the list, plus one that a pill actually navigates. The unresolved-holders state is worth a test of its own — an empty list where the truth is "we could not tell" is the failure this feature would be most damaging for.