---
id: 01M023P2CKZPBBVQBQ440XETWY
created: 2026-08-15T07:02:53.075101Z
updated: 2026-08-15T08:26:52.251918Z
type: task
title: A playbook cannot be deleted — there is no endpoint at all
project: 01KX671DATY39VW6GWK3M2T3DN
number: 724
sprint: sevhjex
comments:
- id: 01M027YKMJVWVQF9ZJ20KXJ25T
  author: Steve Vine
  at: 2026-08-15T08:17:27.186146Z
  text: |-
    Built — PR #673, ADR 0102, migration 0138. In CI.

    **Decision: archive, not destroy** — as recommended. ADR 0102 records it and the reasoning, which is stronger than the task body suggested: four other records explain themselves by *naming* a playbook, and a hard delete leaves all four pointing at nothing — the resolution note a concluding playbook composed (displayed since ISE-704), the append-only audit history of its runs, `PlaybookFeedback` verdicts, and `issue_suggestion_dismissal` rows whose `target_id` is deliberately not an FK.

    **All three rules from the scope are in:**

    - **Retract first**, as its own audited act (`playbook_retracted_desk` then `playbook_archived`). It comes back **advisory** on restore — restoring is not a second engineer's approval.
    - **Refuse while a run is in flight.** Two *durable* markers: an incident parked `awaiting_validation` on this playbook (ISE-712's up-to-half-hour wait), and an undecided change this playbook's publish pre-approved. Worth knowing: the seconds-long synchronous stretch of a run has **no durable marker at all** — an `AgentRun` carries no playbook id — so it is not covered. Documented in the code rather than assumed away; it is bounded by `run_bounds.wall_clock_seconds` and costs an escalation, not a wrong action.
    - **Hard delete gated on never-referenced**, via `?purge=true`. Checked at delete time against every referencing table rather than trusted to FKs, since the dismissal table has none. **Refused rather than silently downgraded** to an archive — delete and archive are different requests.

    **The part that needed the most care was coverage.** The exclusion filter lives in `match_playbooks` (the single matching seam), but four other read paths answer "what playbooks exist" and each needed it: the API list, the MCP library scan, Assist's by-name lookup, and `learning.propose_learning`'s already-covered check. That last one is the one I would have missed — an archived playbook must **not** count as covering a kind, or archiving a playbook silently suppresses the learning nudge for exactly the kind that now needs a new one.

    **UI:** Archive / Restore per playbook, an **Archived** switch showing retired ones *instead of* the live list (mixing them puts dead procedures in the list you scan when deciding what to publish), an archived badge and a banner naming who archived it. A refusal is surfaced, not swallowed — the in-flight reason is the only way an operator would learn a run was live.

    Verified: 26 integration tests in `test_playbooks.py` (4 new), 29 migration tests including zero-to-head, ruff/mypy clean, full frontend suite.

    One self-inflicted CI failure worth noting: `backend-lint` went red on a mypy error in the new tests — I had run mypy before appending them. Fixed in a follow-up commit on the same branch.
assignee: steve
label:
- feature
priority: medium
task_status: review
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