---
id: 01M3Q1K82GNMBWV667KHS4THGT
created: 2026-09-29T16:57:31.98491Z
updated: 2026-09-29T17:20:31.830833Z
type: task
title: 'The trail appears — and the Playbook''s back links go: Domains, Controls, Content, Decisions, Frameworks'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 787
sprint: svq5edz
blocked_by:
- 01M3Q1JNR2Z6QFHGXFZ37BSNN3
comments:
- id: 01M3Q2XAKF5GYQ7GC3KVH3A1GH
  author: Steve Vine
  at: 2026-09-29T17:20:30.831825Z
  text: |-
    Done: PR #797, stacked on #796.

    What you'll see:
    - **The trail.** A line above every page shows the way you came across sections, e.g. Domains › Access control › Password Standard.
    - **Going back.** Clicking a step returns you to that page as you left it: the same tab and the same place on the page, whether a detail page or a list's rows. The steps after it are dropped. A link to a page already on the trail cuts back to it in the same way.
    - **Back, Forward and refresh.** The browser's Back and Forward keep the trail in step, and a refresh keeps it.
    - **Arriving from outside.** A pasted link, a bookmark or a notification shows the page's natural home, e.g. Content › Password Standard.
    - **Starting a new trail.** The menu, the top-bar search, the bell and switching company each start one.
    - **Short and long trails.** A one-step trail is hidden, since it would just repeat the title. Long trails fold their middle into "…", which lists what's hidden.
    - **Playbook pages.** Domain, control, document, decision and framework pages no longer have their "← Section" links. Their steps are named as the screen names them (5.2 · …, D-12 · …). The search results step reads Search: "…".

    Checked in a real (headless) browser:
    - A list's rows scrolled down come back to the same place after going domain → document → clicking "Domains" in the trail.
    - A long domain page comes back to the same position from the trail and from Back.
    - Forward and Back swap the trail correctly.

    The full frontend suite passes locally (1,456 tests). A new check stops anyone hand-writing a back link again. The pages the other section tasks convert are exempt until their task lands, and the vendor portal is exempt for good.
assignee: steve
label:
- feature
priority: high
task_status: review
---
Builds the trail decided in COM-786 and switches it on for the Playbook, the section where Steve hit the problem. The other sections follow in COM-788…791 and reuse what this task builds.

## What people see

- **Steve's journey works.** Choose Domains from the menu, then pick *Access control*, then open *Password Standard* from its documents. The trail reads `Domains › Access control › Password Standard`. Clicking *Access control* returns you to the domain at the same place on the page. Following a control from the document adds `› 5.2 …`, and so on.
- **The fixed back links go** from domain, control, document, decision and framework pages. That includes the "← Back to …" on their not-found pages, where the trail is enough.
- **Steps are named the way the screen names them:**
  - a domain by its name;
  - a control by its reference and title;
  - a document by its title;
  - a decision by its number and title;
  - a framework by its name;
  - a list by its menu name.
  - Switching tabs on a page changes where its step returns to, but doesn't add a step.
- **Starting a new trail.** The menu, the top-bar search, opening a notification and switching company each start a new trail. The search results page is the first step, labelled `Search: "password"`.
- **Refreshing** keeps the trail. **Back** removes its last step. A **pasted link or a new tab** shows the natural home (`Content › Password Standard`).
- **Long trails** show the first step, "…", and the last two. Clicking the "…" lists the rest.
- **Opening "New decision"** is a pop-up, so it isn't a step.

## Notes (technical)

- **New shell pieces.** `components/Trail.tsx` plus a small store, `trail.ts`, which holds the reducer and `sessionStorage` under `location.key`. Also a hook, `useTrailLabel(label)`, which a page calls once its record has loaded; until then the step shows the URL's natural label. The trail renders in `components/AppLayout.tsx` above the `page-pane` (`:180-196`), outside the scroll.
- **Navigation actions.** PUSH extends the trail. REPLACE rewrites the current step's URL (`useTabParam` uses `replace: true`). POP restores the trail stored for that key. A revisit cuts back to the earlier occurrence, matching on pathname so a different tab still counts as the same page.
- **Trail starts.** These pass `state: { trail: 'start' }`:
  - the menu's `go()` (`AppLayout.tsx:142-149`);
  - the top-bar search's `navigate('/search?q=…')`;
  - `NotificationBell.tsx:41`;
  - the company switcher. `CompanyProvider` keeps the company server-side, not in the URL, so a trail across companies would mislead.
- **Scroll.** `AppLayout.tsx:62-64` resets scroll whenever the pathname changes. Keep that for a PUSH. On a trail click or a POP, restore the scroll position saved for that key.
- **Natural home.** A route → home map for the no-record case, e.g. `/content/:slug` → `Content`. `DataAsset` → `/inventory?tab=data` as today.
- **Back links removed:**
  - `pages/ControlDetailPage.tsx` 56/65
  - `ContentDetailPage.tsx` 150/159
  - `DomainDetailPage.tsx` 94/103
  - `DecisionDetailPage.tsx` 38/50
  - `FrameworkDetailPage.tsx` 126/183
- **Ratchet test** in `screen-conventions.test.ts`: no hand-rolled back link (a `←` anchor, or an `IconArrowLeft` back button to a section) outside an allowlist. The allowlist starts with the pages COM-788…791 cover, and each of those tasks empties its own entries. The vendor portal is permanently exempt. The "← Previous" pager (`DirectoryRolesPage`) is not a back link.
- **Tests:**
  - vitest on the reducer: start, push, revisit-cuts, replace, pop, and no record → natural home;
  - a page test for domain → document → click the domain step.
- **IA brief.** Update the "page header is a plain Title" note (`brief/information-architecture.md:149-161`) to point at the convention COM-786 adds.

**Done when:** on staging, Steve's journey (Domains → domain → document → click the domain step) returns to the domain where he left it. Refresh keeps the trail, Back drops the last step, and a pasted document link shows `Content › document`. No Playbook page has a fixed back link.