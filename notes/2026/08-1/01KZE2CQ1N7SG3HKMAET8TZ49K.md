---
id: 01KZE2CQ1N7SG3HKMAET8TZ49K
created: 2026-08-07T12:15:29.333482Z
updated: 2026-08-07T12:16:23.706813Z
type: task
title: 'Named boards: create boards and arrange services on them'
project: 01KX671DATY39VW6GWK3M2T3DN
number: 608
sprint: srhh7w7
assignee: steve
label:
- feature
priority: medium
task_status: backlog
---
Introduce the `dashboard_board` entity + `dashboard_board_service` M2M (per-board `display_order` on the join), drop `dashboard_service.display_order`, add `dashboard_board_token.board_id` (schema only this task). Data migration creates board "Main" holding all existing services (old order) and attaches all existing tokens — populated migration test is the TV-URL back-compat proof. Boards CRUD + membership PUT (literal segments registered before `/{service_id}`; delta-reconcile memberships in place). /dashboards becomes tabbed (one tab per board + "All services" with board badges and orphans), BoardsManageModal, ServiceModal board MultiSelect. ADR 0053 amendment block. OpenAPI regen in-branch.

Acceptance: an operator can create/rename/reorder/delete named boards from /dashboards; place one service on several boards, reorder per board, remove from one without touching others; see every service (incl. orphans) on All services; an upgrader finds all prior services and tokens on "Main" in the old order; deleting a board warns its wallboard URLs die and its services remain.