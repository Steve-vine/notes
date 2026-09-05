---
id: 01M1RYWR433DT9DWXHEXEHQH3D
created: 2026-09-05T14:17:22.819676Z
updated: 2026-09-05T15:32:14.50098Z
type: task
title: an archived company's work leaves the queue
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 562
sprint: s2fcksg
comments:
- id: 01M1RZQQ6NGRAV5DKC93DWK8AD
  author: Steve Vine
  at: 2026-09-05T14:32:06.612791Z
  text: 'Checked staging while diagnosing COM-561: both companies (Moneypenny, Test Company) are active — there are no archived companies today, so this is preventative rather than something currently visible. The inconsistency with the mail is real either way, and it is cheap: `archived_company_ids` already exists.'
assignee: steve
label:
- improvement
priority: medium
task_status: todo
---
Found alongside COM-560, 2026-09-05.

Archiving a company freezes it: nothing about it can change, and nothing chases anybody about it (COM-505). Two places did not get the message consistently.

- The **company switcher hides archived companies** — they are not in the list you can pick from.
- The **Actions queue still lists their work**, and still counts it overdue and colours it red.

So an archived company's gaps, plans and reviews sit in the all-companies queue as work you cannot act on, for a company you cannot select, with nothing on the row to say which one it is. That is half of why the total does not reconcile (COM-561 is the other half).

The nightly action mail already gets this right — it filters archived companies out deliberately, on the actions rather than the recipients, so somebody with work in two companies still hears about the live one.

## The decision

Steve's call, 2026-09-05: **hide it.** Archived work leaves the queue entirely, matching the mail.

This reverses a stated intention: the mail's own comment says the in-app queue is *deliberately* left alone, on the grounds that reading an archived company is the point of preserving it. That reasoning holds for the company's own screens, and they are untouched — go to the archived company and its gaps, assessments and reviews are all still there to read. What it does not justify is a shared cross-company work list carrying rows nobody is allowed to close.

## What changes

- The queue drops actions belonging to an archived company, both scoped and unscoped. `archived_company_ids` already exists and is what the mail uses — apply the same filter in the actions request path.
- Rows with no company (library content reviews) are unaffected.
- Restoring the company brings its work straight back, with no resume plumbing — the freeze is a status check, never a stored flag.

## Related

- COM-560 — an action says which company it is for.
- COM-561 — the actions total counts work for companies that are not in the list.
- COM-505 / COM-506 — archive freezes, restore unfreezes.
