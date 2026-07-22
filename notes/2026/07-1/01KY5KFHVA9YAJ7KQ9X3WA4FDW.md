---
id: 01KY5KFHVA9YAJ7KQ9X3WA4FDW
created: 2026-07-22T19:05:16.394176Z
updated: 2026-07-22T19:18:15.615274Z
type: task
title: Enable/disable an integration from the UI
project: 01KX671DATY39VW6GWK3M2T3DN
number: 221
assignee: steve
label:
- bug
priority: high
task_status: review
---
An integration created through the add-integration flow is born `enabled: false`, and **no screen anywhere can turn it on**. `PATCH /api/v1/systems/{id}` has taken `enabled` since the beginning; nothing calls it.

Latent since the add-integration flow (ISE-146) shipped — the integrations that predate it were enabled another way, so the gap only surfaced when Confluence became the first integration configured entirely in the UI. It is a total dead end for the user: the integration is created, its credential is stored and verified, and it then sits inert with no way forward.

Both surfaces already *display* the state, which is what makes the absence read as a bug rather than a missing feature:

- Settings → Integrations shows a **State** column ("enabled"/"disabled") as plain text.
- System detail shows an **Enabled: Yes/No** row, and its Obs Loop error even says *"Enable the integration in Settings first"* — pointing at a control that does not exist.

Work:

- Add the switch to the Settings → Integrations row (admin-only, mirroring the credential controls beside it), so the column that reports the state is the control that sets it.
- Disabling must be honest about what it stops: sync, detection and actions all check `system.enabled`. Say so at the point of the click rather than letting an integration go quiet for unexplained reasons.
- Audit the change — enabling an integration is what admits a source's data to the estate, and who did that is exactly what the audit log is for.
- Tests: the toggle patches the right field; a non-admin cannot see it; the row reflects the new state.