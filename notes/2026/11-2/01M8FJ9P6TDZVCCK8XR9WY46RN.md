---
id: 01M8FJ9P6TDZVCCK8XR9WY46RN
created: 2026-11-27T22:33:58.234473Z
updated: 2026-11-27T22:34:57.264907Z
type: task
title: 'Staging test data for software matching: a test-rig server pinned to a package with a published fix, so exact matching, automatic raising and closing can be seen end to end in the E2E Test Company'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2218
sprint: s51yxk5
assignee: steve
label:
- chore
priority: medium
task_status: todo
---
**Independent** (staging rig and test data; no migration or API). ADR 0188. After COM-2215; builds on the Server Agent rig (COM-2208).

## What it gives
- One of the staging rig's Linux containers (E2E Test Company only) runs **Ubuntu 22.04 with one package held at a version that has a published security fix** (an older OpenSSL, or another small package with a clear USN), so the staging journeys show a real exact match, a raised vulnerability, a close and a reopen.
- A documented way to **upgrade and downgrade** that package on staging (a script under `scripts/e2e/`, run from the pre-UAT pass), so COM-2215 and COM-2216's Done when can be checked.
- A **Rocky Linux 9** container beside it, so both version rules (dpkg and rpm) are seen on staging.
- The **Browser smoke** covers the new screens: a server's Missing security fixes, the Security Feed's Linux distributions section and Sources tile, and the Vulnerabilities source Version match.
- Nothing in any other company; production values never get the rig.

## Notes (technical)
- Pin the package with `apt-mark hold` from a snapshot mirror (`snapshot.ubuntu.com`) so the image stays reproducible; Rocky from the vault for an older release of a package.
- The rig's containers have no systemd: configuration checks read Couldn't tell for services, which is expected.

**Done when:** after the sprint's deploy, the E2E Test Company has one Version match vulnerability from the held package, the up/down script flips it to Fixed and back, and the Browser smoke is green with the new screens.