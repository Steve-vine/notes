---
id: 01KXE5TH0QJS9SRJNGKZ975E6F
created: 2026-07-13T16:44:03.991687669Z
updated: 2026-07-23T19:46:00.549639Z
type: task
title: Credential management UI — multi-field secrets and rotation
project: 01KX671DATY39VW6GWK3M2T3DN
number: 56
sprint: sdcd2jr
assignee: steve
priority: high
task_status: done
---
Found while trying to install the g5 write kubeconfig for ISE-53.

**The Settings UI cannot store a real credential.** The "Add integration" form has ONE field, `Credential token`, and writes `{"token": "<value>"}` under the name `<system>-credential`. That shape fits nothing ISE actually connects to:

- Kubernetes needs `{kubeconfig, context}`
- DataDog needs `{api_key, app_key, site}`

And there is **no way to edit or rotate an existing system's credential at all** — the form only creates. So the one credential type the UI can express is a type no connector uses, and the operation you most need (rotation) is the one it cannot do. Every credential on the estate today must have been installed out-of-band.

This matters more now than it did in Phase 2: ISE holds a credential that can CHANGE things. ADR 0018 makes rotation a first-class operation ("create or replace — rotation without downtime"), the API supports it (`PUT /api/v1/credentials`), and the security-model brief says to rotate after any break-glass use or suspected compromise. None of that is reachable from the UI, so in practice it will not happen.

Build:
- Render the credential form from the connector's `credential_spec()` — it already declares its fields, which key is secret, and the labels (`CredentialField.key/label/secret`). The UI should not hard-code any of this; a new connector should get a correct form for free.
- Rotate an existing credential in place (PUT), with the current value masked and never returned (`CredentialRead` has no field for the secret by construction — keep it that way).
- Show which system uses which credential, and when it was last rotated.
- Admin-only, audited (the API already audits every store/reveal).

Interim workaround: `scripts/infra/store-kubeconfig-credential.sh` (uses an admin browser session, so it does not burn break-glass).