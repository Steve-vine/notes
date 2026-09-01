---
id: 01M1E0EB414T3YENFAJZPK4856
created: 2026-09-01T08:12:49.153981Z
updated: 2026-09-01T12:43:00.877052Z
type: task
title: an empty list says which company it is empty for
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 555
sprint: sz42uhw
comments:
- id: 01M1E30V85KG4CSZ38EXEVPA22
  author: Steve Vine
  at: 2026-09-01T08:57:52.644845Z
  text: |-
    Done — PR #564, merged to main (e6b62e5), CI green.

    New `CompanyEmptyState`: the title names the company — "No access requests for Moneypenny" — and where there is another active company, the offer to look in it sits right there in the empty state. One button each while that stays readable, a searchable picker once it would not.

    Swept across the company-scoped screens rather than fixing only the one: access requests, business roles, coverage proposals, recertification schedules and instances, expedited validation, gaps and the assessment queue. The last two had no empty state at all — they rendered an empty table with headers.

    Two of them are narrowed by filters, where "empty" has a second meaning, so they say when it is the filters rather than the company. The assessment queue also distinguishes an empty **control library**, which is global rather than company-scoped and must not claim otherwise.

    The switcher is unchanged — it was doing its job; this is about the moment the answer is empty.

    Four tests on the component: the company is named; nothing extra is offered when it is the only one; the other company is offered and switching re-reads the title; the picker replaces the buttons once there are many.
assignee: steve
company: null
label:
- bug
priority: high
task_status: done
---
Found by Steve on staging, 2026-09-01: a request raised on one account was invisible on a second account — no requests at all, new or completed. Nothing was lost and nothing was hidden by permissions; the two sessions were simply looking at **different companies**.

Confirmed in the staging logs: over three hours the requests list was fetched for two different companies — 63 calls for one, 15 for the other — from the two sessions.

**The screen gave no way to work that out.** It said "No access requests — raise a joiner, mover, leaver or group-create change to get started", which reads as *there are none*, not as *there are none in this company*. Everything on Access Control is company-scoped, and the only thing on the page that says which company you are in is a dropdown at the top of the shell that nobody is looking at when they are staring at an empty table.

An empty screen that means "wrong company" and an empty screen that means "no data yet" have to look different, because the first one has an action attached and the second does not.

## What changes

- Company-scoped lists name the company in their empty state: "No access requests for **Moneypenny**", with the invitation to raise one underneath — and, where there is more than one active company, a way to change company from the empty state itself rather than hunting for the switcher.
- Sweep the company-scoped screens rather than fixing only this one: Access Control (requests, business roles, coverage, recertifications), and the assessment and gap screens, all of which show the same bare "No X" when the answer is "not in this one".
- Not a change to the switcher, which is doing its job — this is about the moment the answer is empty, which is when the question "empty *of what*?" actually arises.

## Related

COM-556 covers the other half: which company a fresh session lands in, and why the second account started somewhere different in the first place.
