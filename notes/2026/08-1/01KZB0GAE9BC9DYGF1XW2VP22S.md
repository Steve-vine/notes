---
id: 01KZB0GAE9BC9DYGF1XW2VP22S
created: 2026-08-06T07:44:47.04952Z
updated: 2026-08-07T10:38:11.330103Z
type: task
title: Expiring secrets
project: 01KX671DATY39VW6GWK3M2T3DN
number: 577
sprint: setdxf2
trashed: 2026-08-06T07:56:40.50264Z
assignee: steve
label: null
priority: medium
task_status: todo
---
Can we pickup expiring secrets in Azure App Registrations, and surface them as incidents. Any App registration with a secret expiring in the next 90 days should be considered a low severity observation, 60 days a medium and 30 days a high, expired is a critical.