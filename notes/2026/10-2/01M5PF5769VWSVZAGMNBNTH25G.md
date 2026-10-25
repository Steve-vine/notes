---
id: 01M5PF5769VWSVZAGMNBNTH25G
created: 2026-10-24T08:06:41.609226Z
updated: 2026-10-25T16:24:23.615927Z
type: task
title: The DDQ page is titled "Due Diligence Questionnaires" — the menu item stays "DDQ"
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1277
sprint: shig2cj
comments:
- id: 01M5PX2VGC893HWYTV8Z0Z5QN4
  author: Steve Vine
  at: 2026-10-24T12:10:04.172509Z
  text: |-
    Done — merged in #1287.

    What changed: the menu still says DDQ. The page it opens is now titled Due Diligence Questionnaires, and the trail (breadcrumb) on a DDQ or a Q&A library entry starts with "Due Diligence Questionnaires". A single DDQ keeps its DDQ-7 reference. A question assigned to someone is still reached from Actions, and its trail starts at Actions.

    My calls:
    1. Spelled "Diligence".
    2. The trail uses the full name, to match the page title.
    3. Not done: the browser tab. It still reads "Compass", as it does on every page, because Compass doesn't put page names in the tab today. Making DDQ the only page that does would be a new convention. If you want it anyway, it's a small follow-up, and probably worth doing for every page.

    To check on staging: Modules ▸ DDQ opens a page titled Due Diligence Questionnaires. Open a DDQ and a library entry and check the first step of the trail.
assignee: steve
label:
- feature
priority: low
task_status: done
---
Sprint 85, DDQ-2. From Steve (2026-10-24): "change the display name of the page to Due Diligence Questionnaires, leave the menu item as DDQ."

**Chain:** independent (frontend only)

## What people see

- Modules ▸ **DDQ** in the menu is unchanged.
- The page at `/ddq` has the header **Due Diligence Questionnaires**, and the browser tab reads "Due Diligence Questionnaires · Compass".
- The trail (breadcrumb) on a DDQ page and on a Q&A library entry starts with "Due Diligence Questionnaires".
- The assigned-question page an assignee opens from Actions doesn't change; its trail starts at Actions.

## My calls

- Spelled "Diligence" (one l).
- The trail uses the long name, to match the page title. Individual DDQs keep "DDQ-7" as their reference.

## Notes (technical)

- The page header and document title on `DdqPage`, and the trail home label in the trail routes; nav label untouched.
- IA brief: Modules table row label and the DDQ paragraph mention the page title.
- Update the page and trail tests that assert "DDQ" as the heading.

**Done when:** the menu says DDQ, and the page, tab title and trail say Due Diligence Questionnaires.