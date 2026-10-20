---
id: 01M4VGX7DP2T29WJSH3MT3GC7T
created: 2026-10-13T20:57:47.190755Z
updated: 2026-10-20T14:06:36.779185Z
type: task
title: 'The rest of "a rule is why": the badge on group lists, the joiner summary, reports and recertification, and the rule kept on the request'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 951
assignee: steve
label:
- follow_up
priority: low
task_status: active
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