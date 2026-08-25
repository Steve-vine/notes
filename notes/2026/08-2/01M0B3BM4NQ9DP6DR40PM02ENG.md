---
id: 01M0B3BM4NQ9DP6DR40PM02ENG
created: 2026-08-18T18:50:20.693259Z
updated: 2026-08-25T18:43:01.566116Z
type: task
title: Sidebar nav doesn't scroll — items fall off the bottom on laptop screens
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 268
comments:
- id: 01M0B3RJK8PRBAQJXAWZN00G8G
  author: Steve Vine
  at: 2026-08-18T18:57:25.09652Z
  text: 'Merged to main (PR #253). The navbar''s section list is now wrapped in Mantine''s `AppShell.Section grow component={ScrollArea}` — the sidebar scrolls independently when it exceeds the viewport instead of clipping. `PortalLayout` has no sidebar, so it needed nothing. Deploying to staging for re-check.'
assignee: steve
company: null
label:
- bug
priority: medium
task_status: done
---
Smoke-test finding (2026-08-18): the left-hand menu has grown section by section (Overview/Library/Company/Vendors/Access/Admin) and now exceeds a laptop viewport, but `AppShell.Navbar` in `components/AppLayout.tsx` renders the section list directly with no scroll container — Mantine's navbar is fixed-position and clips overflow, so the bottom items are unreachable.

Fix: wrap the nav list in `<AppShell.Section grow component={ScrollArea}>` (the canonical Mantine AppShell pattern). Check `PortalLayout.tsx` for the same latent issue while there.

Refs: ADR 0022 (shell), 0017 (IA).