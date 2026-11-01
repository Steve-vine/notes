---
id: 01M6B6KZT5ED8QV1KWGZ173JFH
created: 2026-11-01T09:21:31.461593Z
updated: 2026-11-01T09:21:34.664365Z
type: task
title: The user portal's Actions shows everything that's mine, including work owned by a role I hold, the same as My actions in the internal app
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1503
sprint: scpaa6p
assignee: steve
label:
- improvement
priority: high
task_status: todo
---
Sprint 100, Actions. Raised by Steve on 1 Nov 2026, after seeing Vulnerability: 8 on the portal and 5,364 in the internal app.

## What happens today

The user portal's Actions page shows only work **named to you personally**. Work that's yours because of a role (a Compass role set as a type's default owner on Admin ▸ Actions, or a module's team) appears under My actions in the internal app, but never in the portal. That was a deliberate choice under ADR 0055 §5: the portal was built for people who hold no module. ADR 0137 has since made role ownership a normal way to own an action, so the two lists now disagree about what you owe.

## Behaviour

- The portal's Actions page lists exactly what **My actions** lists in the internal app for the same person: work named to you, work owned by a role you hold, and work owned by a team you're in. Same rows, same counts, same Type chips. Upcoming only works as it does today.
- Both lists come from one definition of "mine", so they can't drift apart again. Whatever the coming permissions work changes about teams and roles applies to both lists automatically.
- **Links (assumption, stated for Steve):** a row opens its portal page where the portal has one and this person can open it there. Otherwise it opens the record in the internal app, if the person can use it. A row whose record neither can open shows with no link, as today. Ownership through a role doesn't widen what the portal's own record pages show.
- A portal-only person (holding no internal role) sees exactly what they see today.
- Emails are unchanged: they already go to every owner, including role and team owners.

## Note on order

Until teams are reworked (the permissions follow-up), every Admin's portal will show the same unowned-vulnerability rows as the internal app: 5,364 for Steve on staging today, against 8 now.

**Chain:** on the chain (changes what the portal's actions API returns).

**Done when:**
- For the same person, the portal's Actions and the internal app's My actions list the same rows with the same counts, tested for a person-owned, a role-owned and a team-owned action.
- A portal-only person's list is unchanged.
- Each row's link opens a page that person can use, or there's no link.
- Pre-UAT in E2E Test Company: E2E Analyst holds E2E Incident Managers, the incident triage owner for E2E Test Company. Report an incident there and check it appears on E2E Analyst's portal Actions as well as their internal My actions, and that it opens. Rule it out afterwards.