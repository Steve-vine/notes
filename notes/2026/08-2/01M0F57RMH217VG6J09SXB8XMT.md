---
id: 01M0F57RMH217VG6J09SXB8XMT
created: 2026-08-20T08:40:09.105977Z
updated: 2026-08-20T08:40:09.105977Z
type: task
title: Tabs survive a refresh — the active tab goes in the URL, and becomes linkable while it is there
assignee: steve
label: improvement
priority: medium
task_status: todo
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 309
---
Refresh any tabbed page and you land back on the first tab. Ten pages do it, and the worst is **Admin, which has ten tabs** — precisely where a refresh is most likely, because that is where you go after changing something that needs reloading to see.

**Put the active tab in the query string** (`?tab=requests`), through one small shared hook rather than ten copies of the same three lines. That fixes the refresh, and it also gets back/forward working and makes a tab **linkable** — "look at the Approvals tab" becomes a URL instead of an instruction.

Not localStorage: a remembered tab travels with the *person*, so a link you send a colleague opens on whatever tab they last used, and the same URL means different things to two people. The URL is the thing that should carry the state.

**The idiom already exists here.** `useSearchParams` is used on seven pages, COM-298 established the read-*and*-write shape for it in `PortalRequestsPage` (`?request=<id>`), and `PortalLayout` already drives its own tabs from the route. This makes the rest of the app agree with the part that already behaves.

**Where it applies** — ten `<Tabs>`, in three states:

- [ ] **Uncontrolled `defaultValue`, resets on refresh — the eight this is really about**: `AdminPage` (10 tabs), `VendorsPage` (5), `FrameworkDetailPage` (3), `ContentPage` (3), `VendorDetailPage` (3), `PortalVendorDetailPage` (3), `RisksPage` (2).
- [ ] **Controlled by `useState`, also resets on refresh**: `RecertPage`, `ContentDetailPage`. Same fix, one line smaller.
- [ ] **Already sticky, leave alone**: `PortalLayout` — its tabs *are* routes and it navigates between them. It is the precedent, not a target.

- [ ] **`?tab=` is free of collisions** — checked: `VendorsPage` already reads `state`/`status`/`criticality` from the query string for the dashboard-tile deep links, `SearchPage` uses `q`, the reset/login pages use `token`. Nothing uses `tab`, and the hook must **preserve** the other params rather than replacing the query string (`VendorsPage` would otherwise lose its filters the moment you changed tab).
- [ ] **An unknown or unpermitted `?tab=` value falls back to the default** rather than rendering an empty page. This matters: half these pages hide tabs behind a permission (`{canEdit && <Tabs.Tab .../>}`), so a link to `?tab=questions` from someone who can see it will be opened by someone who cannot.
- [ ] **`replace: true` on the history entry**, as COM-298 did — clicking through five tabs should not mean pressing Back five times to leave the page.
- [ ] Tests: a tab click puts it in the URL and back/forward moves between tabs; loading a URL with `?tab=` opens that tab; an unknown value and a permission-hidden value both fall back to the default; changing tab on `VendorsPage` keeps an existing `state`/`criticality` filter in the URL.
