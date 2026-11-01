---
id: 01M68R4AK9AF117K3MYKERXQF2
created: 2026-10-31T10:29:49.289279Z
updated: 2026-11-01T00:46:05.048321Z
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
assignee: steve
label:
- improvement
priority: medium
task_status: review
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