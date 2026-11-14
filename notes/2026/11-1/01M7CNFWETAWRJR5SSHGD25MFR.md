---
id: 01M7CNFWETAWRJR5SSHGD25MFR
created: 2026-11-14T09:16:21.850655Z
updated: 2026-11-14T10:26:07.194176Z
type: task
title: The Checks page's Review tab count goes up as Polaris's proposals arrive, without refreshing the page
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1812
sprint: spsp226
assignee: steve
label:
- bug
priority: medium
task_status: active
---
## What happened

On 2026-11-14, while testing Integrations and Checks, Steve asked Polaris to design checks. Polaris worked out the options and added proposals to the Review tab, but the number on the tab ("Review (n)") stayed where it was. He had to refresh the page to see that anything had arrived.

COM-1794 said Review "refreshes as proposals arrive". The list does, but the count on the tab doesn't.

## What people see

- While Polaris is designing checks for this company, the Review tab's count goes up as each proposal lands. This applies whether the work was started on screen (one control, or a batch) or by asking Polaris in chat. Steve doesn't need to be on the Review tab for it to happen.
- When a proposal is approved or discarded, the count goes down at once, as it does today.
- When the work finishes, the count is final without a refresh. The Overview's "waiting for review" figure, if one is shown, matches it.

## Likely cause (for the builder)

`ChecksPage.tsx` takes the tab count from `useReviewQueue(companyId, null)`. The Review tab's list uses the same hook keyed by batch, and that query is the one refreshed while a batch runs. The count's query (batch = null) is never refetched or invalidated while a job is running. It should refresh on the same cadence while any design/revalidate/recreate job is running for the company, including one started from Polaris chat (MCP), and once more when the job ends.

## Done when

- With a design batch, or a chat-started design, running for a company and the Checks page open on any tab, the Review count rises as proposals arrive, with no refresh.
- The count settles to the final number when the job ends.
- A vitest covers the count updating while a job is running.

**Independent** (front end only, no migration or API change), unless the count needs a job signal the API doesn't give. If so, it joins the end of the chain.