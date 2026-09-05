---
id: 01M1RYW8MF7APNHYA570EGD48Q
created: 2026-09-05T14:17:06.959895Z
updated: 2026-09-05T14:31:25.050902Z
type: task
title: tenant-wide work vanishes from Actions as soon as you scope it to a company
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 561
sprint: s2fcksg
assignee: steve
label:
- bug
priority: high
task_status: backlog
---
Found by Steve on staging, 2026-09-05. Reported as: open actions for a company that was permanently deleted.

**It is not a deleted company, and nothing is orphaned.** Verified against the staging database: two companies exist, both active (Moneypenny, Test Company), and every foreign key to `companies` is validated — a row pointing at a company that no longer exists is impossible.

## What is actually happening

**54 open actions belong to no company at all**, and the Actions queue shows them only when **This company only** is off. Scope to either company and they disappear. That is the surplus Steve was reading as a phantom company.

They are out-of-band directory changes awaiting an explanation, and they are company-less **by design** — an account or group created in the tenant belongs to no company's matrix:

| kind | open |
|---|---|
| group_created | 27 |
| user_created | 17 |
| unprocessed_leaver | 6 |
| directory_role_gained / lost | 4 |

Test Company has 10 more that do carry a company. The other 672 rows in the table are the `for_information` lane and correctly raise nothing.

Worth noticing separately: the oldest of these is from **18 August** and none has been validated. They are past their SLA and nobody has been looking at them, which is the practical cost of the bug — on staging, at least, the queue is where they would have been seen.

## The fix

**The Access validation screen already gets this right, and says why.** Its listing returns "the company's items plus the tenant-wide ones (creations carry no company — every company's validators should see them)". The Actions queue filters on strict equality instead, so the same rows drop out the moment a company is selected. Two screens, one decision, taken twice.

- The queue's `company` filter admits rows with no company, matching the validation list: `company_id == company OR company_id IS NULL`.
- Those rows then have to *read* as tenant-wide rather than as a blank company — COM-560.
- **A call to make:** the same change also pulls library content reviews into every company-scoped view, since they carry no company either. I would take that — global playbook work is everybody's, which is the same argument the validation screen makes — but it does widen what a company-scoped queue means, so it is worth a deliberate yes rather than a side effect. (Zero content reviews are due on staging today, so nothing will visibly change either way for now.)

## Related

- COM-560 — an action says which company it is for. Together these are the whole fix: this one stops the rows vanishing, that one makes them legible.
- ADR 0061 §6 — the informational lane that deliberately raises nothing.
