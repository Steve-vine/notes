---
id: 01M0HSZ7V9VJAASMWS8M0NZQN0
created: 2026-08-21T09:20:58.729889Z
updated: 2026-08-21T21:19:12.723733Z
type: task
title: Bake the CI toolchain into the runner image
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 327
sprint: sspwpgk
comments:
- id: 01M0JWHR2FB72Y561V9MFRMSP5
  author: Steve Vine
  at: 2026-08-21T19:25:16.751267Z
  text: |-
    Done — PR #317, squash-merged to main 2026-08-21.

    Every infra flake on 2026-08-20/21 was a per-job fetch to the public internet: setup-uv reading its manifest from raw.githubusercontent.com, setup-uv then downloading the uv binary, setup-node pulling a tarball from nodejs.org. COM-196 had already established that pinning a version does not stop the fetch.

    So the toolchain moved into the image (scripts/infra/ci-runner-image/Dockerfile): uv at the pinned version, Node matching .nvmrc, zstd (without which actions/cache silently falls back to gzip), python3-venv (the stock image's system python has no ensurepip — the reason deps-scan carries UV_PYTHON_PREFERENCE), and a uv-managed CPython so the first `uv sync` on a pod does not download an interpreter. Eight setup steps left the workflow; the wheel and npm caches are now restored by actions/cache directly.

    The sharper find, turned up while sizing the scale set for COM-326: the stock image was referenced as `ghcr.io/actions/actions-runner:latest`, and a `latest` tag means the kubelet's pull policy is Always — so EVERY runner pod resolved and pulled from ghcr.io before it could start. When the uplink's DNS wobbled mid-sprint, containerd could not resolve ghcr.io, no runner could start, and CI stopped dead — while the host itself resolved names perfectly well and `docker pull` succeeded by hand. The runner image's own availability was a single point of failure on an uplink already known to be unreliable.

    It is now published to zot on the LAN, immutable tag, imagePullPolicy: IfNotPresent — which is what ADR 0008 asked for in the first place. Live image: zot.citops.net/compass/ci-runner:2.336.0-20260821-1158, scale set helm revision 6.

    Not included, deliberately: ACTIONS_RUNNER_ACTION_ARCHIVE_CACHE would also pre-seed the pinned actions' tarballs and remove the codeload fetch (one of the six flakes). The symbol is present in the runner binary but I could not confirm its filename contract without guessing, and a wrong guess fails silently as a cache miss. Left as a follow-up rather than shipped on a hunch.
assignee: steve
label:
- improvement
priority: high
task_status: done
---
Every infra flake on 2026-08-20/21 was a per-job network fetch: setup-uv's astral manifest, setup-node's nodejs.org tarball, PyPI wheels, codeload action downloads. Bake uv (pinned UV_VERSION), node (.nvmrc version), and the pinned actions' payloads into the runner image so jobs fetch nothing at setup. Removes the flake class and ~30–60s per job. Mind the existing runner-image gotchas (see g5 CI environment notes).