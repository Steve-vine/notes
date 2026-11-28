---
id: 01M8FJ9P6TDZVCCK8XR9WY46RN
created: 2026-11-27T22:33:58.234473Z
updated: 2026-11-28T08:40:23.623227Z
type: task
title: 'Staging test data for software matching: a test-rig server pinned to a package with a published fix, so exact matching, automatic raising and closing can be seen end to end in the E2E Test Company'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2218
sprint: s51yxk5
blocked_by:
- 01M8FJ8ASETG2VM16JHRQJ8P8N
- 01M8FAWA6C6YNPYHHRGNNGQYDD
comments:
- id: 01M8GN022ME7M7Y1PZ7J7HRS47
  author: Steve Vine
  at: 2026-11-28T08:40:22.868029Z
  text: |-
    Built: PR #2230, merged to main (goes to staging with the sprints' deploy).

    What's there:
    - The staging Ubuntu test server (E2E Test Company only) holds libxml2 at Ubuntu's release version (2.9.14+dfsg-1.3ubuntu3), which security updates have since fixed. OSV lists 45 advisories against that version and 10 against the current update, so the server has real missing fixes and real Version match vulnerabilities.
    - The Rocky Linux 9 test server stays as its image ships, behind its repositories, so the rpm rules are seen too.
    - scripts/e2e/held-package.sh up installs the fix, and the vulnerabilities close at the next read. scripts/e2e/held-package.sh down holds it back again, and they reopen. "show" says what's installed. The e2e README explains it for the pre-UAT pass.
    - The Browser smoke already walks Security Feed ▸ Sources and Vulnerabilities ▸ Settings, since it walks every menu screen and tab. The per-server Missing security fixes and the item's Linux distributions panel appear only where there's data, so I check those in the pre-UAT pass.

    Differences: Ubuntu 24.04 rather than 22.04, because the test servers from COM-2208 run 24.04. I tested the hold-back in a throwaway Ubuntu 24.04 container: it holds at ubuntu3, and "up" moves it to ubuntu3.10.

    I'll set the test servers up on staging after the deploy.
assignee: steve
label:
- chore
priority: medium
task_status: review
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