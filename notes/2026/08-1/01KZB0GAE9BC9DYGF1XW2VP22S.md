---
id: 01KZB0GAE9BC9DYGF1XW2VP22S
created: 2026-08-06T07:44:47.04952Z
updated: 2026-08-06T07:44:47.04952Z
type: task
title: Expiring secrets
assignee: steve
priority: medium
sprint: sh8mf3h
task_status: todo
project: 01KX671DATY39VW6GWK3M2T3DN
number: 577
---
Can we pickup expiring secrets in Azure App Registrations, and surface them as incidents. Any App registration with a secret expiring in the next 90 days should be considered a low severity observation, 60 days a medium and 30 days a high, expired is a critical.