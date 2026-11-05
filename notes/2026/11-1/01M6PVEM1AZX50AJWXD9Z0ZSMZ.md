---
id: 01M6PVEM1AZX50AJWXD9Z0ZSMZ
created: 2026-11-05T21:57:14.410645Z
updated: 2026-11-05T22:02:15.167962Z
type: task
title: Collection integrations — Admin ▸ Integrations shows Core and Collection apart; a person with Manage integrations defines a read-only service on screen (address, sign-in, paging, test read) and adds one or more named accounts to it, each with its own company and key
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1596
sprint: s1jcke1
assignee: steve
label:
- feature
priority: high
task_status: todo
---
Sprint "Evidence Collection - Integrations" (ADR 0142, COM-1595). Builds on the Integrations library (ADR 0128). This task makes adding by hand work; the Polaris wizard (later in the sprint) fills the same form for you.

## What people see

- **Admin ▸ Integrations** has two groups, **Core** (today's tiles, unchanged) and **Collection**. Each tile carries its label. The gallery's search and category filter cover both.
- **Add a Collection integration** (needs Manage integrations; one person, no second approval):
  - the service's **name**, a **link to its API documentation**, and its **address** (https only);
  - **sign-in method**: API key in a header (with the header's name), bearer token, username and password, HTTP digest, or OAuth client credentials (with the token address);
  - **paging style**: none, page number, offset, cursor, or next link (in the body or a Link header), with the names of the parameters and of the field holding the items;
  - a **test read**: a path that should answer for any account, such as "who am I" or "list projects".
- **A Collection tile** has three tabs:
  - **Overview:** what it reads, the documentation link, and who added it and when.
  - **Accounts:** one row per account, with name, company, health and last read.
  - **Settings:** the definition above.
- **Accounts.** Add as many accounts as needed, each with a name ("MongoDB – Production"), a company, and its own sign-in details.
  - The key or password is **write-only**: never shown again, only "set on 5 Nov" and the last four characters.
  - **Test** runs the test read and says what came back, or why it failed in words ("401: the key was refused").
  - Accounts follow the company picker, as cloud accounts do.
- **Edit and delete.** Editing a definition re-tests its accounts. Deleting a service, or one account, asks first and says which checks use it (none yet in this task).
- **Reads only, internet only.** A Collection integration only ever makes GET requests, and only to public addresses. An address that resolves to a private or internal one is refused at save and at every request: "Compass can only reach services on the internet".

## Notes (technical)

- These tiles are data, not code. A new table for the definition (`collection_integrations`) and one for its accounts (`collection_accounts`: company-scoped, encrypted secrets via `core/secretbox.py`, health columns like `RegisteredConnectionMixin`).
- The gallery merges `INTEGRATIONS` from `core/integrations/registry.py` with the data rows, adding a `kind: core | collection` field. `summary.py` gains a Collection summariser.
- One request client for every Collection account: sign-in methods with httpx (`DigestAuth` for digest), paging styles, retry on 429/503 honouring Retry-After (copy `core/graph.py` `_send_with_retry`), and the item and size caps from ADR 0142.
  - Address checking copies `core/assets.py` (`_public_address`, connecting to the vetted IP), which also blocks DNS rebinding. Don't copy `security_feed/safe_fetch.py`, which doesn't.
- Name the secret columns so `DEFAULT_REDACT_KEYS` masks them.
- Test runs on the worker's interactive queue (`on_worker`, as scanners do).
- Update `admin.manage_integrations`'s on-screen description: it still says "Entra ID and email".
- Frontend: `integrations/registry.ts` is keyed by a closed union. Collection tiles need a data-driven path through `IntegrationsPage` / `IntegrationPage`.

**Chain:** on the chain (migration and API).

**Done when:** on staging, someone with Manage integrations adds "SendGrid" by hand:
- (bearer token, address `https://api.sendgrid.com`, test read `/v3/scopes`);
- two accounts for two companies, each tests green;
- the tile sits under Collection;
- a key is never shown again;
- an address of `http://10.0.0.1` or one resolving to a private address is refused.