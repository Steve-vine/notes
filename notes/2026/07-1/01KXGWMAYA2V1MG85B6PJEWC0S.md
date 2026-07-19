---
id: 01KXGWMAYA2V1MG85B6PJEWC0S
created: 2026-07-14T18:01:07.274884372Z
updated: 2026-07-19T21:30:30.737235721Z
type: task
title: 'Admin-managed M365 credentials: configure the Graph integration in-app'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 134
sprint: ssdk92z
assignee: steve
task_status: done
priority: medium
---
Today the M365/Graph integration (managed content, ADR 0034) is configured only via env vars / chart secrets (`M365_TENANT_ID/CLIENT_ID/CLIENT_SECRET`), so wiring the tenant means editing the Helm values and redeploying. Instead: once the Entra app registration exists, an admin should be able to paste the three values into the **Admin** section and managed content just works — no redeploy.

**Backend**

* A DB-backed integration-settings store (e.g. an `integration_settings` table or a focused `m365_settings` singleton row): `tenant_id`, `client_id`, `client_secret`.
* **Secret handling**: `client_secret` encrypted at rest (e.g. Fernet keyed off `SESSION_SECRET_KEY` — decide in the PR/ADR if this warrants one); API is **write-only** for the secret (read returns a set/unset flag or last-4 hint, never the value); covered by the log-redaction list.
* `core/graph.py` resolves config as **DB first, env-var fallback** (env keeps working for 12-factor deployments); the token cache invalidates when the settings change.
* Admin-only endpoints: `GET` (masked) / `PUT` the settings, plus a **test-connection** action that acquires a token and reports success/failure with the Graph error message — so the admin knows immediately whether the registration + consent are right.

**Frontend (Admin section)**

* An "Integrations" / "Microsoft 365" panel: tenant id, client id, client secret (password field, placeholder showing "configured" when set), Save, and **Test connection** with the result inline.
* Managed-content create flow: when the integration is unconfigured, point users at the Admin panel (instead of the bare 503 message).

**Notes**

* `Sites.Selected` site grants remain an Entra-side operation (`scripts/m365/grant_site.py`) — this issue covers only the app credentials.
* Multi-worker note: the worker/beat also read these settings; DB-backed means all processes agree without env drift.

---
*Migrated from Linear [DEV-772](https://linear.app/stevevine/issue/DEV-772/admin-managed-m365-credentials-configure-the-graph-integration-in-app) · created 2026-07-02 · completed 2026-07-02*  
*Related to (Linear): DEV-778*