---
id: 01M8EVYHS49E0CSHCNPAR0KVVP
created: 2026-11-27T16:03:24.580231Z
updated: 2026-11-28T00:24:04.903405Z
type: task
title: 'Workflow action Run script: each input filled from a trigger value, an earlier step''s output or a fixed value; outputs passed on; a failed before-script holds a joiner or mover (never a leaver)'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2198
sprint: snt3b17
blocked_by:
- 01M8EVWZT6GV2772J68J7TMCP1
- 01M8EVXTA39JAEF3Q3Z2VAT1GG
comments:
- id: 01M8FJNQ6TTDW8WTPFZ9QV76SH
  author: Steve Vine
  at: 2026-11-27T22:40:32.474198Z
  text: |-
    Built: PR #2204, merged to main (not on staging yet; it goes with the sprint deploy).

    What's there:
    - **A new action, Run script**, for access workflows. Choose a published script, then say where each input comes from: a value the trigger hands on, an output of an earlier Run script step ("CRM user ID from Create CRM user"), or a typed value. **A hidden input can never be typed in.** A workflow can't be enabled while a required input is unmapped.
    - **Steps run one after another**, and each script's outputs reach the steps after it. A script that fails fails the run, the steps after it don't run, and its "Script · Retry" Action is raised. **A Retry that works carries the workflow run on** from that step, through the rest.
    - **Before-workflows hold a joiner or mover.** If a before-script fails, that person is marked failed with "Held by a script that runs before their changes: … Retry the script, or carry on without it, then retry the request". Other people on the same request aren't held. **A leaver is never held**: their account is disabled regardless.
    - **Carry on without it** is on the workflow run view, for anyone who can approve requests or a Script Manager. It asks why, records who and why, marks the failed scripts as dealt with and re-queues the request. A before-script retried successfully re-queues it too.
    - **Test against a past person** (held over from COM-2197): for an access workflow, the builder's Test picks someone from a recent request of that kind. It shows what the trigger would hand on, the path, and what each step would do ("Would run Create CRM user (version 1) with SignInName=…"). No script runs.
    - Script runs are recorded on their own, so what was done to another system is never lost if a later step fails.
    - Proven against a real SQL Server 2022: two scripts in a row with an output passed on, a failure and then a retry that carries on, a before-script holding a joiner and then carried on without, and testing against a past person running nothing.

    For you to look at:
    - These are calls I made in ADR 0185, to confirm or change: a leaver is never held, and Carry on is open to approvers as well as Script Managers.
- id: 01M8FRKA171100WNYYZJGSTDT4
  author: Steve Vine
  at: 2026-11-28T00:24:04.903064Z
  text: |-
    Pre-UAT, staging 20261127-2345, as E2E Admin B: **Passed for what staging can show; Couldn't check the rest.**

    Passed:
    - Run script, choosing Create CRM user, asked where each input comes from, and offered the trigger's values and "Type a value". Mapping Sign-in name and Display name cleared the "Say where … comes from" problems.
    - Test against a past person (ACR-72): "Yes: The outcome was Succeeded", then "Would run Create CRM user (version 1) with SignInName=Compass.Test@moneypenny.co.uk, DisplayName=Compass Test". The test database's row count didn't change, so no script ran.

    Couldn't check (all need a joiner, mover or leaver actually carried out on staging, which creates or changes a real account in the staging tenant):
    - the after-joiner run;
    - the hold from a failing before-script;
    - Carry on without it;
    - a leaver not being held.

    These are proven against a real SQL Server in the integration tests. Please try one on staging.

    Screenshots: ~/compass-uat/scripting/COM-2198/.
assignee: steve
label:
- feature
priority: high
task_status: review
---
**On the chain.** After COM-2196 (running a script) and COM-2197 (triggers). ADR 0185.

## What people see
- **A new action, Run script** (adding or changing one needs Script Manager): choose a published script. Then, for **each of its inputs**, choose where the value comes from:
  - a value the trigger publishes ("Sign-in name");
  - an **output of an earlier Run script step** in the same branch ("CrmUserId from *Create CRM user*");
  - or a fixed value typed in.
  The editor only offers values of a matching type. **A required input left unmapped stops the workflow being enabled**, and says which one.
- **Outputs pass on**: a later step can use them, e.g. *Create CRM user* returns `CrmUserId`, then *Add CRM licence* takes it.
- **Several Run script steps in a row** run one after another; each waits for the one before. If one fails, the steps after it in that branch don't run.
- **The workflow run** shows each script step: the script and version, the values it was given (sensitive ones hidden), its outputs, its outcome and a link to the script run.
- **When a script fails in an *after* workflow**: the person's request is unaffected (their account is done). The script's owner gets the Action "Script failed: Create CRM user, for Ada Lovelace (ACR-123)". **Retry** runs that step again with the same values and, if it succeeds, carries on with the steps after it.
- **When a script fails in a *before* workflow**:
  - **Joiner or mover**: that person is **held**. Compass changes nothing for them, and the request shows "Waiting on a script: Create CRM user failed". The Action, to the script's owner and visible to the request's approvers, offers **Retry** (on success, Compass carries on with the person's changes) or **Carry on without it** (asks for a reason, recorded, and Compass makes the person's changes). Other people on the same request aren't held.
  - **Leaver**: **never held**. A leaver's account is never left enabled because a script failed. Compass makes the leaver's changes anyway, and the Action records that the before-script failed, with Retry.
- **A before-script that times out** counts as failed (so a hung script can't hold a joiner for ever).
- **Changing or disabling a workflow** doesn't affect runs already under way; they finish on the version they started with.
- Everything is in the activity log, including *Carry on without it* with its reason.

## Notes (technical)
- Action registered in `core/workflows/actions.py`. Its definition holds the script id and an input map (`{input: {from: trigger|step|fixed, ref|value}}`), validated at save and enable against the trigger's published values (COM-2197) and the script's published version's inputs/types. Republishing a script with a new required input marks workflows using it as needing repair (the existing "Workflow · Repair" Action).
- The engine runs Run script asynchronously: the workflow run pauses on the step, the script run (COM-2196) resumes it on finish. This is the first step that waits; keep it contained to script steps. Persist the position and value map on `WorkflowRun`.
- Before-hold: per-subject execution in `tasks/access_execute.py` checks for before-workflow runs not yet finished or failed for that subject; status text on the subject; resume when they finish. Expedited requests too. Leavers bypass the hold, and the bypass happens in code, not as a setting.
- *Carry on without it* needs the same right as approving the request (or Script Manager).
- Idempotency: one workflow run per (workflow version, trigger, subject); a re-delivered event doesn't run a script twice.

**Done when:** on staging, in E2E Test Company:
- An *After a joiner* workflow runs *Create CRM user* with the joiner's sign-in name and department and passes `CrmUserId` to a second script.
- A failure of the first raises an Action whose Retry completes both.
- A *Before a joiner* script that fails holds that joiner (not their colleague on the same request) until Retry or *Carry on without it*.
- A *Before a leaver* script that fails doesn't stop the leaver being disabled.