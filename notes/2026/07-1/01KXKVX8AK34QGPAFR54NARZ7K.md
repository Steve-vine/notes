---
id: 01KXKVX8AK34QGPAFR54NARZ7K
created: 2026-07-15T21:46:14.227124823Z
updated: 2026-07-16T10:37:51.448771547Z
type: task
title: Manual issue creation in the UI
task_status: active
label:
- feature
sprint: syqgx3z
number: 81
project: 01KX671DATY39VW6GWK3M2T3DN
---
Operators can't raise a manual issue from the UI. The Issues screen is read-only (list + filters); its header even references "manually raised problems" but offers no control to create one. Today the only path is calling the API directly with an operator token.

**Backend already exists** — `POST /api/v1/issues` (operator-gated) creates an issue with `source="manual"` (the model defaults source to `manual`). Request fields: `title` (required), `severity` (required, `info|low|medium|high|critical`), `description` (optional), `system_id` (optional), `evidence` (optional). `created_by` comes from the auth'd user.

**Work is frontend-only:**
- "New issue" button on the Issues screen (`IssuesPage.tsx`).
- Modal/form: title, severity, description, optional system picker.
- Wire to `api.POST('/api/v1/issues')` (already in the generated typed schema, never invoked today), refresh the list on success.

Result: manual issues appear alongside Promoted/AI in the same queue.