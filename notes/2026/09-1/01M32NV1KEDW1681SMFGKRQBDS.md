---
id: 01M32NV1KEDW1681SMFGKRQBDS
created: 2026-09-21T19:07:15.950079Z
updated: 2026-09-24T20:29:39.449499Z
type: task
title: Add version to title
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 734
sprint: s3nfes0
comments:
- id: 01M32RJWMF0DE76S84HEEFNSGE
  author: Steve Vine
  at: 2026-09-21T19:55:14.447352Z
  text: |-
    Done in PR #744 (merged to main, b3b44bf).

    What changed: the running version now sits in small grey text to the right of the title, on the title's baseline, in the app header and the Compass Portal header. It hides with the title on a phone-width screen. It is not shown in the Vendor Portal — that header is for an outside audience.

    What it reads:
    - Production: the released version, e.g. v0.5.0.
    - Staging: the build tag it is running, e.g. staging-20260921-1930 — so a smoke test can see at a glance which build is up. Staging never runs a released version, so there is no "v" number to show there.
    - A local run: dev.

    One thing to know for production: the version comes from the deployment, not the image, so it appears once production is upgraded to a chart release that includes this change (the next release). v0.5.0 as currently deployed will not show it.

    Technical: images are built once on trunk and never rebuilt for a release (ADR 0071), so the version cannot be compiled into the bundle. The chart's ConfigMap sets APP_VERSION from the image tag (image.tag, else appVersion); a new app_version setting (default "dev") feeds the existing version field of GET /api/v1/meta (previously a constant 0.0.0 — no schema change); the AppVersion component asks once and draws nothing if it gets no answer. OpenAPI info.version is left constant so the contract doesn't vary by environment.

    CI note: backend-test failed once on tests/test_container_recert.py::test_a_container_schedule_needs_the_inventory_permission and passed on rerun. Unrelated pre-existing flake — the test makes a "wrong" container ID by replacing the last character with 0, which is the same ID 1 time in 16. Worth a small task.
assignee: steve
label: null
priority: medium
task_status: done
tech: null
---
Add the current version (E.g. v0.5.0) in a mid-grey colour to the right of the title.