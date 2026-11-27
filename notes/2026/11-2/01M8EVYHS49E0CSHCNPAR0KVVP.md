---
id: 01M8EVYHS49E0CSHCNPAR0KVVP
created: 2026-11-27T16:03:24.580231Z
updated: 2026-11-27T16:04:35.789396Z
type: task
title: 'Workflow action Run script: each input filled from a trigger value, an earlier step''s output or a fixed value; outputs passed on; a failed before-script holds a joiner or mover (never a leaver)'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2198
sprint: snt3b17
blocked_by:
- 01M8EVWZT6GV2772J68J7TMCP1
- 01M8EVXTA39JAEF3Q3Z2VAT1GG
assignee: steve
label:
- feature
priority: high
task_status: todo
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