---
id: 01M68R968RPEDQC4RHDZJDMMY5
created: 2026-10-31T10:32:28.696123Z
updated: 2026-10-31T10:32:32.160515Z
type: task
title: Audits joins the portal — someone asked for evidence, or given a finding's corrective action, sees "My audit requests" and answers it there
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1493
sprint: snvd637
assignee: steve
label:
- feature
priority: medium
task_status: todo
---
Sprint 80, Update user portal. Steve chose this on 2026-10-31 in answer to "which other modules should the portal have?".

## Why

An auditor's request list ("send us last quarter's access review") is mostly answered by ordinary staff, and so are the corrective actions on findings. A portal-only owner gets these as actions with nothing to open.

## What people see

- An **Audits** menu item, shown to anyone who owns an audit request or a finding's corrective action. Nobody else sees it.
- The page is **My audit requests**. It has two lists:
  - **Requests**: the audit, the request wording, its due date and status;
  - **Corrective actions**: the finding, what's to be done, its due date and status.
- Opening a request shows what the auditor asked and any comments. The owner can:
  - **provide evidence**: upload a file, or pick evidence from the register that they're allowed to see;
  - **comment**, which goes to the audit lead and, if the request is shared with the auditor, to the auditor;
  - **mark it ready** for the audit lead to check.
- Opening a corrective action shows the finding. The owner can **record progress** and **mark it done**, with a note and evidence.
- The audit lead still accepts the evidence and closes the finding, internally.
- Their My actions rows for these open this page.

## Notes (technical)

- Add ownership-scoped `/api/v1/portal/audits/...` reads and the writes above. Add each write route to the allowlist test in `tests/test_portal.py`.
- Reuse the Audit service code (ADR 0133, sprint 97) for providing evidence and comments, so the auditor portal and the activity log behave the same.
- In `links.py`, rewrite `request_link` and `finding_link` to the portal pages.
- The evidence picker offers only what the reader can already see. The portal has no Evidence register to browse.

**Chain:** on the chain (new portal API).

**Done when:** on staging, a request on an E2E Test Company audit is given to E2E Asset Owner. Signed in as them, Audits lists it, they can upload a file to it and mark it ready, and the audit lead sees the evidence internally.