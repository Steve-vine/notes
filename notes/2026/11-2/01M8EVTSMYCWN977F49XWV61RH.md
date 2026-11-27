---
id: 01M8EVTSMYCWN977F49XWV61RH
created: 2026-11-27T16:01:21.566241Z
updated: 2026-11-27T16:01:21.566241Z
type: task
title: 'ADR 0185: Scripting — Compass runs scripts people write, against action integrations, from workflows triggered before and after joiners, movers and leavers'
assignee: steve
label: brief
task_status: todo
priority: high
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2192
---
**Independent** (a decision record only). Write it first; every other Scripting task builds on it. Mark it Proposed, and Steve accepts it.

## What it records (Steve, 27 Nov 2026)
- **Why**: when someone joins, moves or leaves, other systems need changing too. The first example is a database change in a production system; another is a DNS record in Cloudflare. Compass already knows who, when and what, so it should make those changes, recorded like everything else.
- **Action integrations**: a new kind of integration that **can make changes**, defined on screen. It isn't only databases (Cloudflare's API is one too). What it can change is exactly what its account has been granted. Nothing in Compass's code knows a particular service (the ADR 0147 §9 rule holds: the service-specific part lives in the script and the integration's settings). Compass is agnostic about connectivity: it assumes the service can be reached (Twingate does it at Moneypenny), and a private address goes on the approved internal addresses list (ADR 0148 §8). Credentials are write-only.
- **Scripts** (Automation ▸ Scripts): name, connection, declared **inputs** and **outputs**, and the script itself, in a language: **SQL first**, then PowerShell and Python. Versioned: you edit a draft, and only a published version runs. Inputs always reach the script as values (parameters), never pasted into its text.
- **No automatic undo.** Rolling back a trial run is unworkable for real scripts (a delete, a DNS record). Instead, **Preview** shows exactly what would be sent without running anything, and **Run now** runs it for real after confirmation, recorded.
- **Who**: a new built-in role, **Script Manager**. One person can write, publish and run a script; no second approver is needed. Like Access Privilege Approver (ADR 0183), the built-in Admin doesn't hold it automatically (assumption, for Steve to confirm), because scripts change production systems.
- **Workflows widen beyond evidence**: new triggers *Before / After a joiner*, *a mover* and *a leaver*, per person. **Each trigger publishes the values it provides** (sign-in name, display name, roles, joiner fields, outcome…). There's an *Outcome* condition (Succeeded / Failed, after-triggers only), a *Business role* condition, and a **Run script** action whose inputs are picked from those values or from an earlier step's outputs. Outputs pass to later steps.
- **Before-triggers hold the person**: Compass makes that person's changes only once their before-workflows have finished. A failed before-script holds a **joiner or mover** with an Action: *Retry* or *Carry on without it*. It **never holds a leaver**: a leaver's account is never left enabled because a script failed. The leaver goes ahead and the Action records it.
- **After-scripts never change the request's outcome.** A failure raises an Action for the script's owner with **Retry**. Compass never retries by itself, so scripts should be safe to run twice.
- **Every run is recorded**: script version, inputs, outputs, duration, error, and what started it. It's shown on the script, the workflow run and the access request.

## What it supersedes / amends
- **ADR 0062** "Saved SQL is refused" (reports): still true for reports; Scripting is the deliberate exception, with the safeguards above.
- **ADR 0155 §4** "a workflow is data, never code" and "evidence only": a workflow stays data, but its **Run script** action runs a published script; triggers now include access events; and a workflow can run before an access change and hold it.
- **ADR 0154 §1**, the list of connections that can change things: add action integrations.

## Notes (technical)
- Number 0185 (0184 is on `feature/com-2182-entra-role-writes`). Check again before merging.
- Record the sandboxing requirement for PowerShell/Python, so it isn't forgotten later: they run in their own container with only the inputs and that one integration's credential, never in the worker that holds Compass's other secrets.

**Done when:** decisions/0185-*.md is merged to main, Proposed, with the above; Steve marks it Accepted.