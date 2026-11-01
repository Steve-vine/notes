---
id: 01M68R2RM7C9D1M2DVH20XHXEG
created: 2026-10-31T10:28:58.119925Z
updated: 2026-11-01T00:28:08.8087Z
type: task
title: The portal's Actions is renamed "My actions" — in the menu, the page title and the trail
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1485
sprint: snvd637
comments:
- id: 01M6A83A2Q8QG1ZAJGP9ZY9VEJ
  author: Steve Vine
  at: 2026-11-01T00:28:07.639016Z
  text: 'Done — merged to main in PR #1503 (2026-11-01). The portal menu item, the page title and the breadcrumb trail all read "My actions". The address is still /portal/actions, so old email links work, and the internal Actions screen is unchanged. Not yet on staging — the sprint deploys once all 12 are in Review.'
assignee: steve
label:
- improvement
priority: medium
task_status: review
---
Sprint 80, Update user portal. Requested by Steve on 2026-10-31.

## What people see

- The menu item reads **My actions** where it said "Actions".
- The page title and the breadcrumb trail say **My actions**.
- The address stays the same, so links in old emails still open it.
- The internal app's Actions screen is not affected. Sprint 100 (COM-1475) adds the "My actions" switch there.

## Notes (technical)

- Change the label in `portalNav.ts` and the `PageHeader` title in `PortalActionsPage.tsx`, plus any trail label for `/portal/actions`.
- Update the tests that find the entry by its name.

**Chain:** independent (frontend only).

**Done when:** on staging, signed in as E2E Asset Owner, the menu and the page both read "My actions".