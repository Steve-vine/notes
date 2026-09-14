---
id: 01M2GTYBAQMKMNPMB9Q2CZFXN2
created: 2026-09-14T20:50:07.319105Z
updated: 2026-09-14T20:50:36.272927Z
type: task
title: The sizing helper breaks the chart on Helm 4 — `nil` is not a command
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 715
sprint: stek6vx
assignee: steve
label:
- bug
priority: urgent
task_status: active
---
Found by the `chart` CI job on PR #722 (COM-714), merged before the job's result was read — it is not yet a required check. `compass.sized` in `_helpers.tpl` assigns `{{ $x = nil }}` while walking a values path; Helm 4.2.4 (the runner image, and what the staging deploy uses) errors with `nil is not a command`, while Helm 3.21 on the dev box accepted it. Every template that renders a replica count or resources block fails, so main cannot be deployed until this lands.

Fix: track "not found" with a boolean instead of assigning the nil literal; a nil *value* read from values.yaml (`replicas:` left empty) is fine and still means "use the preset". Reproduce with helm v4.2.4 locally before pushing; run the chart job's exact steps with it.

Lesson recorded: the merge command must gate on the check conclusions, not on `mergeStateStatus` (UNSTABLE ≠ blocked when the job is not required). The `chart` context still needs adding to main's required checks (Steve).