---
id: 01M7FM3KQKVVNE715KM24SGSSP
created: 2026-11-15T12:49:54.419223Z
updated: 2026-11-15T22:07:37.729665Z
type: task
title: An Automation group joins the menu — Checks moves into it and is called Evidence Collection, with Workflows beside it; old addresses still work
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1849
sprint: s7nqsy0
blocked_by:
- 01M7FM37RNKW81E5SQ1QDQA2MN
comments:
- id: 01M7FZ4DRABS83ST2M2MN4J9SB
  author: Steve Vine
  at: 2026-11-15T16:02:35.40235Z
  text: |-
    Done — PR #1845 merged. The Compass menu has a tenth group, Automation (after Assurance, robot icon, foot line "What Compass does for you"), shown to anyone who can see Evidence Collection. Posture ▸ Checks is now Automation ▸ Evidence Collection at /automation/evidence-collection, with the same tabs and check pages; Posture keeps Assessments, Gaps and Compliance. Workflows is set up beside it but hidden until COM-1851 switches it on.

    - Every old /checks… link (emails, Actions, bookmarks) opens the new page, keeping the tab and filters.
    - A pinned Checks page shows as Evidence Collection — no data fix needed.
    - Find a page finds it by "checks" too.
    - Page header, trail, Dashboard tile, audit-pack and review sentences, Polaris's status line and tool descriptions and the staging MCP instructions all say Evidence Collection. A collected check is still a check with its CHK ID.
    - The Dashboard tile's passing / can't-tell badges now open All checks with that filter (before, they opened the Overview with a filter it didn't show).
    - Browser smoke opens Automation ▸ Evidence Collection for every account that can see it, and checks an old /checks?tab=review link lands on Review.

    No migration, no API change. One route description still says "Checks ▸ Review" (changing it would change the API contract); COM-1857 rewrites that wording.
- id: 01M7GM0G5RJJN85PJHX3AJA7RN
  author: Steve Vine
  at: 2026-11-15T22:07:26.904743Z
  text: |-
    Passed (pre-UAT, 2026-11-15, build f8665615, E2E Test Company).

    Steps and what I saw:
    - As E2E Admin A I opened the Compass menu. There are ten groups, with Automation (2 pages) between Assurance and Admin. Inside it are Evidence Collection ("Checks that collect evidence from each service, and Compass's own checks.") and Workflows. The foot line reads "What Compass does for you".
    - Typing "checks" in Find a page finds Evidence Collection, under Automation.
    - The old link /checks?tab=review opened Automation ▸ Evidence Collection on the Review tab. The page header says Evidence Collection, with the tabs Overview / Review / All checks / Settings.
    - An old pin: I set Admin A's saved pins to include the old Checks address. After a reload the pin showed as "Evidence Collection" and opened the new page. I then put Admin A's pins back as they were. Pinning Evidence Collection from the menu also survives a reload.
    - The Dashboard tile is titled Evidence Collection, and its links go to the new address.
    - As E2E Viewer and as E2E Assessor, the menu shows Automation with both pages.

    I didn't run the Browser smoke myself. Its result is on the staging deploy run.

    Screenshots: ~/compass-uat/s7nqsy0/COM-1849/
assignee: steve
label:
- feature
priority: high
task_status: review
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