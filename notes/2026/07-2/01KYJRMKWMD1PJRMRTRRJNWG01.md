---
id: 01KYJRMKWMD1PJRMRTRRJNWG01
created: 2026-07-27T21:45:32.820354Z
updated: 2026-08-07T10:07:10.639124Z
type: task
title: 'End-to-end acceptance: the two-persona walkthrough (engineer authors, desk executes)'
project: 01KX671DATY39VW6GWK3M2T3DN
number: 349
order: 2.0
sprint: sf23rna
comments:
- id: 01KYJVFGQM3M7MQ5S7FF2V2AYJ
  author: Steve Vine
  at: 2026-07-27T22:35:11.476132Z
  text: 'Staging release done + automated acceptance slice green (2026-07-28). Staging = main + ISE-342..348 (commit 506b120), combined CI green, deployed, migration head 0067. Verified LIVE on the deployment over MCP with throwaway tokens (cleaned up after): (1) draft with envelope → advisory, plain-terms summary renders; (2) the AUTHOR''s publish refused with the SoD wording; (3) a second engineer publishes → desk_executable with publisher recorded; (4) a delete_resource envelope refused at publish naming T3 and ADR 0056 §1; (5) a responder-capped token lists update_incident_status + record_note but zero authoring/approve/merge tools; (6) retract flips back to advisory instantly. REMAINING FOR STEVE (needs a human + live model): set the run_playbook task type to a cheap model in Settings → AI (an unconfigured type refuses to run); then the two-persona walkthrough — engineer half in Claude (investigate → resolve → confirm_learning → tighten → second-engineer publish), desk half in a responder browser session (guided page → Run → watch verdict → resolve; plus the deliberately-failing-predicate escalation path). Known deviations to eyeball during the run: progress is timeline-poll not SSE; envelope token_budget is advisory (task-type cap enforces).'
assignee: steve
priority: medium
task_status: done
---
The sprint's exit test, on staging, both personas played for real.

**Engineer half (Claude Code):**
1. Investigate a real incident via `/mcp__ise__work-on`; resolve it with a committed diagnosis.
2. Confirm the learning proposal from Claude (ISE-348), tighten the prose, build the envelope (one T1 op, a real validation predicate).
3. Second engineer publishes; verify a solo-author publish attempt refuses; verify a T3 op refuses at envelope validation.

**Desk half (responder dev-login, browser):**
4. Open a matching incident — guided page shows the playbook with its plain-terms envelope summary; power tools absent.
5. Run it: watch interpretation stream, the change auto-approve with `pre_approved_via` provenance, validation go green, resolve one-click.
6. Failure path: a playbook with an unsatisfiable predicate escalates with a readable summary + engineer flag; nothing executed beyond the envelope.
7. Negative space: responder 403s on propose/merge/diagnose endpoints; retracting the playbook mid-run stops approvals; the spend panel shows the run under `run_playbook` within its cap.

Findings become fix tasks on the relevant feature branches (batch-testing rules). Done = Steve signs off that a Service Desk colleague could genuinely work the happy path unassisted.