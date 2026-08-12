---
id: 01KZVE8J6YJWF9RR3CS5TVVXW3
created: 2026-08-12T16:53:03.83838Z
updated: 2026-08-12T16:54:08.042928Z
type: task
title: Make web-crawler output usable in vuln-management (route-template dedup, inventory decoupling, per-host cap)
project: 01KZV767QMFTN9CZ3TPGTSAASD
number: 216
sprint: sp88phy
assignee: steve
imported_from: linear
label:
- tech_debt
priority: low
task_status: done
---
Found diagnosing the `vul-scan` run `91b7f09c`. **Deferred** — Steve is removing the web-crawler from the workflow for now; revisit when it's re-introduced.

### Problem

web-crawler turned **514 URLs → 7,303** (95% genuinely distinct pages; content-heavy + dev/staging mirror sites). Those 7,303 were fed straight into nuclei — whose templates are overwhelmingly **host/app-level** — so it re-ran the template set thousands of times for host-level …

---

*Excerpt — full description in Linear.*

Imported from Linear [DEV-566](https://linear.app/stevevine/issue/DEV-566/make-web-crawler-output-usable-in-vuln-management-route-template-dedup)