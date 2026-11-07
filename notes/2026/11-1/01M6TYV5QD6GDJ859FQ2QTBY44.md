---
id: 01M6TYV5QD6GDJ859FQ2QTBY44
created: 2026-11-07T12:13:29.197693Z
updated: 2026-11-07T12:13:29.197693Z
type: task
title: Core connections' credentials join the Secrets register too — Microsoft/Entra, Exchange, AWS, Azure, Google, Active Directory, mail, SSO, the attachment store and Polaris's provider key — as COM-1625 did for Collection accounts
assignee: steve
priority: medium
task_status: todo
label: feature
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1639
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