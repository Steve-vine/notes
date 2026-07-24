---
id: 01KXP6NB17SE3AP0C0GB6ZT9ZP
created: 2026-07-16T19:32:38.055222668Z
updated: 2026-07-24T12:32:39.857188Z
type: task
title: Close the loop — post-execution verify &amp; auto-resolve
project: 01KX671DATY39VW6GWK3M2T3DN
number: 100
sprint: s0v93ii
blocked_by:
- 01KXP53E6Q2YT2T5SV301RJ9VE
- 01KXP53N5TGC65M25J9KYC4KAS
assignee: steve
label: null
priority: high
task_status: done
---
The capstone that makes "Issue Loop" a *closed* loop: after a remediation executes, automatically **verify** it worked and **resolve** the issue if the condition has cleared — rather than waiting for the next scheduled sync to drop the finding. This is the execute → verify → (resolve | re-open the loop) closure from the original initiative.

**The gap today:** execution never touches the originating issue. `docs/briefs/architecture-overview.md` claims the remediation loop ends with "result and audit recorded, **Issue updated**" — but `run_execution` (`tasks/actions/execute.py:47-126`) only sets the `ProposedChange` to executed/failed; the issue auto-resolves *only* later, if the next sync stops reporting the finding (promotion auto-resolve). No re-check is triggered by execution.

**Behaviour:**
- On successful execution (`mark_executed`), automatically trigger the per-issue **analyse/verify** step (ISE-94) — chained after, or alongside, the post-execution follow-up (ISE-95).
- On the verify verdict:
  - `appears_resolved` → transition the issue to `resolved` (via the same governed path as `PATCH /issues/{id}/status`, honouring `VALID_TRANSITIONS`, setting `resolved_at`), attributed to a distinct audit actor (e.g. `VERIFIER_ACTOR`, mirroring `EXECUTOR_ACTOR`/`POLICY_ACTOR`) so the timeline shows *who* resolved it and *why*.
  - `still_present` / `changed` → **do not** resolve; post a timeline event that the fix didn't clear the condition and the loop is still open (operator/chat can propose again — the "not a strict loop, jump about" behaviour of ISE-88).
- **Auto-resolve is a policy decision, not a default** — record it in the ADR (ISE-89): is post-execution auto-resolve on by default, opt-in per integration, or always recommend-only pending a human click? Default to the safest option and make it explicit. Do not silently close issues.
- Idempotent, takes IDs (Celery rules); every transition audited.

Blocked by the verify mechanism (ISE-94) and the post-execution step it chains from (ISE-95); its auto-resolve policy is decided in the ADR (ISE-89). Label: feature.