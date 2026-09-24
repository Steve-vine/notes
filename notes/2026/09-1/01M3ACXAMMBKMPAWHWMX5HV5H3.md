---
id: 01M3ACXAMMBKMPAWHWMX5HV5H3
created: 2026-09-24T19:05:09.012204Z
updated: 2026-09-24T21:00:36.610839Z
type: task
title: The secret scan runs the gitleaks CLI itself — the action wants a licence now the repo is an organisation's
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 745
sprint: s3nfes0
comments:
- id: 01M3AEKCS7PYQAE7ECMFSBAZ7Z
  author: Steve Vine
  at: 2026-09-24T19:34:40.67914Z
  text: |-
    Done — PR #754, merged to main.

    The secret scan now runs the gitleaks CLI (8.30.1, pinned and checksum-verified, downloaded into the runner's temp dir) instead of `gitleaks-action`, which demands a licence for an organisation's repository. Same gate, same ranges: a pull request's own commits, the commits a push brings to main or staging, the whole history when there is no range. No secret, no licence. The PR's own scan was the proof: "Scanning commits origin/main..HEAD — 2 commits scanned — no leaks found".

    The same PR carries the other thing the move broke: the self-hosted runner scale set registered against `github.com/steve-vine/compass`, and GitHub's transfer redirect does not cover runner registration (POST /actions/runner-registration → 404), so after the move no runner could be created and every job sat queued. `scripts/infra/arc-compass-runners-values.yaml` now names `RootCause-IT/compass`; Steve ran the helm upgrade; the old listener held the scale set's session (the new one got 409) and was removed by hand, as were the old runner set's leftovers whose deregistration finalizer could never complete against the old URL.

    Nothing to smoke-test in the app.
assignee: steve
label:
- chore
- bug
priority: medium
task_status: done
---
After the move to RootCause-IT (COM-744) every run's `secret-scan` job fails with "missing gitleaks license": `gitleaks/gitleaks-action` is free for personal accounts and licensed for organisation repositories. The job gates the image build and the staging deploy, so nothing can be built or deployed until it is green again.

The gitleaks **CLI** is MIT and free — only the action wrapper is licensed. The job downloads a pinned release (checksum verified) and runs `gitleaks git` over the same commit range the action scanned: a pull request's commits on `pull_request`, the pushed commits on `main`/`staging`, the whole history when there is no range to speak of (a manual dispatch). The repo's `.gitleaks.toml`, if any, applies as before. No secret, no licence.