---
id: 01KX6VZG7VJ4M9MGG27S6T8G00
created: 2026-07-10T20:37:20.251777522Z
updated: 2026-07-11T10:23:09.946686823Z
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
comments:
- id: 01KX8B7MKTA0S910V1X5RGZNZJ
  author: Steve Vine
  at: 2026-07-11T10:23:09.946635542Z
  text: 'Development complete on feature/ise-016-openapi-types. PR #19: https://github.com/Steve-vine/ise/pull/19. Hermetic generation: backend dump_openapi.py renders /api/v1 schema with no server/DB (stable sorted output) → committed openapi.json; frontend generate:api runs openapi-typescript (pinned 7.13.0 via npx, isolated from TS6 tree) → committed schema.d.ts; typed openapi-fetch client.ts with aliases for ISE-18; Vite dev proxy added. New CI api-types job regenerates both and fails on any diff — an API change without regeneration can''t merge. Two CI issues found and fixed on-branch: (1) this runner''s git rejects `git diff --exit-status` (usage error, not real drift) — switched to git status --porcelain check; (2) pinned openapi-typescript to exact 7.13.0 so CI/local are byte-identical. Staging pipeline fully green incl. api-types gate. Recommend adding `api-types` to the required status checks on main after merge. Awaiting smoke test + merge clearance.'
---
Generate frontend API types from the backend's OpenAPI schema as part of the build (ADR 0007/0009); regenerating becomes part of any API-changing PR, drift fails the frontend type-check.