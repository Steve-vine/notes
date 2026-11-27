---
id: 01M8EVV51Z35MTQ7HGQ0RNPKQ7
created: 2026-11-27T16:01:33.247105Z
updated: 2026-11-27T16:04:30.03654Z
type: task
title: 'A new built-in role, Script Manager: the only people who can write, publish and run scripts'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2193
sprint: snt3b17
blocked_by:
- 01M8EVTSMYCWN977F49XWV61RH
assignee: steve
label:
- feature
priority: high
task_status: todo
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