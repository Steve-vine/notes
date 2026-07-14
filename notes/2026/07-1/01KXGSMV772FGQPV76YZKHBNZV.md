---
id: 01KXGSMV772FGQPV76YZKHBNZV
created: 2026-07-14T17:08:58.21573844Z
updated: 2026-07-14T17:09:04.115816157Z
type: task
title: Shell & navigation polish
label:
- brief
task_status: done
priority: medium
assignee: steve
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 53
sprint: s9nk96f
---
Reskin the app shell (`AppLayout` + `nav.ts`) on the M7 theme — branded, grouped, responsive. Modern & vibrant. (Visual; deploy to view.)

**Agreed approach (planned 2026-06-18).**

- [ ] **Top bar**: brand mark = `IconCompass` (teal) + bold **"Compass"** wordmark (replaces the plain `Title`); tidy right cluster (switcher · search · theme toggle · bell · user menu) with a subtle header border/elevation; a **burger** (left) toggling the sidebar on small screens.
- [ ] **Sidebar grouped** into labelled sections mirroring ADR 0017 (shared vs per-company): **Overview** (Dashboard) · **Library** (Domains, Controls, Content, Frameworks, Decisions) · **Company** (Assessments, Gaps, Risks, Reports) · **Admin** (admin-only). Add a `section` to `NAV_ITEMS`; render dimmed section labels. Refined active (teal `light`) + hover states; keep the `startsWith` highlight.
- [ ] **Responsive**: `useDisclosure` + `AppShell navbar={{ collapsed: { mobile: !opened } }}` + header burger.
- [ ] Keep nav targets + Admin admin-only intact; update `AppLayout` tests (nav renders, Admin gated, search routes, brand renders).

Refs: ADR 0017 (IA), 0022 (design), 0003. Depends on: <issue id="b5ce177b-1a3d-4b63-a107-7def7eaef133" href="https://linear.app/stevevine/issue/DEV-469/theme-foundation-lightdark-toggle">DEV-469</issue> (done).

---
*Migrated from Linear [DEV-470](https://linear.app/stevevine/issue/DEV-470/shell-and-navigation-polish) · created 2026-06-18 · completed 2026-06-18*