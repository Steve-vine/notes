---
id: 01KXGWTN6RYF6AFVX4M7VH7ZY0
created: 2026-07-14T18:04:34.392541889Z
updated: 2026-07-14T18:05:43.942467204Z
type: task
title: 'In-app site-grant wizard: grant Sites.Selected access from Admin → Integrations'
task_status: done
priority: medium
assignee: steve
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 135
sprint: ssdk92z
label: null
---
Removes the last terminal step in M365 onboarding (`scripts/m365/grant_site.py`). The `Sites.Selected` per-site grant requires `Sites.FullControl.All`, which Compass deliberately doesn't hold — so the wizard borrows the **admin's own** rights for one call via a delegated OAuth flow, keeping the app's standing permission at least-privilege `Sites.Selected`.

**Flow (Admin → Integrations → Microsoft 365 → "Site access")**

1. Admin enters the SharePoint site URL (e.g. `https://<tenant>.sharepoint.com/sites/ISMS`) and picks read/write.
2. "Sign in to grant" opens the Microsoft **authorization-code + PKCE** popup — the admin authenticates as themselves with delegated `Sites.FullControl.All` scope.
3. Backend exchanges the code, uses the delegated token **once**: resolve the site id (`GET /sites/{hostname}:{path}`), `POST /sites/{id}/permissions` for the Compass client id, then **discard the token** (no refresh token requested or stored).
4. Wizard confirms, and the panel lists current grants (`GET /sites/{id}/permissions` during the same delegated session) so the state is visible.

**Backend**

* Endpoints (admin-only): start-auth (returns the Microsoft authorize URL + PKCE state), callback/exchange, grant, list-grants. State/PKCE verifier server-side (session or short-lived store); validate `state`.
* The delegated token is used in-request and never persisted — this is the security property that makes the wizard acceptable.
* Reuses `get_m365_config()` for tenant/client id; clear errors when the integration isn't configured yet (do <issue id="bd166d88-8666-4655-98c3-f91d0c09dec2" href="https://linear.app/stevevine/issue/DEV-772/admin-managed-m365-credentials-configure-the-graph-integration-in-app">DEV-772</issue>'s panel first).
* Failure surfacing: admin lacks SharePoint-admin rights → the Graph 403 message inline; consent not granted for the delegated scope → point at the registration's API permissions.

**Entra prerequisites (document in scripts/m365/README + the panel)**

* The app registration gains a **redirect URI** (`https://<compass-host>/api/v1/integrations/m365/callback` — SPA vs Web: Web, since the backend exchanges the code) and the **delegated** `Sites.FullControl.All` permission (admin-consented). App-only permissions unchanged.

**Out of scope**

* Revoking grants from the app (list + link to the script is enough initially).
* Any storage of delegated/refresh tokens.

`scripts/m365/grant_site.py` stays as the headless/automation path; the README gets updated to present the wizard as the primary route.

---
*Migrated from Linear [DEV-778](https://linear.app/stevevine/issue/DEV-778/in-app-site-grant-wizard-grant-sitesselected-access-from-admin) · created 2026-07-02 · completed 2026-07-02*  
*Related to (Linear): DEV-758, DEV-772*