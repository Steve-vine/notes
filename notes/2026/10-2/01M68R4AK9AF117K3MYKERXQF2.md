---
id: 01M68R4AK9AF117K3MYKERXQF2
created: 2026-10-31T10:29:49.289279Z
updated: 2026-10-31T10:29:52.508371Z
type: task
title: The portal's attestations page is titled "My attestations" — the menu item stays "Attestations"
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1489
sprint: snvd637
assignee: steve
label:
- improvement
priority: medium
task_status: todo
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