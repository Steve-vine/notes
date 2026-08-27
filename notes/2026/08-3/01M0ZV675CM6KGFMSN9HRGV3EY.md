---
id: 01M0ZV675CM6KGFMSN9HRGV3EY
created: 2026-08-26T20:11:38.028324Z
updated: 2026-08-27T16:47:52.294775Z
type: task
title: Click the orange pill — a directory role gets a page, and it lists everyone who holds it
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 445
sprint: s5gwx0s
comments:
- id: 01M11TVWC65RYTCJ867VYMAF1F
  author: Steve Vine
  at: 2026-08-27T14:44:28.166492Z
  text: |-
    Done and merged — PR #444, on main as cc77abf.

    The role's page: name, description, built-in vs custom, and everyone who holds it — each person named, each marked as holding it directly or through a group, with the group named, because "via Privileged Admins" is where you would go to take the privilege away. Person and group both open from the row into the existing modals.

    A Directory Roles tab for browsing. Named apart from "Role matrix" deliberately: that tab means business roles, these are Entra's, and two tabs both reading "roles" would blur them.

    The pills link. COM-443 having folded the two call sites into one component made this one change instead of two, exactly as the brief predicted.

    One wrinkle worth knowing: Account details resolves its directory roles live from Graph, so it holds role names and no ids — there is nothing to link to directly. The name is matched against the mirror to find the role, and a name the mirror does not carry stays plain text rather than linking to nothing. The lookup is gated so the three non-role panels on that modal do not each pay for the role list.

    The mirror's "we could not tell" reaches the screen intact, which was the part most worth getting right:
    - Where the eligible half could not be read, list and page both say they are active-only and that somebody may be able to activate a role without appearing there.
    - A role with no holders AND a failed eligible read says "this may not be the whole picture" rather than a flat "nobody".
    - A holder that is not a mirrored person or group — a service principal — is counted and explained, not dropped.

    21 tests across three files, including one that COM-443's dark-mode contrast survives the pill becoming an anchor (an <a> brings its own colour rules), and one that the pill stays plain text with no target.

    For smoke testing:
    - Access Control > Directory Roles — the list, with holder counts and "some eligible" where it applies.
    - Click a role: holders, each marked Active or Eligible, and "via <group>" or "Directly". Click a person or a group to open them.
    - Account details on someone with a directory role: the orange pill should now be clickable and land on that role.
    - The groups list pill ("Grants directory roles") goes to the role list.

    Note, not caused by this task but worth its own: the frontend suite has a pre-existing load-dependent flake in PortalRouting.test.tsx and PortalVendorDetailPage.test.tsx. It fails on clean main under full-suite CPU load and passes in isolation; the two new test files here add enough load that it went from 1 failure to 5 locally. CI passed, but it is getting more likely to bite.
assignee: steve
company:
- moneypenny
label:
- feature
priority: medium
task_status: done
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