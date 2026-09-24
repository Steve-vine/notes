---
id: 01M2GDN2PFGVM8FND05VJ3WNCM
created: 2026-09-14T16:57:52.079485Z
updated: 2026-09-24T21:00:31.523213Z
type: task
title: The chart generates its own secrets and preserves them across upgrades
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 709
sprint: stek6vx
blocked_by:
- 01M2GDMSMHN86CY7DTARVT6CKM
comments:
- id: 01M2GSV96TQ1J0JBV0NERQCZFN
  author: Steve Vine
  at: 2026-09-14T20:30:58.266506Z
  text: |-
    Merged to main 2026-09-14 20:31 as 4082d20 (PR #719). `compass.generatedSecretValue` helper: explicit value wins, else the value in the live Secret via lookup, else 48 random chars; SESSION_SECRET_KEY uses it, so an inline install needs only databaseUrl. The Secret stays the weight-5 pre-install/pre-upgrade hook — the lookup runs at render, before the before-hook-creation delete, so the recreated Secret carries the old value. The lookup trap (helm template / client dry-run / ArgoCD render = fresh key every reconcile) is documented in the helper, values.yaml, README and NOTES, which print the value to back up. secretbox.py docstring corrected (not a session key; only consumer).

    Verified with `helm install --dry-run=server` on g5 (scratch namespace): no Secret → generated; Secret with KNOWN-KEY → KNOWN-KEY; explicit → wins; `helm template` → fresh (the trap). Byte-identical across three real upgrades is exercised by the next staging promotions (staging keeps its explicit key, so behaviour there is unchanged).
assignee: steve
label:
- improvement
priority: high
task_status: done
---
ADR 0073 §4. A minimal install should need one value — a database URL — not a hand-invented signing key.

**Generate when absent**: `SESSION_SECRET_KEY`, and the password for any component the chart bundles. Every generated value keeps an explicit override.

**`SESSION_SECRET_KEY` is mislabelled today** and the comment must be corrected while we are here. It does not sign session cookies — session ids are opaque random tokens looked up in Valkey, and nothing is signed. Its only job is being the Fernet key in `core/secretbox.py` that encrypts **every integration credential an administrator enters into the app**: M365, Entra, SSO and the ADR 0044 email transports. Change it and all of them become undecryptable, surfacing merely as "not configured".

**The trap this must avoid.** The standard pattern is `lookup` the existing Secret on upgrade and reuse its value, generating only when missing. But **`lookup` returns nothing during `helm template` and `--dry-run`** — so `helm template | kubectl apply`, or ArgoCD in manifest-rendering mode, generates a fresh key on *every reconcile*, silently orphaning every stored credential with no error anywhere. The override exists for exactly this case and the values file and README must say so in as many words.

There is also an ordering interaction: the app Secret is currently a `pre-install`/`pre-upgrade` hook (weight 5) so the migration Job can read it. Generation has to keep working within that, and `before-hook-creation` must not delete-and-regenerate the value.

**Acceptance**: `helm install` with only `DATABASE_URL` supplied produces a working Compass; `helm upgrade` three times leaves `SESSION_SECRET_KEY` byte-identical; a stored integration credential still decrypts after an upgrade; the override is documented alongside the GitOps warning.