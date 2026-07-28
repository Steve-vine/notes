---
id: 01KYJ912KETR4XTW4B5B5GH9GF
created: 2026-07-27T17:12:43.88679Z
updated: 2026-07-28T14:37:15.109986Z
type: memo
title: ISE CI Issues
project: 01KX671DATY39VW6GWK3M2T3DN
comments:
- id: 01KYMJDYM5X87AZKR5P8KET4MD
  author: Steve Vine
  at: 2026-07-28T14:35:31.845022Z
  text: |-
    2026-07-28 ~13:59–14:30 UTC — staging CI hung on dependency install (Playbooks V2 batch, commit 170f910).

    Symptom: the staging push's combined-check job sat on the "Install (backend)" step (uv sync) for ~29 minutes — a step that normally completes in well under two even cold. The test suite never started; build/deploy never dispatched. Not a code failure: the same tree minus a two-line constants change had passed 15 hours earlier.

    Diagnosis: hung network fetch from PyPI on the runner. Runner pods themselves were healthy (3× ise-runners running, 0 restarts), so this is the transient-egress class, same family as the PyPI-DNS blip previously fixed by a re-run (Sprint 20) — and distinct from the ryuk/Docker Hub pre-pull hang (fixed permanently via TESTCONTAINERS_RYUK_DISABLED).

    Action: cancelled run 30365901281 and re-ran it (re-run pins the same commit — verified 170f910 == staging HEAD, so the re-run tests the right tree). Rerun completed the install normally.

    Underlying cause / standing gap: PyPI is not mirrored on g5, so every backend install depends on internet egress behaving. The Sprint 27 CI-performance work mirrored npm (Verdaccio) but the devpi PyPI mirror was torn down because `uv sync --frozen` ignores the configured index. If this recurs, the candidate fixes are: uv's native cache on a persistent runner volume, or revisiting a PyPI proxy that uv will actually honour (e.g. UV_INDEX_URL pointed at a pull-through cache rather than devpi's index-rewrite approach).

    Escalation rule used (worth keeping): one hang → re-run; a second hang on the same step in the same day = a real egress problem on the cluster, investigate the network path instead of re-running blind.
---
The following issues were experienced during the CI process (test, build, release). These are issues with the process itself rather than code errors failing tests.

Each issue should be added as a separate comment.