---
id: 01KZ9MZZH1NWTAHHY2SVJP0RW4
created: 2026-08-05T19:04:22.817271Z
updated: 2026-08-05T19:29:49.885597Z
type: task
title: Servers act catalogue — service restart/start/stop and reboot (T2) with check-mode preview
project: 01KX671DATY39VW6GWK3M2T3DN
number: 568
sprint: sesjg7z
assignee: steve
priority: high
task_status: backlog
---
The write surface (ADR 0084 §act) — Linux in this task; Windows follows in ISE-571. Depends on ISE-565. Uses the **write connection profile** (become/sudo on Linux, admin account on Windows).

**Catalogue — exactly four declared operations, all T2:**
- `restart_service` — named `systemd` unit / Windows service; rollback note honest: the service was already unhealthy, rollback is "start it again".
- `start_service` / `stop_service` — bounded to one named service; stop's rollback is start.
- `reboot_server` — **deliberately T2, not the EC2 T1**: an on-prem server that fails to come back is a site visit, not an API call; the ADR notes per-system policy raising to T3 for DCs/Hyper-V hosts.

Each op is a pinned ISE-authored playbook/module call reviewed at PR time. **No `run_playbook`, no `run_command`** — ruled out permanently in ADR 0084.

**Check-mode preview — the new capability:**
- On proposal (before approval), the executor runs the op with `--check --diff` and attaches the result to the ProposedChange: host reachable, unit/service exists, what would change. The approver sees a live preflight no other connector offers. Preview failure is shown, and blocks execution until re-run.
- Reboot has no meaningful check mode — its preview is reachability + a "cannot be previewed" statement, honestly declared.

**Execution semantics:**
- ansible-runner under Celery; not idempotent-retryable (a reboot ran twice is two reboots) so failures mark the ProposedChange `failed` with captured stdout/stderr for the audit trail, never silently retried (connectors-brief failure rule).
- `reboot_server` waits for the host to return (bounded wait) and reports came-back / did-not-come-back explicitly in the ActionResult.

**Frontend**: connector-generic ActionsPanel on server entities (AWS-sprint precedent); preview visible on the approval surface.

**Acceptance**: propose restart of a real service on a staging test box → approval shows the check-mode preview → approve → service restarts, ActionResult carries run output; reboot round-trips with came-back confirmation; a T2 without approval is refused.