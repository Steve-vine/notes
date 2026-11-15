---
id: 01M7FM3KQKVVNE715KM24SGSSP
created: 2026-11-15T12:49:54.419223Z
updated: 2026-11-15T15:22:49.705165Z
type: task
title: An Automation group joins the menu — Checks moves into it and is called Evidence Collection, with Workflows beside it; old addresses still work
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1849
sprint: s7nqsy0
blocked_by:
- 01M7FM37RNKW81E5SQ1QDQA2MN
assignee: steve
label:
- feature
priority: high
task_status: active
---
Sprint "Automation - Workflows" (ADR in COM-1848).

## What people see

- The Compass menu (M) has a tenth group, **Automation**, with its own icon and foot line (suggested: "What Compass does for you").
- In it: **Evidence Collection** (today's Posture ▸ Checks, renamed) and **Workflows** (until the Workflows task lands, Workflows is hidden).
- Posture loses Checks. Its other pages are unchanged.
- Everywhere the page is named, it says **Evidence Collection**: page header, top-bar trail, Find a page (which also finds it by "checks"), pinned pages, Overview tiles and links, and Polaris's replies.
- Inside Evidence Collection the tabs keep their jobs (Overview, All checks, Review, Settings). Each collected check is still called a check and keeps its CHK ID.
- A pinned "Checks" page follows the rename, so nobody's pins break. Old links (`/checks…`) open the new page.

## Notes for the builder

- ADR 0152 amendment (nine groups → ten) is part of COM-1848. Menu groups, foot lines and icons are data in the menu definition.
- Keep the old routes as redirects, so emails, Actions links and bookmarks keep working.
- Screen conventions (`brief/information-architecture.md`).

## Done when

- Automation shows in the menu for anyone who can see Evidence Collection, and is hidden for anyone who can't.
- Every mention on screen says Evidence Collection, Find a page finds it by either name, and existing pins and old links land on it.
- Browser smoke opens Automation ▸ Evidence Collection for each test account that can see it.

**Independent** (no migration, no API change), though pins may need a data fix: if they do, it joins the chain.