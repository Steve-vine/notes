---
id: 01M3ACXAMMBKMPAWHWMX5HV5H3
created: 2026-09-24T19:05:09.012204Z
updated: 2026-09-24T19:05:09.012204Z
type: task
title: The secret scan runs the gitleaks CLI itself — the action wants a licence now the repo is an organisation's
label:
- chore
- bug
task_status: active
priority: medium
assignee: steve
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 745
---
After the move to RootCause-IT (COM-744) every run's `secret-scan` job fails with "missing gitleaks license": `gitleaks/gitleaks-action` is free for personal accounts and licensed for organisation repositories. The job gates the image build and the staging deploy, so nothing can be built or deployed until it is green again.

The gitleaks **CLI** is MIT and free — only the action wrapper is licensed. The job downloads a pinned release (checksum verified) and runs `gitleaks git` over the same commit range the action scanned: a pull request's commits on `pull_request`, the pushed commits on `main`/`staging`, the whole history when there is no range to speak of (a manual dispatch). The repo's `.gitleaks.toml`, if any, applies as before. No secret, no licence.