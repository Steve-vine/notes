---
id: 01M88C7ENKR65HCZQVTSX39CR5
created: 2026-11-25T03:33:12.499743Z
updated: 2026-11-25T09:17:49.965056Z
type: task
title: The incident register's Business service filter shows only to people who can view the inventory, so it doesn't fail for others
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2160
sprint: ss3ttbb
comments:
- id: 01M88DBM00Q7KN71MV0RRGJ75K
  author: Steve Vine
  at: 2026-11-25T03:52:57.600525Z
  text: |-
    Built and merged to main: PR #2156 (eabef231e). Screen only.

    What people see:
    - People who can view the inventory still see the incident register's Business service filter. People who can't (e.g. an Analyst) see no filter and the register makes no services request. A service left in the address doesn't narrow their register.
    - On an incident's Service impact card, "Add a service" offers business services and systems to people who can view the inventory, and systems only (labelled "System") to everyone else.
    - Found while checking every screen that loads the services list:
      - A risk's Business services card is read-only (no picker, no unlink, no request) for someone who manages risks but can't view the inventory.
      - A document's Business services card now loads services only when the person can both view and manage the inventory.
    - Already correct and left alone: the risk register filter, the engagement form's services field, the service page and its cards, the BIA services card, and incident suggestions.

    Tested: Vitest for an incident viewer without inventory (no filter, no request, even with a service in the address), an admin (filter and request), the picker without inventory, and the risk card read-only. CI green.

    For Steve to decide:
    1. Without inventory access, the incident register ignores a service in the address. The risk register still filters by it and shows the filter so it can be cleared.
    2. The risk card is fully read-only for a risk manager without inventory access, so they can't unlink either.

    Not checked yet: the Browser smoke after redeploy (it should now pass for the Analyst).
- id: 01M88J4R46D3R2Q6MFPEDDM0M3
  author: Steve Vine
  at: 2026-11-25T05:16:35.333991Z
  text: |-
    Pre-UAT recheck on staging 82c0bf7e4 (Browser smoke 41/41, Analyst included): **Passed**.
    - E2E Analyst: the incident register has no Business service filter, no services request and no console errors. On INC-144, "Add a service" is labelled "System" and lists systems only, with no failed request.
    - E2E Admin A: the filter is still there, and the picker reads "Business service or system" with business services first.
    - TAS's Incidents card still lists INC-144 and INC-125.
    Screenshots: ~/compass-uat/ss3ttbb/COM-2160/recheck-*
assignee: steve
label:
- bug
priority: high
task_status: done
---
Sprint "Business Services". Found by the Browser smoke on staging a63d542b2 (25 Nov 2026, run 45538339299): "every screen opens for analyst › Incidents ▸ Register" failed with `GET /api/v1/business-services?company=… → 403`.

## The problem
COM-2154 added a Business service filter to the incident register. It loads the company's services list, which needs View inventory. An Analyst can see incidents but not the inventory, so the register's services request is refused, and the screen logs a failed request. The risk register's filter (COM-2153) already shows only to people who can view the inventory.

## What people see
- People who can view the inventory see the incident register's Business service filter as now.
- People who can't don't see the filter, and the register makes no request for services. Everything else on the register works as before.
- The same holds anywhere else an incident screen loads the services list for someone without inventory access (e.g. the Service impact card's picker). Check and fix those too.

## Done when
- The Browser smoke's "every screen opens" passes for every account, Analyst included.
- An Analyst's incident register shows no Business service filter and no failed request. Admin A still has the filter.

Independent: screen only (no migration or API change).