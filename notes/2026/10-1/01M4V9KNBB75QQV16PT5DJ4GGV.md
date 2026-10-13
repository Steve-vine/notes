---
id: 01M4V9KNBB75QQV16PT5DJ4GGV
created: 2026-10-13T18:50:13.739888Z
updated: 2026-10-13T19:00:14.526404Z
type: task
title: Wherever Compass says why somebody has a group, a membership rule is named — and a group a rule withholds is shown as withheld
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 950
sprint: s192kdq
blocked_by:
- 01M4V9JGKFSFDV9YWJSSVRWFK3
assignee: steve
label:
- improvement
priority: medium
task_status: todo
---
Part of the POC Tweaks sprint. Needs the evaluation task (COM-948). Last of the five. Once rules change what people get, a person holding the PA role and not in the F3 group looks like a mistake unless the screen says a rule did it. This is the explaining.

## What people see

- **On a person** (their groups, in the pop-up and on their page): a group a rule gave says so beside it, "Rule: if in group E3 then add …", where a role-given group names its role. Under their roles, a short line lists what a rule withholds and why: "F3 licence: withheld by a rule (they have E3 from PA Plus)", or "(they were given E3 individually)" when that is what set the rule off.
- **On the joiner form's summary** ("What this request creates"): no change to what is listed, but where a rule withholds a group one of the chosen roles would give, a line says so, so nobody raising it expects F3.
- **On the mover form's summary and Access changes**: a group that is going or arriving because of a rule, not because a role was added or dropped, says which rule. "F3 licence removed: rule, they will have E3."
- **When a group is given to one person individually**, or taken away: the request says, before it is raised, anything a rule adds or removes on account of it. Giving a PA the E3 group shows "F3 licence removed: rule" beside it; taking E3 away shows F3 coming back.
- **On a request's page**, for a joiner, mover or membership change: the same wording against each group, kept as it was when the request was raised, so a later change to the rule does not rewrite what an approver saw.
- **On a role's page**: beside a group that a rule withholds from some of its holders, "Withheld from 37 of 210 holders by a rule", and the rule. A role whose groups no rule touches looks as it does now.
- **On a group** (its pop-up, members list): a member who has it through a rule says so, like the role-given ones name their role.
- **The rule is a link** to the Membership rules card wherever it is named, for somebody who can open that card; plain text for anybody else.
- **In reports and recertification**: where a membership's reason is shown or exported, "Rule" is one of the reasons, with the rule as a sentence. A reviewer removing an individually given group in a recertification is told beforehand what a rule will give back or take away with it.

## Notes (technical)

- **The reasons come from COM-948's function and from the rule recorded on `governed_memberships`**; nothing here works out a rule's effect for itself. The function already says whether a role or an individual grant met the condition.
- **One component for "why this group"**: `MembershipProvenanceBadge` is what names a role or an exception today. It gains the rule case, and the withheld line is a sibling of it, so the person, group, role and request screens cannot word it four ways.
- **API.** The membership shapes that carry provenance (`schemas.py`, the directory user and group detail, mover preview, the membership-change preview, request subject changes) gain the rule's id and its sentence. Mover preview's `adds` and `removes` gain a reason per group. Regenerate `schema.d.ts`.
- **Snapshot on the request.** The rule's sentence is stored with the change on the request when it is raised (the pattern ADR 0032 §4 uses for prompts), not looked up when the page is read.
- **The role page's "withheld from N of M holders"** is one query over the holders and the evaluation; check it on a role with hundreds of holders.
- **Reports**: the Access report definitions that expose provenance get the new value; check `reportHooks.ts` and the report column lists for a closed set of reasons.
- **Tests.** Front end: the badge's rule case, the withheld line on a person in both wordings, the mover summary's wording, the individual-grant request's extra line, the role page count. Backend: the shapes above carry the rule; a request keeps its wording after the rule is changed and after it is deleted.

**Done when:** on staging, a PA who also holds PA Plus shows E3 from their role and "F3: withheld by a rule" on their page, the mover that put them there said so before it was raised, a PA given E3 individually reads the same with "given individually" as the reason, and the PA role's page says how many of its holders the rule withholds F3 from.