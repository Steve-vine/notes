---
id: 01M023P2CKZPBBVQBQ440XETWY
created: 2026-08-15T07:02:53.075101Z
updated: 2026-08-15T07:14:45.704581Z
type: task
title: A playbook cannot be deleted — there is no endpoint at all
project: 01KX671DATY39VW6GWK3M2T3DN
number: 724
sprint: sevhjex
assignee: steve
label:
- feature
priority: medium
task_status: todo
tech: null
---
`playbooks_api.py` has no `@router.delete` of any kind. A playbook created by mistake, superseded, or authored while experimenting is permanent — it keeps matching incidents and keeps appearing in the Playbooks section forever. Reported 2026-08-15 while iterating on the Karpenter playbook.

**Decide delete vs archive first.** A playbook is referenced from several places, and a hard delete silently rewrites history in all of them:

- `PlaybookFeedback` rows — the advisory Helped / Didn't apply verdicts.
- `issue_suggestion_dismissal` with `kind='playbook'` (ISE-688), whose `target_id` is deliberately **not** an FK because it points at two tables — so nothing at the database level stops a dangling row.
- `audit_event` — append-only by trigger, so the record of a run stays whatever happens to the playbook, and a deleted-by-id row becomes unresolvable in the timeline.
- Efficacy history: the run happened and the incident says so in its resolution note (ISE-704 now displays it), naming a playbook that would no longer exist.

Recommend **archive, not destroy**: hidden from matching and from the lists, kept resolvable for anything that already references it. That matches the posture used everywhere else in ISE — retirement over deletion for entities (ADR 0039), retraction over removal for desk status, restore over discard for dismissals (ISE-688/689).

**Scope**
- Archive a playbook: excluded from `match_playbooks`, absent from the Playbooks list by default, still resolvable by id so old timelines and notes stay honest. A way back for one archived in error.
- **Retract before archiving.** A `desk_executable` — or, later, autonomous — playbook must lose that status first, deliberately and audited, rather than a delete quietly ending its ability to run. Same reasoning as ADR 0056's edit-retracts rule.
- Refuse (or wait) while a run is in flight; ISE-712's wait means a run can be live for half an hour.
- Audit it as its own action, with the actor.
- If a genuine hard delete is wanted for never-run drafts, gate it on `efficacy_total == 0`, no feedback, no dismissals and no runs — a playbook nothing has ever referenced can leave without a trace. Anything else archives.

Independent of the ISE-710..715 chain, but it will be felt immediately by anyone iterating on playbook authoring — which is now happening.