---
id: 01M8EVYY51BS2A7VW7E2F5V61T
created: 2026-11-27T16:03:37.249403Z
updated: 2026-11-27T16:03:55.519641Z
type: task
title: An access request shows the scripts run for each person, before and after, with their outcome and outputs; Polaris can say what ran
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2199
sprint: snt3b17
assignee: steve
label:
- feature
priority: medium
task_status: todo
---
**On the chain** (the request's API gains its script runs; new Polaris read tools). After COM-2198. ADR 0185.

## What people see
- **On an access request**, each person gets a **Scripts** section, shown only when a script ran or is due:
  - **Before**: each script, its outcome (Succeeded / Failed / Running / Waiting), outputs ("CrmUserId: 4512") and when, linking to the script run and the workflow run.
  - **After**: the same.
  - A held person reads "Waiting on a script: Create CRM user failed", with **Retry** and **Carry on without it** right there for those allowed (the same as the Action).
- **The requests list** gets a filter, "A script failed", and a small marker on a request with a failed or held script.
- **A person's page** (Access Control ▸ People) lists the script runs about them, so "when was Ada's CRM account made, and what ID did it get?" has an answer.
- **The request's evidence export** includes each person's script runs (script, version, outcome, outputs; sensitive values hidden).
- **Polaris** (Automation and Access tools, read-only) can answer:
  - "What scripts ran for ACR-123?"
  - "Which script runs failed this week?"
  - "What does the Create CRM user script do?" (its inputs, outputs, integration, published version and text)
  Writing or running scripts through Polaris is not in this sprint.

## Notes (technical)
- Request detail API: per subject, the script runs, joined through workflow runs whose subject is that request subject.
- Polaris tools in the Automation area (MCP; watch the per-area 128-tool limit, ADR 0144); `posture_*` workflow tools sit beside them.
- Browser smoke (`app/e2e`) covers the new Scripts screen and tabs for the test accounts.

**Done when:** on staging, a joiner request whose after-script ran shows it under that person with its output, a held joiner can be released from the request page, the "A script failed" filter finds it, and Polaris answers "what scripts ran for <request>?".