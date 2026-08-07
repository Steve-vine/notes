---
id: 01KZ9MZBJBHK98DMTNM8MCT0FX
created: 2026-08-05T19:04:02.379675Z
updated: 2026-08-07T10:35:25.328106Z
type: task
title: Server evidence on demand — services, disks, logs, full facts in investigation
project: 01KX671DATY39VW6GWK3M2T3DN
number: 567
sprint: sesjg7z
assignee: steve
priority: medium
task_status: backlog
---
The investigation surface (ADR 0084 §read-state): everything not in the identity snapshot is Evidence, pulled when an investigation asks — "nothing polled an investigation didn't ask for" (the AWS/Azure discipline). Depends on ISE-565.

**Evidence operations** (side-effect free; both platforms; `data` is untrusted content by contract, degrade to `ok=False` with a summary on failure — the Freshservice pattern):
- `server_full_facts` — complete facts dump.
- `server_service_status` — one named service, or the failed/stopped-set summary (`systemd` units / Windows services).
- `server_disk_usage` — filesystems/volumes with usage.
- `server_recent_logs` — bounded tail of journald (Linux) / System+Application event log (Windows), bounded window and line cap, redaction list respected.

**Wiring**
- Registered on the evidence tool layer so issue-chat/investigation can call them against any registered server entity (bound cloud entities included), cited and bounded like every other evidence pull.
- **Entity detail**: services/disk cards on the server entity page, on-demand fetch (button/expand), never part of sync.

**Acceptance**: from an incident on a server entity, chat can pull service status and recent logs with citations; the entity page shows services and disk usage on demand; evidence failures degrade gracefully with the failure category, and nothing new appears in the scheduled sync payload.