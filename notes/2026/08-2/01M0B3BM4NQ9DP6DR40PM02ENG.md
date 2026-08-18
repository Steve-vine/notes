---
id: 01M0B3BM4NQ9DP6DR40PM02ENG
created: 2026-08-18T18:50:20.693259Z
updated: 2026-08-18T18:50:20.693259Z
type: task
title: Sidebar nav doesn't scroll — items fall off the bottom on laptop screens
assignee: steve
priority: medium
task_status: active
label: bug
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 268
---
Smoke-test finding (2026-08-18): the left-hand menu has grown section by section (Overview/Library/Company/Vendors/Access/Admin) and now exceeds a laptop viewport, but `AppShell.Navbar` in `components/AppLayout.tsx` renders the section list directly with no scroll container — Mantine's navbar is fixed-position and clips overflow, so the bottom items are unreachable.

Fix: wrap the nav list in `<AppShell.Section grow component={ScrollArea}>` (the canonical Mantine AppShell pattern). Check `PortalLayout.tsx` for the same latent issue while there.

Refs: ADR 0022 (shell), 0017 (IA).