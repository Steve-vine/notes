---
id: 01M0HSZ7V9VJAASMWS8M0NZQN0
created: 2026-08-21T09:20:58.729889Z
updated: 2026-08-21T09:20:58.729889Z
type: task
title: Bake the CI toolchain into the runner image
label: improvement
priority: high
assignee: steve
task_status: todo
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 327
---
Every infra flake on 2026-08-20/21 was a per-job network fetch: setup-uv's astral manifest, setup-node's nodejs.org tarball, PyPI wheels, codeload action downloads. Bake uv (pinned UV_VERSION), node (.nvmrc version), and the pinned actions' payloads into the runner image so jobs fetch nothing at setup. Removes the flake class and ~30–60s per job. Mind the existing runner-image gotchas (see g5 CI environment notes).