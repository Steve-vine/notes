---
id: 01KXKTJ3FZSP86JFQYY7PCMV7Y
created: 2026-07-15T21:22:40.255843084Z
updated: 2026-07-24T16:09:36.651712Z
type: task
title: Break-glass status tracking + Settings→Access UI
project: 01KX671DATY39VW6GWK3M2T3DN
number: 76
sprint: sd1gs0p
assignee: steve
priority: medium
task_status: backlog
---
There is **no Settings→Access UI and no `/api/v1/users` endpoint** today. `SettingsPage.tsx` has only Integrations + AI cards. The break-glass account has **no last-verified / last-used / rotation tracking** — the only durable trace of a break-glass event is audit rows.

## Scope

- **Break-glass status tracking**: last-verified, last-used, last-rotated on the model (today `User.last_login_at` is set only as a side effect of the generic upsert). Enough to answer "is break-glass healthy, and when was it last exercised or rotated?"
- **`/api/v1/users`** (admin-only) — no users router exists at all.
- **Settings→Access tab** (ui-brief §8): Entra group→role mapping (read), and break-glass status — *exists / last verified / last used*, **never the credential** (security-model brief).

This is the surface the verification drill (ISE-77) reads and updates. RBAC: admin. Staging-first.