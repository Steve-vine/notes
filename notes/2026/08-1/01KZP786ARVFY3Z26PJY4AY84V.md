---
id: 01KZP786ARVFY3Z26PJY4AY84V
created: 2026-08-10T16:14:19.480741Z
updated: 2026-08-11T18:38:43.774519Z
type: task
title: Resolving an incident records no resolution — there is nowhere to say what was done
project: 01KX671DATY39VW6GWK3M2T3DN
number: 642
sprint: s1rgnyx
comments:
- id: 01KZPY1HHEJSVPVBF6FC24P9RP
  author: Steve Vine
  at: 2026-08-10T22:52:38.830705Z
  text: |-
    Built and merged to main 2026-08-10 — `5a9a3ae` (PR #588), migration **0125**.

    `issue.resolution_note`, required on `resolved` and `dismissed`. Enforced in `apply_status_change` rather than the schema, so no surface can route around it — the API, the MCP action tool and the issue-chat ticket tool all share that path. `closed` asks for nothing: it is quiet archival of a decision already explained, and asking twice for one answer is how a required field becomes a field people paste "ok" into.

    Carried into Recall's priors, so "how did we fix this last time" has an answer written by whoever fixed it.

    **Two things the build surfaced that the write-up had not anticipated:**

    1. **The AI could no longer close anything.** `update_incident_status` (issue-chat's ticket tool) calls the same service path, so requiring a note made it structurally unable to resolve or dismiss — it could acknowledge and reassign and nothing else. A worse failure than the one being fixed, and CI caught it. The tool now takes a `note`, and both its docstring and the issue-chat prompt tell it to take the note FROM the conversation and to **ask rather than invent one**. A required field an agent fills with plausible filler would turn every Recall entry into confident noise — exactly the failure this task exists to end.

    2. **A merged child reached a terminal state with no note.** The cascade sets a child's status directly (ADR 0035 §5 makes the master the single source of truth for "fixed"), bypassing the check — so children would have surfaced in Recall as more priors teaching nothing. The master's note now carries to them.

    Seven existing test files updated: they resolved incidents without a note, which is precisely the hole being closed.

    **ISE-646 shipped in the same modal** — see its own comment. One piece of UI, two tasks, because they are the same moment in the operator's hands.
assignee: steve
label:
- improvement
priority: high
task_status: done
---
Found 2026-08-10 walking the Service Desk triage path. ADR 0056 defines the responder rung as "run desk-executable playbooks, resolve afterwards, **record notes**". There is no note.

- No `IssueNote` (or comment) model exists — `models.py` has nothing of the kind.
- `IssueStatusUpdate` (`api/v1/schemas.py:431`) carries **one field**: `status`. No reason, no summary, no free text.
- The only narrative surface on an incident is the AI conversation, which is operator-only (`issues.py:1317`) and is a question to an assistant, not a record by a human.

So the terminal step of the workflow — an operator closing an incident — captures nothing about *how it was resolved*. The timeline shows the status changed and who changed it. Whether the host came back on its own, someone restarted a service, or it was closed because it was noise: identical rows.

**Why this matters beyond tidiness:**

- **The next operator repeats the work.** The Recall panel surfaces prior similar incidents specifically so the last resolution informs this one — and every prior incident resolves to "status changed to resolved", which teaches nothing.
- **It starves the learning loop.** Playbook efficacy and `compute_tier` (`playbooks.py:107`) learn from *runs*. A human fix — the overwhelming majority of resolutions today, since nothing is desk-executable ([ISE-640]) — leaves no trace to learn from, so no playbook can ever earn its track record from real work.
- **Dismissal has the same hole, and it is worse.** Dismissing is sticky (promotion.py never overrides it): a signal muted by a human decision, permanently, with no recorded reason. Compare Ignore, Silence and observation suppression, all of which *require* a reason (ISE-557's discipline). Closing an incident is the biggest of those decisions and the only one that asks for nothing.

**Scope**
- A resolution note on the status change: required on `resolved` and `dismissed`, optional elsewhere; rendered on the timeline and carried into Recall so the next operator reads what worked.
- Decide whether free-form notes on an open incident are in scope too (the desk narrating as it works) or whether the resolution note alone is enough. Prefer the smaller thing first.
- Feed the note into the learning path: a resolution that names a playbook — or names a procedure worth becoming one — is exactly the material `pending_learnings` exists to catch.

**Acceptance**: an incident cannot be resolved or dismissed without saying why; the reason appears on the timeline and in Recall's prior-incident summaries.