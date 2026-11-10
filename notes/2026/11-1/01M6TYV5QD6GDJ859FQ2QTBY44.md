---
id: 01M6TYV5QD6GDJ859FQ2QTBY44
created: 2026-11-07T12:13:29.197693Z
updated: 2026-11-10T11:41:08.36609Z
type: task
title: Core connections' credentials join the Secrets register too — Microsoft/Entra, Exchange, AWS, Azure, Google, Active Directory, mail, SSO, the attachment store and Polaris's provider key — as COM-1625 did for Collection accounts
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1639
comments:
- id: 01M72C1YR6E7SCG9CFBM6XND1M
  author: Steve Vine
  at: 2026-11-10T09:19:03.942214Z
  text: |-
    **Done: merged to main in PR #1674** (81bb70d9, migration 0799_secret_compass_credential).

    **What it does:**
    - **Every credential Compass's own connections sign in with is now a secret in the register,** made by Compass:
      - the Microsoft Graph and Microsoft 365 app secrets;
      - the Exchange Online certificate;
      - single sign-on's app secret;
      - the Active Directory password;
      - AWS access keys (the identity Compass runs as, each account and each organisation);
      - Azure client secrets (subscriptions and tenants);
      - Google service account keys (projects and organisations);
      - the mail transport;
      - the Nessus and Aikido keys;
      - the attachment store's key;
      - Polaris's provider keys.
    - **Which register:** a company's own connection (an AWS account, an Azure subscription, a Google project) is in that company's register. Everything organisation-wide is in the **default company's** register, as you chose. There's no new screen.
    - **Names and owners:** each is named for its connection, e.g. "Production: Compass's AWS access key", kept "Compass ▸ Admin ▸ Integrations ▸ AWS ▸ Production", and owned by whoever last put the credential in. The register holds nothing of the value.
    - **Expiry, where Compass can read it:**
      - an Entra app secret's end date, when Compass's app has exactly one secret;
      - a Google key's expiry;
      - the Exchange certificate's end date.
      - An AWS key doesn't expire; its age counts from when AWS made it.
      - **Otherwise each connection's set-up tab has an "In the Secrets register" panel** with the secret's number, company and expiry. It asks once, "It expires on" or "It doesn't expire", where Compass can't read it.
    - **No duplicates:** a key someone had already registered from Discovered becomes Compass's, not a second secret.
    - **A new credential is recorded as a rotation.** A connection removed, or no longer holding a credential (an AWS account switched to a role, say), retires its secret with its history. The register won't let anyone retire it by hand while the connection still uses it.
    - It keeps up whenever a credential is saved, changed or removed, and on every deploy.
    - ADR 0141 amended.

    **Not covered:**
    - Credentials given to Compass by environment variable rather than on screen. Compass doesn't hold those.
    - The Core GitHub connection's app key. It wasn't in the task's list; it would be a small follow-on.

    **Tests:**
    - New integration tests against real Postgres:
      - an AWS account's key: registered, rotated, retired;
      - a registered Azure secret adopted, with Entra's end date;
      - a Polaris key in the default company, with the page's ask and the register's refusal to retire it.
    - A frontend test for the panel.
    - Locally: the unit suite (2046) and 305 integration tests across the connection areas passed. CI passed.

    **To look at on staging** (after the deploy): Secrets, default company (Test Company on staging), shows "Compass's …" secrets for Microsoft, Polaris, mail and so on, and each company's AWS, Azure and Google keys show in that company's register. A connection's set-up tab, e.g. Integrations ▸ Nessus ▸ Set-up, shows "In the Secrets register", asking for the expiry where it isn't known. The deploy's import job registers the existing credentials.
assignee: steve
label:
- feature
priority: medium
task_status: done
---
Split from COM-1625 (sprint 107), which put every **Collection** account's key in its company's Secrets register: made by Compass, expiry typed in or read from the service, reminded through the register, a new key recorded as a rotation, retired with the account.

**Core connections hold credentials too**, each in its own settings model (found 2026-11-07):

| Credential | Model |
|---|---|
| Entra app secret or certificate (Graph) | `entra_settings`, `m365_settings` |
| Exchange Online | `exchange_settings` |
| AWS keys | `aws_connection` |
| Azure | `azure_connection` |
| Google service account key | `gcp_connection` |
| AD service account password | `active_directory_settings` |
| Mail transport | `email_transport` |
| SSO | `sso_settings` |
| Scanner | `scanner_settings` |
| Attachment store | `attachment_store_settings` |
| Polaris provider key | `polaris` |

## Done when

- Each holds a secret in the register like a Collection account's key, using `core/secrets/own.py` generalised from one link column to a kind and an id, or a column each.
- Compass reads the expiry where it can:
  - an Entra app secret's `endDateTime` (Entra app secrets are already a Secrets source, so match rather than duplicate);
  - an AWS access key's age, with no expiry date;
  - a Google service account key's `validBeforeTime`.
- Otherwise the person is asked once, on the connection's page.
- A replaced credential is a rotation; a removed connection retires its secret.
- Organisation-wide credentials (SSO, mail, Polaris) need a home: the register is per company. Decide whether they go in the default company's register or in an organisation-level view. That's a question for Steve.
- An ADR 0141 amendment.