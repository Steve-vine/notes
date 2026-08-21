---
id: 01M0HT09DNZHZZP6J0NTK6Q89G
created: 2026-08-21T09:21:33.109464Z
updated: 2026-08-21T09:22:17.492003Z
type: task
title: Auto-rerun known infra-flake signatures
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 330
sprint: sspwpgk
assignee: steve
label:
- improvement
priority: medium
task_status: todo
---
Six flakes on 2026-08-20 each cost a manual rerun and 15–25 min of wall clock. Add a small workflow (workflow_run on failure) that greps the failed job's log for the known signatures — setup-uv "fetch failed", `EAI_AGAIN`, zot 502, codeload timeout — and retriggers failed jobs once (with a rerun cap). Cheap insurance while COM-327/328/329 remove the causes.