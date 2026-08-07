---
id: 01KZAZZFKJJPMW25C875P68GZ1
created: 2026-08-06T07:35:35.282058Z
updated: 2026-08-07T09:40:52.90577Z
type: task
title: 'MCP work-on prompt: orient-only session start, investigate on request'
project: 01KX671DATY39VW6GWK3M2T3DN
number: 576
assignee: steve
label: null
priority: medium
task_status: done
---
The `/mcp__ise__work-on` prompt text tells Claude to "lead with the cues and offer the actions they imply", which Claude reads as a mandate to run a full investigation (evidence queries against live systems, code reading, `commit_diagnosis`) before the operator can interact — observed 3m03s to first interaction on IN-1234, with a diagnosis committed unprompted.

Change: `work-on` prompt text in `mcp_server/server.py::_render_prompt` now makes session start read-only orientation — present the brief (what the incident is, what it affects, the cues) the way the incident screen would, then stop and wait for direction. Evidence queries / investigation / recording only when the operator asks ("analyse the incident") or gives a targeted check ("check pod logs on X for error Y"). The `start_incident_session` reply note aligns. The local `ise` skill was updated to match.

PR #489 → main. Merged to staging (0a5ceed). Smoke: `/mcp__ise__work-on IN-NNNN` should return the brief in seconds with no timeline writes beyond `mcp_session_started`.