---
id: 01KYY7KFHMY91ZP37BC8RG5AH8
created: 2026-08-01T08:38:42.996781Z
updated: 2026-08-07T12:15:49.466119Z
type: task
title: Reframe Overview as the installed-integrations view and move it into the Integrations nav section
project: 01KX671DATY39VW6GWK3M2T3DN
number: 452
sprint: sfv5yw0
comments:
- id: 01KYYAEJDBA11BW2WDYP7NNMRW
  author: Steve Vine
  at: 2026-08-01T09:28:27.819036Z
  text: |-
    Built 2026-08-01 — PR #393, merged to staging (51f5a67). Frontend only, no API change, no migration.

    All three changes landed as specified. The one thing worth recording is the consequence flagged at planning time, now real and covered by a test: the Integrations section header ALWAYS renders. AppLayout drops a section whose visible items are all gated away, so before this the whole section vanished on a fresh install until some integration declared a capability. Overview is deliberately ungated — it is the screen that shows there is nothing configured, so hiding it would hide the way in.

    App.test.tsx asserted the old behaviour ("no Integrations section") and now asserts the new one: the header stays, every capability-gated item beneath it still hides. That test would have caught this if I had not; worth noting it was a real assertion change, not a cosmetic one.

    Recent activity removed along with its /api/v1/audit query, the ActivityEvent type and the orphaned Anchor import. The audit endpoint and screen are untouched. Subtitle now reads "Installed Integrations." Routing unchanged — /overview is still the landing route.

    Gates: full frontend suite 472 tests across 83 files green; npm run build, eslint, prettier green.
assignee: steve
label: null
priority: medium
task_status: done
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
