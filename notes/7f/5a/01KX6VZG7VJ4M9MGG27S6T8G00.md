---
id: 01KX6VZG7VJ4M9MGG27S6T8G00
created: 2026-07-10T20:37:20.251777522Z
updated: 2026-07-11T10:23:04.227107279Z
type: task
title: OpenAPI → frontend type generation in the build
assignee: steve
task_status: review
priority: medium
project: 01KX671DATY39VW6GWK3M2T3DN
number: 16
blocked_by:
- 01KX6VYVZB059CVZ6EBTGJSYAY
sprint: sqtx330
---
Generate frontend API types from the backend's OpenAPI schema as part of the build (ADR 0007/0009); regenerating becomes part of any API-changing PR, drift fails the frontend type-check.