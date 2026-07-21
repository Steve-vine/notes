---
id: 01KX6VZJM8TDKJQENVPREXEWWS
created: 2026-07-10T20:37:22.696938811Z
updated: 2026-07-21T16:23:19.946501Z
type: task
title: UI shell — Mantine theme, app shell, nav, light/dark
project: 01KX671DATY39VW6GWK3M2T3DN
number: 17
sprint: sqtx330
comments:
- id: 01KX6XA1BZ165344BXVPKF60Q2
  author: Steve Vine
  at: 2026-07-10T21:00:34.047889771Z
  text: 'Development complete on feature/ise-017-ui-shell. PR #12: https://github.com/Steve-vine/ise/pull/12. LIVE on staging: https://ise.citops.net. Compass design system replicated exactly per ADR 0019/brief: theme.ts (brand palette, primaryShade light7/dark4, Inter, component defaults), pre-paint scheme script, ise-color-scheme localStorage manager, ThemeToggle (light/dark/system). AppShell 56/248 with all seven nav sections — Overview live with empty state, deferred sections show honest "coming in Phase N" placeholders. Shared EmptyState/Loading/StatusPill + single statusColors map. Bell + user menu deliberately deferred to ISE-18 (need auth). 7/7 tests, lint/strict build clean, staging pipeline green (backend path-skipped, deploy ran — ISE-3 fix working). Please check BOTH light and dark mode in the smoke test (brief rule 3). Awaiting clearance.'
- id: 01KX6XSHJ2WDW97SQK2MQA5NKM
  author: Steve Vine
  at: 2026-07-10T21:09:02.146111754Z
  text: 'Smoke tests passed (light + dark). PR #12 merged to main (2df4c1e), branch deleted. Belt-and-braces main run green: frontend suite passed, backend path-skipped, main-tagged images pushed, no deploy on main as designed. Done.'
assignee: steve
label: null
priority: medium
task_status: done
---
Mantine with the Compass-replicated design system standard (ADR 0019, design-system brief): app shell, navigation, light/dark toggle. No feature screens yet — the frame the rest of the UI hangs on.