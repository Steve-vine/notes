---
id: 01M88C7ENKR65HCZQVTSX39CR5
created: 2026-11-25T03:33:12.499743Z
updated: 2026-11-25T03:33:18.099428Z
type: task
title: The incident register's Business service filter shows only to people who can view the inventory, so it doesn't fail for others
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2160
sprint: ss3ttbb
assignee: steve
label:
- bug
priority: high
task_status: active
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