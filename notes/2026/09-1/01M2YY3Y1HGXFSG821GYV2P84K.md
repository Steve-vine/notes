---
id: 01M2YY3Y1HGXFSG821GYV2P84K
created: 2026-09-20T08:14:58.097018Z
updated: 2026-09-24T20:29:38.655662Z
type: task
title: The browser tab shows the Compass mark — the favicon was still the Vite default
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 731
sprint: stek6vx
assignee: steve
label:
- improvement
priority: low
task_status: done
tech: null
---
`app/frontend/public/favicon.svg` was the purple Vite lightning bolt that came with the project scaffold. Steve, 2026-09-20: use the icon beside "Compass" in the header.

That mark is Tabler's outline `compass` (MIT) in the brand accent. The favicon becomes the same paths, stroke in the shipped brand pair — `#1772a8` on a light tab strip, `#4aace0` under `prefers-color-scheme: dark` (BRAND shades 7 / 4, the pair the header uses) — with the viewBox tightened so the ring fills a 16 px tab. A static file cannot follow an administrator's Admin ▸ Appearance accent; that is accepted and said in the file.

**Acceptance**: the tab, bookmarks and the Vendor Portal tab show the compass mark; legible at 16 px on light and dark tab strips.