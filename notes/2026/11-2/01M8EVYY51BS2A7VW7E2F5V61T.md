---
id: 01M8EVYY51BS2A7VW7E2F5V61T
created: 2026-11-27T16:03:37.249403Z
updated: 2026-11-28T00:24:04.958861Z
type: task
title: An access request shows the scripts run for each person, before and after, with their outcome and outputs; Polaris can say what ran
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2199
sprint: snt3b17
blocked_by:
- 01M8EVYHS49E0CSHCNPAR0KVVP
comments:
- id: 01M8FKJADDRAG3C1GF3VY461K6
  author: Steve Vine
  at: 2026-11-27T22:56:09.644965Z
  text: |-
    Built: PR #2207, merged to main (not on staging yet; it goes with the sprint deploy).

    What's there:
    - **On an access request, each person has a Scripts section**, shown only when a script ran for them:
      - **Before their changes** and **After their changes**: each script with its outcome, what it handed back ("CrmUserId: 4512"), when it ran, and links to the script run and the workflow run.
      - **A held person** reads "Waiting on a script", with the reason. Script Managers get **Retry the script**. **Carry on without it…** opens the workflow run, where anyone allowed (approvers or Script Managers) can carry on, giving a reason.
    - **The requests list** has a filter chip, **A script failed** (shown only when a request has one), and an "A script failed" pill on the row. It counts any failure that hasn't been retried or dealt with, and anyone held by a failed before-script.
    - **A person's view** (Access Control ▸ People) has **Scripts run for them**: each script, before or after, the request it was for, when, and what it handed back. That answers "when was Ada's CRM account made, and what ID did it get?".
    - **Polaris** (read only) now says, for each person on a request, which scripts ran, when, what they handed back, and any hold. It also has three new tools: list scripts, read a script (its inputs, outputs, integration and published text), and list a script's runs (failed ones only, if asked).

    For you to look at:
    - **Evidence export**: Compass has no per-request evidence export today. A script's runs export as a CSV from its Runs tab, naming who each run was for. Say if you want an export of the request itself.
- id: 01M8FRKA2YNFDE0R9QAWF5X8DG
  author: Steve Vine
  at: 2026-11-28T00:24:04.958483Z
  text: |-
    Pre-UAT, staging 20261127-2345: **Couldn't check.**

    - No request on staging has script runs yet. That needs a joiner carried out with an after-joiner workflow enabled, which creates a real account in the staging tenant. So the request page's Scripts section, the "A script failed" filter and the person page's list are there but empty. The requests list correctly shows no "A script failed" chip.
    - Polaris's three new script tools: this session's connection to staging Polaris was opened before the deploy, so it doesn't offer them yet. Please ask Polaris "what scripts ran for <request>?" and "what does the Create CRM user script do?" once a joiner has run.

    All of this is proven end to end against a real SQL Server in the integration tests.
assignee: steve
label:
- feature
priority: medium
task_status: review
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