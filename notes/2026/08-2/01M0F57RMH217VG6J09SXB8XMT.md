---
id: 01M0F57RMH217VG6J09SXB8XMT
created: 2026-08-20T08:40:09.105977Z
updated: 2026-09-01T13:55:50.366279Z
type: task
title: Tabs survive a refresh — the active tab goes in the URL, and becomes linkable while it is there
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 309
sprint: sbph5q5
comments:
- id: 01M0FGK43CSB9AZ5D07FT3J8PN
  author: Steve Vine
  at: 2026-08-20T11:58:35.628116Z
  text: |-
    Done — PR #302, merged to main as e0bdfad.

    `useTabParam(tabs, fallback?)` in `components/useTabParam.ts` carries the active tab as `?tab=`. Applied to the seven `defaultValue` pages (Admin, Vendors, FrameworkDetail, Content, VendorDetail, PortalVendorDetail, Risks) and the two on `useState` (Recert, ContentDetail). `PortalLayout` untouched — its tabs are routes, the precedent rather than a target.

    Both guards are in: the hook takes the tabs available *to this reader*, so an unknown or unpermitted `?tab=` falls back to the default rather than an empty page (wired to `canWriteVendors` on VendorsPage and `canWriteLibrary` on ContentDetailPage), and it preserves the rest of the query string so VendorsPage keeps its dashboard-tile filters through a tab change.

    **One deviation, and it is worth knowing about.** The task asked for both `replace: true` *and* back/forward stepping between tabs — those are mutually exclusive. I took the explicit `replace: true` bullet, so Back leaves the page rather than walking back through the tabs you clicked. One-line flip if you would rather have the history entries.

    One existing test changed shape but not meaning: ContentDetail's "jumps to the Read tab after publishing" now *awaits* the switch, because the tab lives in the router rather than in a synchronous `useState` — router navigations are transitions, so the DOM lands a tick later.

    Tests: five on the hook (a click puts the tab in the URL; a `?tab=` link opens it; unknown and permission-hidden values fall back; other params survive), plus an AdminPage test that a URL naming a tab opens it. Full suite green (442).

    Ready for smoke-testing: Admin → any tab → refresh should stay put; copy the URL to another tab and it should open where you left it; on Vendors, filter by state then change tab — the filter should survive.
assignee: steve
label:
- improvement
priority: medium
task_status: done
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
