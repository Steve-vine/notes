---
id: 01M653KBZPSEMQG3WCMYNS0W41
created: 2026-10-30T00:33:18.838253Z
updated: 2026-10-30T08:16:06.920848Z
type: task
title: The user portal's Vendors pages ask for the company's vendor flags, which a portal-only person can't read — the request fails on every visit
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1455
sprint: s5pn06h
comments:
- id: 01M6540AVVJGY00EJQMD71YDJN
  author: Steve Vine
  at: 2026-10-30T00:40:23.67493Z
  text: |-
    Fixed: PR #1469 (auto-merge on).

    - The portal no longer asks for the company's vendor flags unless the person can read them.
    - I changed the plan slightly. Rather than leave the Flag filter out for portal-only people, the filter offers the flags on the vendors in front of them. Each vendor already carries its flags, so they keep the filter.
    - People who can read the company's flags see the full list as before.
    - Tests: two new ones (a portal-only person makes no flags request; someone who can read flags still does). All 206 tests that touch vendor flags or the portal register pass.
- id: 01M6599CBN1H97SB5X0V85X4AX
  author: Steve Vine
  at: 2026-10-30T02:12:42.997691Z
  text: 'Verified on staging after the deploy (ca55ed7d): "every screen opens" is green for E2E Asset Owner. The portal''s Vendors, My Vendors and My requests make no refused flags request. Done when met for the portal side; the internal user''s Flag filter is unchanged (covered by tests).'
assignee: steve
label:
- bug
priority: medium
task_status: done
---
Defect found by the browser suite (COM-1449), sprint 99, on staging 2026-10-30.

## What happens

Signed in as E2E Asset Owner (portal only, "Vendor Contact (portal)"), the portal's **Vendors**, **My Vendors** and **My requests** each ask for the company's vendor flags, and the request is refused. Most staff hold that portal role (ADR 0049), so it happens to most people who open the portal's Vendors. The page still draws, but the browser logs an error each time.

## The fix

The portal asks for flags only when the person can read them, and otherwise leaves the Flag filter out.

**Chain:** independent (screen only).

**Done when:** the browser suite's "every screen opens" is green for E2E Asset Owner, and an internal user still sees the Flag filter on the portal's Vendors.