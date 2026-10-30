---
id: 01M653KBZPSEMQG3WCMYNS0W41
created: 2026-10-30T00:33:18.838253Z
updated: 2026-10-30T00:33:18.838253Z
type: task
title: The user portal's Vendors pages ask for the company's vendor flags, which a portal-only person can't read — the request fails on every visit
priority: medium
task_status: todo
assignee: steve
label: bug
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1455
---
Defect found by the browser suite (COM-1449), sprint 99, on staging 2026-10-30.

## What happens

Signed in as E2E Asset Owner (portal only, "Vendor Contact (portal)"), the portal's **Vendors**, **My Vendors** and **My requests** each ask for the company's vendor flags, and the request is refused. Most staff hold that portal role (ADR 0049), so it happens to most people who open the portal's Vendors. The page still draws, but the browser logs an error each time.

## The fix

The portal asks for flags only when the person can read them, and otherwise leaves the Flag filter out.

**Chain:** independent (screen only).

**Done when:** the browser suite's "every screen opens" is green for E2E Asset Owner, and an internal user still sees the Flag filter on the portal's Vendors.