---
id: 01M6HR9DYQNBZJDG8QK5XCM0WQ
created: 2026-11-03T22:25:46.455721Z
updated: 2026-11-04T02:24:50.687608Z
type: task
title: Read Azure Key Vault — the secrets in every vault Compass can reach (names, dates, expiry, tags, never values), onto Secrets ▸ Discovered; a vault Compass can't read says why and what to grant
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1570
sprint: sjrd5gz
blocked_by:
- 01M6HR8Z8FVJECPZS7P5B737GE
assignee: steve
label:
- feature
priority: high
task_status: active
---
Sprint "Secrets - New Module" (ADR 0141, COM-1563). Builds on COM-1569. It follows the Azure connection (ADR 0103), whose §10 named Key Vaults as later.

## What people see

- **Secrets ▸ Discovered** also lists Key Vault secrets, with the same choices as AWS (make a secret, add to one, discard). Each row shows:
  - vault, subscription and name;
  - enabled or not;
  - created, **last changed**, **expires** and not-before;
  - content type and tags.
- **Expiry.** A Key Vault secret's expiry, if set, becomes the secret's expiry when someone makes a secret from it. A registered secret's expiry follows the vault's when the vault's is earlier.
- **Managed by Azure.** Secrets that only exist to back a Key Vault certificate are set aside under **"Managed by Azure (n)"**, as AWS's are.
- **A vault Compass can't read** is listed under **Vaults Compass can't read**, with the reason and the fix:
  - *"Uses access policies"*: "Add an access policy for Compass's app with **List** on secrets, and nothing else."
  - *"No permission"*: "Re-apply the Compass role (it now includes reading secret metadata)."
  - *"Not reachable"*: "The vault's firewall or private endpoint blocks Compass."
- Gone entries, the health message and the Kept in card behave as for AWS (COM-1569).

## Notes (technical)

- Role file (`azure_role.py`, and the shipped role definition):
  - add `Microsoft.KeyVault/vaults/read` to Actions;
  - add `Microsoft.KeyVault/vaults/secrets/readMetadata/action` to **DataActions**. This is metadata only, the same as the built-in Key Vault Reader.
  - **Test that `Microsoft.KeyVault/vaults/secrets/getSecret/action` and any `*` DataAction are never present.**
- The data plane is the vault's own endpoint (`https://<vault>.vault.azure.net`), using a token for the `https://vault.azure.net` resource, not the ARM token. List secrets, then versions, and read attributes only (`attributes.created/updated/exp/nbf/enabled`, `tags`, `contentType`, `managed`).
- A 403 on an access-policy vault versus an RBAC vault: tell them apart by the vault's `enableRbacAuthorization`. A network block shows as a 403 with `ForbiddenByFirewall`, or a connect error.
- Store entries are kind `azure_key_vault`. Cloud text is untrusted.
- Real check: a throwaway vault and secret in the staging subscription, read locally.

**Chain:** on the chain (migration and API).

**Done when:**
- A local read against the staging subscription lists the throwaway secret with its expiry, and no value is logged or stored.
- On staging, in E2E Test Company, a seeded Key Vault entry made into a secret carries its expiry through to Next due.
- The live read is **Couldn't check** in pre-UAT. Steve checks it on a company with an Azure connection, after re-applying the role.