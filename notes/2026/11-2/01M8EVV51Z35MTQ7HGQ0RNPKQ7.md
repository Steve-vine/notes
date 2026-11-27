---
id: 01M8EVV51Z35MTQ7HGQ0RNPKQ7
created: 2026-11-27T16:01:33.247105Z
updated: 2026-11-27T20:06:01.160671Z
type: task
title: 'A new built-in role, Script Manager: the only people who can write, publish and run scripts'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2193
sprint: snt3b17
blocked_by:
- 01M8EVTSMYCWN977F49XWV61RH
comments:
- id: 01M8F9TRH36R7N3Z5DV8WWTNB1
  author: Steve Vine
  at: 2026-11-27T20:06:00.483529Z
  text: |-
    Built: PR #2200, merged to main (not on staging yet; it goes with the sprint deploy).

    What's there:
    - A new built-in role, **Script Manager**, under Admin ▸ Roles. It is the only role that holds the new right **Manage scripts** (write, publish and run scripts, and retry or dismiss failed runs).
    - **Admin doesn't hold it**, so an administrator must give the role to someone, or to themselves, deliberately. Seeing scripts and their runs needs only the right to see Automation.
    - **Manage scripts can't be put in a custom role**, and a custom role can't be called "Script Manager". The role is the one place this right is held, so "who can change our CRM?" is answered by the list of people with that role.
    - Giving or removing the role is recorded in the activity log, as for any role.

    For you to look at:
    - These are calls I made in ADR 0185, to confirm or change: Admin not holding it, and the right being kept out of custom roles.
assignee: steve
label:
- feature
priority: high
task_status: review
---
**On the chain** (a new permission and built-in role; the API checks it). ADR 0185 (COM-2192).

## What people see
- **Admin ▸ Roles** lists a new built-in role, **Script Manager**: "Writes, publishes and runs scripts that change other systems (Automation ▸ Scripts)."
- Only its members can:
  - create and edit scripts;
  - publish a version;
  - **Run now**;
  - retire a script;
  - add a *Run script* action to a workflow (or change which script one runs).
- **Everyone who can see Automation** can read scripts, their versions and their run history, but not the credentials, which nobody ever sees.
- **The built-in Admin doesn't hold it automatically**, as with Access Privilege Approver (ADR 0183); an Admin can give it to people, including themselves. *(Assumption, for Steve to confirm in the ADR.)* A custom role can include it.
- **Action integrations** (the connections scripts use) stay with whoever can **manage integrations**, as for every other integration. A Script Manager picks from them.
- **Polaris** follows the same rule: it can read scripts and runs for anyone who can see Automation. Writing or running a script through Polaris is not in this sprint.

## Notes (technical)
- New permission(s) (`manage_scripts`), added beside `BUILT_IN_ONLY_PERMISSIONS` / the `EXCLUDED_FROM_ADMIN` set that COM-2181 introduces (build after COM-2181 if it hasn't landed; otherwise add that set here).
- Built-in role seeded by migration. The roles seed and the permission count tests pin numbers; update them.
- Permission checks on every script and workflow-script endpoint; the frontend hides controls without it.

**Done when:** on staging, a user with only Script Manager (plus Automation viewing) can create a script, and an Admin without the role can see scripts but can't edit, publish or run one, until they give themselves the role.