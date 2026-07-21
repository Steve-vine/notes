---
id: 01KXPFEYP33PK49A515V2MKVVK
created: 2026-07-16T22:06:25.987589859Z
updated: 2026-07-21T19:51:48.984719Z
type: task
title: 'Bug: budget-exceeded async run spins the progress indicator forever'
project: 01KX671DATY39VW6GWK3M2T3DN
number: 102
order: 1.0
sprint: s0v93ii
assignee: steve
label: null
priority: high
task_status: done
---
**Found in smoke testing** the redesigned Issues screen (ISE-96/97/98/101).

**Symptom:** clicking **Analyse** (and equally Diagnose / Propose) when the AI daily-spend ceiling is exceeded leaves the "Re-analysing…" progress indicator (ISE-101) spinning forever. The budget-exceeded outcome never makes it back to the Issues screen.

**Root cause:** an async button-triggered agent (`analyse-issue` / `diagnose` / `propose-remediation`) that hits the ceiling produces an `AgentRun` with `status="budget_exceeded"` and attaches **nothing** to the issue — the `_attach_*` helpers (`ai/analyse_issue.py`, `ai/diagnosis.py`, `ai/remediation.py`) all `return` early on a non-succeeded run. Because `AgentRun` has **no `issue_id`**, the per-issue timeline (ISE-92, `_linked_run_ids` in `api/v1/issues.py`) only surfaces runs linked via `issue.agent_run_id` or `issue.evidence.{diagnosis,remediation,reanalysis}.agent_run_id` — so a failed / budget-exceeded run is **never surfaced to the issue timeline**. Result: (1) the operator never learns why nothing happened, and (2) the ISE-101 pending placeholder — which clears only when a matching `agent_run` timeline event appears — never clears. It spins until its 90s timeout, which then misleadingly reads *"Still running — see Agent runs"* for a run that actually terminated instantly.

**Note the chat path is fine:** a budget-exceeded *streamed* turn emits an in-band `error` event the `LiveBubble` shows. This bug is specific to the **async button-triggered** agents.

**Fix direction (surface terminal failures back to the issue):**
- **Backend (the real fix):** make failed / `budget_exceeded` per-issue runs discoverable by the timeline. Either (a) attach a minimal failure record to `issue.evidence` on non-succeeded runs (e.g. `evidence.reanalysis = {status, agent_run_id, error}` with no verdict) so `_linked_run_ids` picks it up; or (b, cleaner/general) add a nullable `issue_id` FK to `AgentRun`, set for the issue-scoped task types, and have the timeline surface **all** runs linked to the issue regardless of status. Then the feed renders a `budget_exceeded`/`failed` agent-run bubble ("Re-analysis: daily AI budget exceeded"), which also makes the ISE-101 placeholder clear on the next 10s poll.
- **Frontend (ISE-101 follow-up):** the placeholder already clears on any surfaced `agent_run` of the matching task type, so the backend fix resolves the spin. Also soften/relabel the 90s timeout copy — "Still running" is wrong for a run that already failed; make it an honest unknown-terminal state.
- Covers `budget_exceeded` **and** provider-`failed` async runs (same mechanism).

Relates to ISE-92 (timeline surfacing), ISE-94 (the analyse run), ISE-101 (the placeholder). Label: bug.