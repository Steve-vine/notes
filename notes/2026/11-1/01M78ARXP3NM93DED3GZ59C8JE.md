---
id: 01M78ARXP3NM93DED3GZ59C8JE
created: 2026-11-12T16:52:05.955985Z
updated: 2026-11-13T01:59:55.195629Z
type: task
title: A Viewer opens a domain page without a refused request in the background
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1770
sprint: spsp226
comments:
- id: 01M78CNY0QPE8G5CYSE7QB9H37
  author: Steve Vine
  at: 2026-11-12T17:25:25.143576Z
  text: 'More detail from the COM-1767 builder (2026-11-12): document (content) pages do it too, not just domain pages. Cause: `useUsers` in app/frontend/src/content/hooks.ts asks for the people list (administrators only), called from DomainDetailPage and ContentDetailPage regardless of the viewer''s rights.'
- id: 01M78WCJ7N61HJ7FQMS6M7Q9RF
  author: Steve Vine
  at: 2026-11-12T21:59:55.38122Z
  text: |-
    Built — PR #1768 (auto-merge set; frontend only).

    A Viewer opening a domain page or a document page now has a clean console — the administrators-only people list is no longer asked for. Reviewer names and the Reviewers picker now come from the colleague list (names and job titles), which every internal reader may read.

    Better than the original suggestion ("only load it for editors"), because that would have left: the Viewer's Reviewers line blank (it was blank for Viewers until now, since the request was refused — now they see the names); and an editor who isn't an administrator still getting an empty picker plus a refused request. Now anyone who can edit gets a filled picker.

    One difference: the colleague list holds active accounts only, so a reviewer whose account has been disabled is no longer named on these pages (administrators used to see that name).

    Checks: confirmed on staging that the Viewer's /api/v1/users is refused (403) today and the colleague list returns 200. New tests for a Viewer on a domain page and a document (names shown, admin list never requested) and an editor's picker — fail without the fix, pass with it. eslint, tsc, prettier; the two page test files (51) pass. Browser check of the fix after deploy.
- id: 01M79A40HVA7Q6GTTQNG1TSQWY
  author: Steve Vine
  at: 2026-11-13T01:59:55.195439Z
  text: |-
    Pre-UAT on staging (6e988b9d), E2E Test Company: **Passed**, one item **Couldn't check**.
    - Viewer on /domains/access-control and /content/access-control-policy: console clean, no refused requests; only the colleague list is requested (200), the administrators' list never.
    - Admin A on a document's Edit tab: the Reviewers picker lists 21 colleagues (opened, closed, not saved).
    - Couldn't check: reviewer names shown to a Viewer — none of the 24 domains or the first 30 documents on staging has a reviewer set, and the Playbook isn't edited in testing. Steve: set a reviewer on a document, then open it as the Viewer and see the name under Details ▸ Reviewers.
    - Not tried: a non-administrator editor (e.g. Analyst).
    Screenshots ~/compass-uat/spsp226/COM-1770/.
assignee: steve
label:
- bug
priority: low
task_status: review
---
Found in the sprint 116 round-3 pre-UAT pass on staging (3175d2ad, 2026-11-12). Not caused by round 3.

**What happens:** as E2E Viewer, opening a domain page (/domains/access-control) logs `GET /api/v1/users` → 403 in the browser console. Reproduced on its own. The page otherwise works.

**What it should do:** the page doesn't ask for something the Viewer can't read (e.g. the people list behind an owner picker only loads for someone who can edit), so nothing shows in the console.

**Done when:** the Viewer opens a domain page with a clean console; someone who can edit still gets the picker; a test covers the Viewer case. Frontend only, independent.