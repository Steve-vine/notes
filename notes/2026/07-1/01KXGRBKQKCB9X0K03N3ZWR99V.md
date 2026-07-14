---
id: 01KXGRBKQKCB9X0K03N3ZWR99V
created: 2026-07-14T16:46:27.05966016Z
updated: 2026-07-14T16:46:27.05966016Z
type: task
title: Frontend app shell
label: brief
task_status: done
priority: medium
assignee: steve
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 9
---
Build the React app shell per ADR 0003/0017.

- [ ] React + TS + Vite app; dev server proxying `/api/*` to the backend
- [ ] Left sidebar + top bar (global company switcher, search slot, user menu)
- [ ] Routing + typed API client generated from / aligned to the OpenAPI schema
- [ ] Login screen wired to the auth API; authed/unauthed routing
- [ ] Production build served via nginx (port 8080)

Depends on: Auth, Backend API scaffolding. Refs: ADR 0003, 0004, 0017.

---
*Migrated from Linear [DEV-395](https://linear.app/stevevine/issue/DEV-395/frontend-app-shell) · created 2026-06-13 · completed 2026-06-14*  
*Related to (Linear): DEV-389, DEV-417, DEV-416, DEV-396, DEV-394*