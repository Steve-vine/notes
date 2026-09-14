---
id: 01M2GDN2PFGVM8FND05VJ3WNCM
created: 2026-09-14T16:57:52.079485Z
updated: 2026-09-14T16:59:39.769271Z
type: task
title: The chart generates its own secrets and preserves them across upgrades
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 709
sprint: stek6vx
blocked_by:
- 01M2GDMSMHN86CY7DTARVT6CKM
assignee: steve
label:
- improvement
priority: high
task_status: todo
---
ADR 0073 §4. A minimal install should need one value — a database URL — not a hand-invented signing key.

**Generate when absent**: `SESSION_SECRET_KEY`, and the password for any component the chart bundles. Every generated value keeps an explicit override.

**`SESSION_SECRET_KEY` is mislabelled today** and the comment must be corrected while we are here. It does not sign session cookies — session ids are opaque random tokens looked up in Valkey, and nothing is signed. Its only job is being the Fernet key in `core/secretbox.py` that encrypts **every integration credential an administrator enters into the app**: M365, Entra, SSO and the ADR 0044 email transports. Change it and all of them become undecryptable, surfacing merely as "not configured".

**The trap this must avoid.** The standard pattern is `lookup` the existing Secret on upgrade and reuse its value, generating only when missing. But **`lookup` returns nothing during `helm template` and `--dry-run`** — so `helm template | kubectl apply`, or ArgoCD in manifest-rendering mode, generates a fresh key on *every reconcile*, silently orphaning every stored credential with no error anywhere. The override exists for exactly this case and the values file and README must say so in as many words.

There is also an ordering interaction: the app Secret is currently a `pre-install`/`pre-upgrade` hook (weight 5) so the migration Job can read it. Generation has to keep working within that, and `before-hook-creation` must not delete-and-regenerate the value.

**Acceptance**: `helm install` with only `DATABASE_URL` supplied produces a working Compass; `helm upgrade` three times leaves `SESSION_SECRET_KEY` byte-identical; a stored integration credential still decrypts after an upgrade; the override is documented alongside the GitOps warning.