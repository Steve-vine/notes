---
id: 01M8GRZE9MEJAH5CP0RJC0EZ9Z
created: 2026-11-28T09:49:56.916459Z
updated: 2026-11-28T09:50:02.938971Z
type: task
title: 'Scripts and workflows write to the Event log: runs succeeded or failed, retried or dealt with, scripts published or retired, workflows enabled or disabled'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2235
sprint: s09wwd3
assignee: steve
label:
- feature
priority: medium
task_status: todo
---
**On the chain.** After the Event log task. ADR COM-2225 settles the list; this is the proposal.

## What people see
Admin ▸ Event log gains these, each with its entity linked and its company where there is one:

**Scripts**
- Run succeeded: **Info**, "Create CRM user ran for Ada Lovelace (ACR-213): CrmUserId 4512".
- Run failed or timed out: **Alert**, with the reason ("…failed: That sign-in name is already in the CRM").
- Run retried (and how it went), or marked as dealt with with its note: **Info**.
- Version published (with its note), retired or restored: **Info**.

**Workflows**
- Run met or not met: **Info**, with the run's one-line summary.
- Run failed: **Alert**, with the reason.
- A before-script held a person: **Warning** ("Ada Lovelace (ACR-213) held: Create CRM user failed").
- Carried on without it: **Warning**, with who and why.
- Enabled or disabled, by whom: **Info**.

**Integrations** (scripts depend on them)
- An action integration's Test connection failed, or it was switched off: **Warning**.

Only these. Nothing else in Compass writes events yet; more areas can follow.

**Done when:** on staging, Run now, a failed run, a retry, publishing a script, and enabling, running and failing a workflow each appear in the Event log with the right type, entity and detail.