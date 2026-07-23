---
id: 01KX6DKAQMQGJ47VAZYJRXHPD2
created: 2026-07-10T16:26:01.332818177Z
updated: 2026-07-23T13:54:54.824769Z
type: task
title: Frontend scaffold — Vite, React, TS strict, ESLint/Prettier, Vitest
project: 01KX671DATY39VW6GWK3M2T3DN
number: 2
sprint: sh9ng2k
comments:
- id: 01KX6FN5P1691MZSF7Z5CJF48Q
  author: Steve Vine
  at: 2026-07-10T17:01:58.849257139Z
  text: 'Development complete on feature/ise-002-frontend-scaffold. PR #4 open against main: https://github.com/Steve-vine/ise/pull/4. Branch merged to staging (1458018, clean merge alongside ISE-1). Verified locally: ESLint + Prettier clean, Vitest 1/1 passed, tsc strict + production build succeed, vite preview serves the ISE page. Notes: npm package named ise-frontend (npm forbids capitals in names); Vitest pinned to v4 for Vite 8 compatibility; TS strict added explicitly (template omits it). Awaiting Steve''s smoke test and merge clearance.'
- id: 01KX6HHK88TNKBTM8X7TT39RYZ
  author: Steve Vine
  at: 2026-07-10T17:34:58.824251429Z
  text: 'Smoke tests passed. PR #4 merged to main (0c2aa88), feature branch deleted. Done.'
assignee: steve
priority: high
task_status: done
---
Scaffold `app/frontend/` (`ISE-frontend`) per ADR 0003/0007: Vite + React + TypeScript strict, npm on Node 22, ESLint + Prettier, Vitest. Consumes only the public `/api/v1`.