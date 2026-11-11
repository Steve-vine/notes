---
id: 01M7551VHS9DCQFY33HGRR03G7
created: 2026-11-11T11:14:23.929033Z
updated: 2026-11-11T11:14:28.185221Z
type: task
title: 'Parts on a one-company account: the Parts tab lists them, each comes in for the account''s company, and any can be set to Don''t read'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1724
sprint: sj4f1kj
assignee: steve
label:
- feature
priority: medium
task_status: todo
---
Asked by Steve on 2026-11-11 while setting up Nessus as configuration (COM-1714): he wants to leave some scans out without the account serving several companies.

Today a feed's parts (ADR 0148 §3, COM-1708) only apply when the account is ticked "Serves several companies". On any other account, every item comes in for the account's company, and there's no way to leave a part out.

**Chain:** independent (no migration; the parts list and its Don't read already exist)

## What the person sees
- **Parts on any account.** If a feed names its parts (Nessus's Findings: each scan), the integration's Parts tab lists them, whether or not the account serves several companies.
- **One-company account:** a new part comes in straight away for the account's company. There's no Not assigned step, because there's only one company it could go to. Its row shows that company, and the only choice is to read it or **Don't read**.
- **Don't read** leaves a part out: nothing from it is added, and nothing on it closes (closing by "missing" only ever closes within a part that was read). Setting it back to read brings it in at the next run.
- **Ticking "Serves several companies" later** brings the company picker back. Parts already listed keep the company they had. New ones start Not assigned, as today.
- Changing a part still needs Manage integrations. No service name in code (COM-1696).

## Done when
- Tested with a fake service on a one-company account: every part listed and read for the account's company, one set to Don't read brings nothing in and closes nothing, and setting it back brings it in again.
- A several-companies account behaves exactly as today.
- On staging, Nessus's 69 scans list on its Parts tab after the first run, and Steve can set the ones he doesn't want to Don't read.