---
id: 01M7551VHS9DCQFY33HGRR03G7
created: 2026-11-11T11:14:23.929033Z
updated: 2026-11-11T17:31:38.527699Z
type: task
title: 'Parts on a one-company account: the Parts tab lists them, each comes in for the account''s company, and any can be set to Don''t read'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1724
sprint: sj4f1kj
comments:
- id: 01M75BMDKTZNG1JXD0KY2EP92D
  author: Steve Vine
  at: 2026-11-11T13:09:23.705865Z
  text: |-
    Built and merged to main (PR #1720, 2026-11-11). Independent: no migration, no API change. Goes to staging with the sprint.

    What changed:
    - If a feed names its parts, the integration's Parts tab now lists them on any account.
    - One-company account:
      - Each part comes in for the account's company as soon as it's found. There's no Not assigned step, so the integration never needs attention for it.
      - The only choices are that company or Don't read. Compass refuses any other company.
    - Don't read adds nothing from that part and closes nothing on it, even for a feed that closes by "missing". Setting it back to read brings it in at the next run.
    - Ticking "Serves several companies" later: listed parts keep their company, and new ones start Not assigned, as before.
    - A several-companies account works exactly as it did.

    Tests: a fake service on a one-company account (every part read for the account's company, another company refused, Don't read brings nothing in and closes nothing, reading again brings it back, ticking several companies later); two new Parts tab screen tests.

    Watch on staging: each part's records are now kept per part on a one-company account. Nessus's Findings feed has already run once without parts, so its first run after the deploy could bring the same findings in again under each scan. I'll check that after deploying and tidy up. Then Steve can set the scans he doesn't want to Don't read.
- id: 01M75EJ1Y9DGRRTG3EJDQXJ3M1
  author: Steve Vine
  at: 2026-11-11T14:00:31.945248Z
  text: |-
    Pre-UAT on staging (bb59b9a2), 2026-11-11: **Couldn't check yet.** Nessus's Findings feed already names each scan as a part. It's waiting for approval because of COM-1727's mapping change, so no run has listed its parts under the new code.

    Steve: approve Nessus ▸ Feeds ▸ Findings. After its run, the Parts tab lists the scans, each for Test Company, and you can set the ones you don't want to Don't read.

    Found while checking: a host scanned by two scans would flap. One scan's run closed what only the other found on that host. That's 3 of Nessus's 212 hosts on staging. New task COM-1729 in this sprint fixes it (PR #1725). I'll deploy it before you approve the feed.

    The duplicates I feared earlier don't happen: existing findings are matched by host, so they move to the scan rather than being added again.
assignee: steve
label:
- feature
priority: medium
task_status: done
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