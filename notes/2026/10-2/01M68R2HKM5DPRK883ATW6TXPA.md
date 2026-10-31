---
id: 01M68R2HKM5DPRK883ATW6TXPA
created: 2026-10-31T10:28:50.932353Z
updated: 2026-10-31T10:33:04.307568Z
type: task
title: The portal menu is one list with no headings — "Your work" and "Modules" go
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1484
sprint: snvd637
assignee: steve
label:
- improvement
priority: medium
task_status: todo
---
Sprint 80, Update user portal. Requested by Steve on 2026-10-31.

## What people see

- The portal sidebar is **one menu with no section headings**. "Your work" and "Modules" are removed.
- Order, top to bottom:
  - what is asked of you personally comes first: **My actions · Security incidents · Attestations · DDQ**;
  - then the modules, A to Z: **Access Control · Audits · Gaps · Inventory · Policies · Risk assessments · Risks · SAP · Vendors · Vulnerabilities**.
  - Audits, Gaps, Policies, Risk assessments and Risks are new this sprint (COM-1491..1495). Each goes in its place as it lands.
- Each item keeps its own rule for who sees it. An item someone can't use still doesn't appear, so most people see only a few.

## Notes (technical)

- `components/portalNav.ts`: drop `PortalNavSection` / `PORTAL_NAV_SECTIONS` and the `section` field, then render a flat list in `PortalLayout`.
- `PortalRouting.test.tsx` checks that the internal section names are absent. Keep that check: it still guards ADR 0040 §2 and no longer depends on the portal's own headings.
- Several tasks in this sprint edit `portalNav.ts`, so expect a conflict on each one after the one before it squashes. Push the next one only when its turn comes.

**Chain:** independent (frontend only).

**Done when:** on staging, signed in as E2E Asset Owner, the portal sidebar shows one list in the order above with no headings.