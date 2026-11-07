---
id: 01M6PVEM1AZX50AJWXD9Z0ZSMZ
created: 2026-11-05T21:57:14.410645Z
updated: 2026-11-07T08:55:26.006367Z
type: task
title: Collection integrations — Admin ▸ Integrations shows Core and Collection apart; a person with Manage integrations defines a read-only service on screen (address, sign-in, paging, test read) and adds one or more named accounts to it, each with its own company and key
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1596
sprint: s1jcke1
blocked_by:
- 01M6PVDTTX6KZBCPXSXY1XXDW3
comments:
- id: 01M6PZ58K47Y8VYXZV4N673BD3
  author: Steve Vine
  at: 2026-11-05T23:02:02.084026Z
  text: |-
    Done: PR #1612 merged. This one is on the chain: migration 0785.

    What's there:
    - **Admin ▸ Integrations** shows **Core** and **Collection** as two groups, each tile labelled. Search, Installed/All, and a new *Collection* category option cover both.
    - **Add a Collection integration** (needs Manage integrations; one person, no second approval):
      - name, API docs link and an https address;
      - sign-in: API key in a header, bearer token, username and password, HTTP digest, or OAuth client credentials;
      - paging: none, page numbers, offset, cursor, or next link;
      - where the items are, and a test read.
    - **A Collection tile** has three tabs:
      - Overview: what it reads, docs, who added it;
      - Accounts: follows the company picker;
      - Settings: the definition, plus Delete.
    - **Accounts:** any number, each with a name and a company. The secret is write-only: only "…mnop · set on 5 Nov" is shown. Test says what came back ("Signed in. The test read answered with: scopes") or why it failed ("The service refused the sign-in (401)").
    - **Saving a definition re-tests every account.**
    - **Reads only, internet only:**
      - GET only;
      - every address must be https and public, at save and on every request;
      - the connection is pinned to the checked address;
      - no redirects followed, and next-page links must stay on the service;
      - every page or nothing (50,000 items / 20 MB);
      - throttling retried.

    My calls:
    - **Test runs in the API, not the worker.** Collection services are internet-only, so the worker isn't needed; the GitHub tile does the same.
    - **Category filter.** Collection integrations have a category of their own, "Collection", rather than a cloud or security category.
    - **The last four of a secret are only shown if it is at least 12 characters**, so a short secret isn't half given away.

    Tested: 28 unit tests for the client (all sign-ins including digest; every paging style, including a service that sends fewer than asked; caps; retries; private addresses; DNS answers mixing public and private), 2 API integration tests, 4 Vitest.

    To check on staging: add SendGrid by hand (bearer, `https://api.sendgrid.com`, test read `/v3/scopes`), with two accounts for two companies.
- id: 01M6RBDF9RM43C1DH6771CPEB8
  author: Steve Vine
  at: 2026-11-06T11:55:28.439855Z
  text: |-
    Pre-UAT, as E2E Admin A in E2E Test Company: Passed, except the two-companies part, which is Couldn't check.

    What I did and saw:
    - **Gallery.** Admin ▸ Integrations shows Core (labelled "Built into Compass") and Collection ("Read-only services … added on this screen") as separate groups, each tile labelled.
    - **Added by hand.** "E2E SendGrid (test)": bearer, `https://api.sendgrid.com`, test read `/v3/scopes`. The tile sits under Collection.
    - **Refused addresses.**
      - `http://10.0.0.1` → "The address must start with https://".
      - `https://10.0.0.1.nip.io` (resolves to a private address) → "Compass can only reach services on the internet".
    - **The key.** The account's key shows only as "…wxyz · set on 6 Nov 2026" and is never shown again.
    - **Test.** With a fake key, staging reached SendGrid and said "The service refused the sign-in (401). Check the key."
    - **A green test.** A second service, "E2E GitHub public (test)" (API key in a header, against GitHub's public API), tested green: "Signed in. The test read answered with: login, id, node_id, …".

    Couldn't check:
    - a real SendGrid key, and two companies: I only use E2E Test Company.

    For Steve: add the real SendGrid with a read-only key, and an account for a second company. The two E2E test services can be deleted afterwards.

    Screenshots: ~/compass-uat/s1jcke1/COM-1596/
assignee: steve
label:
- feature
priority: high
task_status: done
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