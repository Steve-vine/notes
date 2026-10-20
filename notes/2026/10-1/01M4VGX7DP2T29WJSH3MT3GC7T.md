---
id: 01M4VGX7DP2T29WJSH3MT3GC7T
created: 2026-10-13T20:57:47.190755Z
updated: 2026-10-20T15:13:42.243698Z
type: task
title: 'The rest of "a rule is why": the badge on group lists, the joiner summary, reports and recertification, and the rule kept on the request'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 951
comments:
- id: 01M5CXZT8M3SZMVE0KE6TJ0PH1
  author: Steve Vine
  at: 2026-10-20T15:13:28.852558Z
  text: |-
    Landed as two PRs on this task: #1155 (main 90eec4b6, 14:52 UTC) and #1156 (main b9f66bde, 15:12 UTC), 2026-10-20.

    **What changed:**
    - **Group lists:** on a person's group list and a group's member list, a membership a rule gave reads **Rule** where a role-given one names its role. Hovering says which rule, and which role met its condition.
    - **Joiner summary:** a "Membership rules" block says where a rule withholds a group one of the chosen roles gives, and what a rule adds on top. With several joiners, it says which.
    - **Reports:** the Governed memberships report's Why gains "A membership rule gives it", and a new **Membership rule** column names the rule.
    - **Recertification:** on a group's review in the portal, a member who was given the group individually, where a rule reads it, carries a line before the reviewer flags them. It says what a rule would then give back or take away, and that the Membership rules card then puts it right through a request.
    - **Requests:** a change of access or a move keeps what the membership rules said it would add and take away, as the rules stood when it was raised. Its page shows that, not today's answer. Requests raised before this keep showing the live answer while they wait.
    - **The rule as a link:** wherever a rule's sentence is shown (badge, move form, a role's page, the joiner summary, a request), it links to the Membership rules card on Access ▸ Admin, for anyone who can open that card.

    **My calls:**
    - **COM-948's open point stays out of scope:** a recertification removal still does not give a group back. It has no request and no approver beyond the reviewer, so having it make further directory changes on a rule's account would grant access nobody approved. Instead the reviewer is warned beforehand, and the Membership rules card puts it right afterwards through an approved request.
    - **The recertification warning appears only for groups given individually.** Taking away a role's group is undone by the role, not a rule.
    - **Reports read the rule from the record of why each membership exists,** which the regular provenance pass fills in. A membership a rule has only just given reads "A business role grants it" until that pass runs. The screens work it out live, so they are right at once.
    - **The joiner summary also says what a rule adds,** not only what it withholds.
    - **The Rule badge is violet,** apart from Role (teal) and Exception (blue).

    **Checks:**
    - Integration tests for each part, in the rules suite, alongside the report-catalogue, dynamic-membership, catch-up, report execution and definitions, portal and directory-sync suites (all green locally).
    - Frontend tests for the badge, the joiner summary, the kept request effects, the portal warning and the mover rule link.
    - ruff, mypy, eslint, tsc -b, prettier, the OpenAPI drift check, and one Alembic head (0347, add-only).

    **CI:**
    - #1155: run 39440374124 took 17 min, with backend-test at 16.4. The frontend job ran on compass-runners (15.1 min).
    - #1156: run 39443918842 took 14 min, with backend-test at 13.6. The frontend job ran on compass-runners (12.9 min).
assignee: steve
label:
- follow_up
priority: low
task_status: review
---
Follow-up to COM-950, which shipped the places that matter first (a person's details, the move form, the change-access form and its pending request, a role's page). These were in COM-950's text and were not built. Logged 2026-10-13 so they are not lost; not started.

## What people would see

- **On a person's group list and on a group's member list:** a membership a rule gave says "Rule" where a role-given one names its role. Today those lists show the role that met the rule's condition, and the person's details say "given by a rule" under their roles.
- **On the joiner form's summary:** where a rule withholds a group one of the chosen roles would give, a line says so, so nobody raising it expects that group.
- **In reports and recertification:** where a membership's reason is shown or exported, "Rule" is one of the reasons, with the rule as a sentence. A reviewer about to remove an individually given group is told what a rule will then give back or take away.
- **On a request's page:** the rule's sentence kept as it was when the request was raised. Today a pending request shows what the rules as they stand now would do, and a request that has run keeps what happened in its outcome line; a rule changed in between is not reflected.
- **The rule as a link** to the Membership rules card wherever it is named, for somebody who can open that card.

## Also open from COM-948

- **A removal made by a recertification does not give a group back.** It leaves the person out of line with the rules, which the Membership rules card shows and puts right through a request. The task had asked for it in the same step; it was left because a recertification removal has no request and no approver beyond the reviewer.

## Notes (technical)

- The reasons are derivable from `core.membership_rules.evaluate` (COM-948) and are already served for one person by `GET /membership-rules/person`. The badge needs the same on the membership shapes that carry provenance (`MembershipProvenanceBadge`, the directory user and group detail).
- Storing the sentence on the request is the ADR 0032 §4 snapshot pattern: a column on the subject written at raise time.
- Reports: check `reportHooks.ts` and the report column lists for a closed set of reasons.