---
id: 01KZ3Q8MBGJXP3DAFR65R6EWVY
created: 2026-08-03T11:48:36.848493Z
updated: 2026-08-07T10:07:02.100415Z
type: task
title: Pack upload, validation and management screen
project: 01KX671DATY39VW6GWK3M2T3DN
number: 501
sprint: s1mg25q
assignee: steve
priority: medium
task_status: backlog
---
The pane-of-glass slice first: upload a pack YAML in Settings, schema-validate it server-side (errors shown inline), list installed packs with version + status. Installed packs appear as Integration Types in the existing add-integration picker (registry-backed, like `mcp_evidence`); an instance then gets credentials via the generated form for free. Storage in the DB (packs are runtime artefacts, not release artefacts).