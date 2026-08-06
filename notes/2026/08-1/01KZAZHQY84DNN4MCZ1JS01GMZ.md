---
id: 01KZAZHQY84DNN4MCZ1JS01GMZ
created: 2026-08-06T07:28:05.064803Z
updated: 2026-08-06T08:34:32.846317Z
type: task
title: 'MCP work-on prompt: orient-only session start, investigate on request'
project: 01KX671DATY39VW6GWK3M2T3DN
number: 573
trashed: 2026-08-06T08:33:49.369116Z
assignee: steve
label: null
priority: medium
task_status: backlog
---
The `/mcp__ise__work-on` prompt text tells Claude to "lead with the cues and offer the actions they imply", which Claude reads as a mandate to run a full investigation (evidence queries against live systems, code reading, `commit_diagnosis`) before the operator can interact — observed 3m03s to first interaction on IN-1234, with a diagnosis committed unprompted.

Change the `work-on` prompt text in `mcp_server/server.py::_render_prompt` so session start is read-only orientation: present the brief (what the incident is, what it affects, the cues) the way the incident screen would, then stop and wait for direction. Evidence queries / investigation / recording only when the operator asks ("analyse the incident") or gives a targeted check ("check pod logs on X for error Y"). The local `ise` skill has already been updated to match.