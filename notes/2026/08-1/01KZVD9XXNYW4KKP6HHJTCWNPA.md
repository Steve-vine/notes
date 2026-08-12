---
id: 01KZVD9XXNYW4KKP6HHJTCWNPA
created: 2026-08-12T16:36:20.021456Z
updated: 2026-08-12T16:36:20.021456Z
type: task
title: 'Frontend: Settings section shell (tabbed, super-admin gated)'
priority: high
imported_from: linear
assignee: steve
task_status: done
project: 01KZV767QMFTN9CZ3TPGTSAASD
number: 181
---
## Context

We need a first-class **Settings** section in the frontend with multiple tabs. The first tab is "CVE database" (sibling issue); this issue builds the reusable shell so future settings (profile, company, notifications, etc.) slot in as tabs.

## Scope

* New `/settings` parent route with a **tabbed layout**. `@radix-ui/react-tabs` is **not yet installed** — add it (keeps us within the Tailwind + Radix rule; no heavy component libs).
* Tabs gated by role: global/platform tabs (CVE database) require **super-admin** (`is_super_admin`); per-company tabs use company roles. Hide tabs the user can't access; guard the routes server-side too.
* Update the nav sidebar (`components/shell/sidebar.tsx`, currently `{ to: "/config", label: "Configuration" }`) to point at `/settings`. Migrate the existing `/config` (custom-settings) page in as a tab, and fold the reserved `/settings/profile` placeholder in.
* Follow existing patterns: TanStack Router, `features/custom-settings/*` layout, `components/ui/*` primitives.

## Acceptance criteria

* `/settings` renders a tabbed page; deep-linking to a tab works (URL per tab).
* A non-super-admin does not see (and cannot route to) the CVE database tab.
* Existing custom-settings functionality preserved under the new shell; old `/config` redirects.
* `npm run build` clean (TS strict); no `any`; dark + light mode correct.
* Playwright smoke green against dev with `RV_EXPECTED_SHA`.

## Reuse

* `routes.tsx` (`/settings/profile` reserved), `routes/config.tsx`, `features/custom-settings/*`
* `components/shell/sidebar.tsx`
* `require_super_admin` (client surfaces `is_super_admin`)

## Dependencies

Blocks: CVE database tab (DEV-<tab>). Independent of the backend issues.

*Triage-level brief.*

---

Imported from Linear [DEV-664](https://linear.app/stevevine/issue/DEV-664/frontend-settings-section-shell-tabbed-super-admin-gated)