---
id: 01M4V9K2H4CY6ACFANN8D02XPZ
created: 2026-10-13T18:49:54.468141Z
updated: 2026-10-13T18:59:45.206198Z
type: task
title: Saving a membership rule brings the people it affects in line, through one request that somebody else approves
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 949
sprint: s192kdq
blocked_by:
- 01M4V9JGKFSFDV9YWJSSVRWFK3
assignee: steve
label:
- feature
priority: medium
task_status: todo
---
Part of the POC Tweaks sprint. Needs the evaluation task (COM-948). Without this, a rule only reaches people the next time their roles or individual grants change; this is what fixes the PAs who hold both licences today.

## What people see

- **Before a rule is saved, the card says what it will do:** how many people it changes, and for each group how many gain it and how many lose it. "37 people lose F3." The same for switching a rule on or off, changing it, and deleting it. A rule that changes nobody says so.
- **The count includes people who meet the condition through an individual grant**, not only through a role: somebody whose role gives F3 and who was given E3 as a one-off is one of the 37. *(Decided by Steve, 2026-10-13.)*
- **Saving asks to confirm when people are affected**, in the same words, and names the request it will raise.
- **The rule itself is saved straight away.** From that moment new joiners, movers and individual grants follow it.
- **The people already affected are changed by one request**, raised by whoever saved the rule: a membership change covering everybody the rule affects, each person listed with what they gain and lose and their own recorded outcome.
- **That request needs approval from somebody else**, like any other. Whoever wrote the rule cannot approve what it does. Nothing reaches the directory until it is approved.
- **Switching a rule off, or deleting it, is a change too**: the people it had been withholding F3 from get it back, through a request in the same way. So does changing a rule's groups.
- **The card says when people are out of line with the rules as they stand**, and how many, with a button to raise the change that puts them right. That happens when a rule's request was rejected or cancelled (the rule stays as saved and the people stay as they were), and when a membership nobody had explained is accepted on Validation and turns out to set a rule off.
- **Two rule changes before the first is approved** do not stack up two contradicting requests: the earlier one is withdrawn and replaced by one that reflects the rules as they now are.
- **Adds are made before removals** for each person.
- **A rule that brings in a privileged group** raises a request that needs an Access Admin's approval, as mapping that group to a role would.

## Notes (technical)

- **Follow ADR 0064 and `core/role_propagation.py`**, which already does this for a role edit: `plan` works out each holder's adds and removes, and the save raises one membership-change request. A rule change is the same shape with a different trigger; share the request-raising, do not copy it.
- **The plan is a difference of two evaluations** per person: COM-948's function with the rules as they were and as they will be, for everybody who holds a role or a standing exception in the company. Only memberships that are role-derived or rule-given before and not after are removed; a group that is itself a standing exception, or unexplained, is left (COM-946 point 4).
- **Preview endpoint**: `POST /api/v1/membership-rules/preview` taking the rule as it would be saved (or an id and "delete" / "disable"), returning counts per group and the number of people. It must not write.
- **Out of line is derived, not stored**: the plan for "the rules as they are now" against what people actually have is non-empty. One endpoint for the count, and the "raise it" button posts the same plan as a request.
- **Size.** A rule over a base role can touch most of the company. The request path already carries a role edit with hundreds of holders; check the execution task's batching and the request page with that many subjects before relying on it.
- **Replacing an open request**: find the open rule-raised request for the company by a marker on the request (a `membership_rule_change` origin, or the kind's existing origin field if it has one), withdraw it with a reason, raise the new one.
- **Remove the "rules are not applied yet" line** the card task left under the card.
- **Tests.** Integration: enabling the E3 rule raises one request listing exactly the people who have E3 by role or individually and F3 by role; approving it removes F3 from them and nobody else; the maker cannot approve it; disabling raises the reverse; a second change replaces the open request; a rejected request leaves the rule saved and the out-of-line count non-zero, and the button raises it again; an unexplained E3 accepted on Validation makes its holder out of line; an F3 held as a standing exception is left alone.

**Done when:** on staging, saving "If in group E3 then drop group F3" shows how many people it changes, raises one request, and once a second person approves it those people are no longer in the F3 group and still are in E3.