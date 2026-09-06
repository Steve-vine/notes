---
id: 01M1VXPB84S8CT9V5J8C5VZAXD
created: 2026-09-06T17:54:07.748404Z
updated: 2026-09-06T18:18:10.821793Z
type: task
title: ADR 0068 — a suggestion is about Compass, not about a company
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 598
sprint: scx5myr
assignee: steve
label:
- brief
priority: medium
task_status: active
---
Everything else a user writes in Compass belongs to a company — an assessment, a gap, a risk, a decision record. A suggestion does not. "The Vendors table should remember my sort order" is true in Acme and true in Beta, and nobody should have to raise it twice or wonder which company they were in when they raised it.

So the suggestions table has **no `company_id`**, and switching company does not change what the list shows. That is a departure from ADR 0009's default and it needs writing down, because the next person to add a table will copy whichever neighbour they happen to open.

## Fix

- [ ] `decisions/0068-a-suggestion-is-about-compass-not-a-company.md`. Append-only; 0067 is the current highest.
- [ ] State the decision: suggestions are global. The list is identical in every company; the light bulb is in the app shell, not in a section.
- [ ] State what follows from it: no company filter on the endpoints, no company scoping in the query, and the record is therefore **not** company data — a company purge (`core/company_purge.py`) must not take suggestions with it.
- [ ] State the boundary: internal users only. The vendor portal has no light bulb and `/portal` gets no suggestions route. Vendor contacts and recertifiers are outside people; a channel for telling us what to build is not something we open to them by accident.
- [ ] State the two rules a permission cannot express, so the API task has them in writing: **the author may edit their own** whatever their role, and **only a manager may set a status or delete**.
- [ ] Note what was deliberately left out of the first cut — no notifications, no mail, nothing in the Actions queue (ADR 0055). An administrator finds suggestions by opening the list. Say why: the feature has to earn a place in anyone's inbox first.

## Related

- ADR 0009 — multiple companies, the default this departs from.
- ADR 0045 / 0067 — access control and "a role is a set of permissions"; the new `admin.manage_suggestions` tick lives in that catalogue.
- ADR 0055 — the actions queue and derived mail, deliberately not used here.
