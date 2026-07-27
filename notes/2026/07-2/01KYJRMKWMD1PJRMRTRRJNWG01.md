---
id: 01KYJRMKWMD1PJRMRTRRJNWG01
created: 2026-07-27T21:45:32.820354Z
updated: 2026-07-27T21:45:32.820354Z
type: task
title: 'End-to-end acceptance: the two-persona walkthrough (engineer authors, desk executes)'
priority: medium
task_status: backlog
assignee: steve
label: chore
project: 01KX671DATY39VW6GWK3M2T3DN
number: 349
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