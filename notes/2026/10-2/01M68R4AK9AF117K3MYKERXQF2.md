---
id: 01M68R4AK9AF117K3MYKERXQF2
created: 2026-10-31T10:29:49.289279Z
updated: 2026-11-01T08:40:51.156904Z
type: task
title: The portal's attestations page is titled "My attestations" — the menu item stays "Attestations"
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1489
sprint: snvd637
comments:
- id: 01M6A945B95GFDN4YV0W9FV1PW
  author: Steve Vine
  at: 2026-11-01T00:46:04.137423Z
  text: 'Done — merged to main in PR #1505 (2026-11-01). The portal''s attestations page and its breadcrumb read "My attestations"; the menu item still reads "Attestations". Not yet on staging — the sprint deploys once all 12 are in Review.'
- id: 01M6AJ4XBSP2XZDY7776HBBH1X
  author: Steve Vine
  at: 2026-11-01T03:23:45.913351Z
  text: |-
    Pre-UAT (Claude, 2026-11-01, staging build 20261101-0257): **Couldn't check** in full.

    - The page heading reads "My attestations": I opened /portal/attestations as E2E Asset Owner.
    - I couldn't see the menu item. None of the test accounts has anything to sign, so the Attestations item is hidden for all of them.
    - I didn't assign content to sign: that would mean changing attestation assignments on shared library content, which the staging test rules keep off-limits.

    Steve to look at: sign in as anyone with something to sign and check the menu still reads "Attestations". The label's code is unchanged.

    Screenshot: ~/compass-uat/sprint-80/COM-1489/01-my-attestations.png
assignee: steve
label:
- improvement
priority: medium
task_status: done
---
Sprint 80, Update user portal. Requested by Steve on 2026-10-31.

## What people see

- The page title reads **My attestations** where it said "Attestations".
- The menu item still reads **Attestations**.
- The "To sign" and "Signed" sections, and who sees the page, don't change.

## Notes (technical)

- Change the `PageHeader` title in `PortalAttestationsPage.tsx` and the page's trail label, which follows the page title rather than the menu. Update the tests that find the heading.

**Chain:** independent (frontend only).

**Done when:** on staging, signed in as an account with something to sign, the menu reads Attestations and the page reads My attestations.