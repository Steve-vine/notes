---
id: 01KZRTWV506ZKNTAZWW0RHWY6P
created: 2026-08-11T16:36:07.968625Z
updated: 2026-08-11T16:36:07.968625Z
type: task
title: 'Business Services page: make it usable'
label: bug
priority: medium
assignee: steve
task_status: backlog
project: 01KX671DATY39VW6GWK3M2T3DN
number: 657
---
The page cannot currently be used at all. The "Composed of" MultiSelect is fed by `/api/v1/applications`, which returns nothing, and Create stays disabled while no application is selected (`BusinessServicesPage.tsx:229,242`) — so the field reads as broken when it is merely empty. Zero `business-service` entities exist.

- Composer offers **Business Applications** (post-rename)
- Empty state explains the prerequisite and links to Business Applications, instead of presenting a dead field
- Rename throughout page, nav and copy
- Keep the non-customer-facing fault banner (ADR 0073 §7 — there are no test Business Services)
- Verify the rollup end to end: a Resource going red reaches its Business Applications and then the Business Services above them

This is the task that closes the loop the sprint opened with — the reported symptom that started the design.