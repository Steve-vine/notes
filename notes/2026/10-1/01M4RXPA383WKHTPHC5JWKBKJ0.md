---
id: 01M4RXPA383WKHTPHC5JWKBKJ0
created: 2026-10-12T20:43:28.744202Z
updated: 2026-10-15T09:06:18.820371Z
type: task
title: An Inventory admin switches on server discovery for a company — chooses which parts of the directory hold its servers, tests it, and can switch it off
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 933
sprint: surilj1
blocked_by:
- 01M4RXNV6C8JDR1TGK4G3GRZFM
- 01M4RTZRQ8A0F3GKW8FVGHZ69Z
assignee: steve
label:
- feature
priority: high
task_status: active
---
Part of sprint 66, Inventory discovery - On-prem (ADR in COM-932). This is the switch and its scope only. Nothing is read until the next task.

## What people see

- **Inventory ▸ Settings gains "Servers from the directory"** for the current company, below the cloud cards. It is off until someone switches it on.
- **Switching it on asks for** a name, which OUs hold this company's servers, and whether what is found there is Production or Non-production. OUs are ticked on a tree; ticking one includes everything beneath it; the whole domain can be ticked.
- **There is no key to enter.** Compass uses the directory connection an admin already set up on Admin ▸ Integrations. If that is not set up or not healthy, the card says so and says where to fix it.
- **Test** says how many servers it would find in the chosen OUs and how many computer accounts it would leave out as not being servers, or why it could not look, in the plain words the directory card already uses.
- **The health pill** follows the directory connection: there is nothing separate here that can break.
- **The OUs can be changed under Edit.** A server in an OU that is unticked is treated as one that has gone.
- **Switching it off asks first** and says what happens: servers already attached to technology assets stay, marked "no longer read"; anything still awaiting a decision goes.
- **One per company.** Two companies can each switch it on and choose different OUs.
- **In Entra ID only** there is no Active Directory to choose from. The card says so until the Entra task at the end of this sprint lands.
- **Who:** Inventory admins.

## Notes (technical)

- **Blocked by COM-925** as well as the ADR: this is a fourth source, and it should arrive as one more child of `discovery_connections`, not a fourth nullable column. If the GCP sprint has not started when this one does, build COM-925 first; it stands alone.
- **`directory_server_connections`**, company-scoped, unique per company, the usual mixins: `name`, `default_environment`, `ou_dns` (the ticked OUs), and the read columns in the shape the other connections hold. No secret column.
- **`PROVIDER_DIRECTORY`**, and an entry in `core/discovery/sources.py`. `account_ref` is the domain's DNS name (the tenant ID in Entra ID only), so "Found in" reads as the domain.
- **The tree comes from the OUs Compass already mirrors** (`DirectoryOu`); nothing new is read to draw it.
- **Test** is a count-only search with the server filter the reader will use, through `core/active_directory.py` (LDAPS or Kerberos, whichever the directory card chose). OU names reach the filter only as mirrored rows; anything typed is escaped.
- **Health** reads the directory connection's own state. No beat task of its own.
- **API.** `/api/v1/inventory/directory-connections` (get, create, update, delete, test) under `inventory.admin`. Regenerate `schema.d.ts`.
- **Audit.** The table joins `_AUDITED_TABLES`; read writes are actorless.
- **Screen.** `inventory/DirectoryServersCard.tsx` on the Inventory Settings panel.

**Needs from Steve before smoke-testing:** the Active Directory card on staging filled in and its Test green. That is the same thing sprint 63's smoke test is waiting on.

**Done when:** on staging server discovery is switched on for a company with an OU chosen, Test says how many servers it would find, and switching it off works.