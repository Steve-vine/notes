---
id: 01KYY7KFHMY91ZP37BC8RG5AH8
created: 2026-08-01T08:38:42.996781Z
updated: 2026-08-01T09:10:10.956606Z
type: task
title: Reframe Overview as the installed-integrations view and move it into the Integrations nav section
project: 01KX671DATY39VW6GWK3M2T3DN
number: 452
sprint: sfv5yw0
assignee: steve
label: null
priority: medium
task_status: backlog
---
Three changes to the same surface, from Steve 2026-08-01. Frontend only — no API, no migration.

**1. Nav — `app/frontend/src/components/nav.ts`**

Move the Overview item out of the ISE Core section and make it the **first item of the Integrations section**. ISE Core then starts at Dashboards.

Overview carries **no `requiresCapability`**, deliberately — it must stay visible on a fresh install with nothing configured, since it is the screen that shows there is nothing configured. Consequence worth knowing: `AppLayout` drops a section whose visible items are empty (`components/AppLayout.tsx`), so the Integrations header will now render always, where today it disappears entirely until some integration declares a capability.

Routing is untouched — `/overview` stays the landing route.

**2. Drop Recent activity — `app/frontend/src/pages/OverviewPage.tsx`**

Remove the Recent activity card entirely: the `RecentActivity` component, the `useRecentActivity` query against `/api/v1/audit`, the `ActivityEvent` type, and the imports left unused (`Anchor`, and `relativeTime` only if the system cards no longer need it — they do, so keep it). The audit trail keeps its own screen; six lines of it under the system cards added noise, not signal. Backend untouched — the audit endpoint stays.

**3. Subtitle — same file**

`Connected systems at a glance.` → `Installed Integrations.` The page is the register of what is installed, matching where it now sits in the nav.

**Acceptance**
- Left nav: Overview sits at the top of Integrations, above Alerts; it is gone from ISE Core, which now starts at Dashboards.
- Overview renders the system cards and no activity card; no request to `/api/v1/audit` from this screen.
- Subtitle reads `Installed Integrations.`
- `npm run build`, eslint, `format:check` and vitest green — `App.test.tsx` asserts nav contents and lands on Overview.
