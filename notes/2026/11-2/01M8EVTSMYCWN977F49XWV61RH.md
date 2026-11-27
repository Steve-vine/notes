---
id: 01M8EVTSMYCWN977F49XWV61RH
created: 2026-11-27T16:01:21.566241Z
updated: 2026-11-27T16:52:09.556719Z
type: task
title: 'ADR 0185: Scripting — Compass runs scripts people write, against action integrations, from workflows triggered before and after joiners, movers and leavers'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2192
sprint: snt3b17
comments:
- id: 01M8EYQSGRB22K0CR83CPVCSFZ
  author: Steve Vine
  at: 2026-11-27T16:52:08.856652Z
  text: |-
    Written: PR #2198, merged to main as 67221f357. decisions/0185-scripting.md, Status: Proposed.

    What it records:
    - Action integrations: connections that can make changes, defined on screen (SQL Server first, a web service such as Cloudflare's API later). No code knows a service. Compass assumes the service is reachable (Twingate). Private addresses go on the approved internal addresses list, so an action integration can never point at Compass's own database. Credentials are write-only.
    - Scripts: declared inputs and outputs; inputs always passed as values, never pasted into the text. Draft, then publish; every version kept. Preview shows what would be sent; Run now runs for real after a confirmation. No automatic undo. SQL now, then PowerShell and Python, which must run in a sealed-off container.
    - Script Manager role: one person can write, publish and run.
    - Before/after triggers for joiners, movers and leavers, per person, each publishing its values. Outcome, Business role and Company conditions. A Run script step whose outputs pass to later steps.
    - A failed before-script holds a joiner or mover (Retry / Carry on without it). A failed after-script raises an Action with Retry and never changes the request. Compass never retries by itself.
    - §9 answers each objection ADR 0062 made to saved SQL and uploaded scripts. Amends ADR 0062 §6, 0154 §1 and 0155 §4.

    For you to decide (calls marked in the ADR, change any and I'll amend it):
    1. The built-in Admin doesn't hold Script Manager automatically (like Access Privilege Approver).
    2. A failed before-script never holds a leaver.
    3. Scripts and action integrations are organisation-wide; each company's workflows choose which to run.
    4. Default time limit 2 minutes, at most 15.

    Mark it Accepted once you're happy with those.
assignee: steve
label:
- brief
priority: high
task_status: review
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