---
id: 01M4RV0AXHZN6WTX3CVTP1XRXF
created: 2026-10-12T19:56:31.537861Z
updated: 2026-10-12T22:25:24.562949Z
type: task
title: An Inventory admin connects a Google Cloud project to a company — tests it, sees its health, and can remove it
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 926
sprint: s70gjk2
blocked_by:
- 01M4RTZRQ8A0F3GKW8FVGHZ69Z
assignee: steve
label:
- feature
priority: high
task_status: active
---
Part of sprint 69, Inventory discovery - GCP (ADR in COM-924). This is the connection only, signing in with a key file. Signing in without a stored key is the next task (COM-931). Nothing is read from the project until the task after that.

## What people see

- **Inventory ▸ Settings gains "Google Cloud projects"** for the current company, below the Azure cards: a list of connected projects with a name, the project ID, a health pill and when each was last read.
- **Adding a project asks for** the project ID, a name, the service account's key file, and whether the project is Production or Non-production. There is no region choice: a project is read whole.
- **Compass shows what to set up on the Google side** as soon as the project ID is typed, before anything is saved: a role file to download and the commands to copy, already filled in for that project. They switch on the one Google service Compass needs to check the project, create the role, create the service account, give it the role, and make its key. The role can list and describe resources. It cannot read what is inside them.
- **If Google refuses to make the key,** the steps say why and what to do: organisations created since 2024 block service account keys by default. Either somebody who administers the organisation's policies allows them for this project, or the project is connected without a stored key (COM-931).
- **Test** says which project it reached, or why it could not, in plain words: the file is not a service account key, the key has been deleted or has expired, the service account is disabled, the project does not exist or the service account has no role on it, the project is being deleted, or the service Compass needs to check the project is not switched on.
- **The key can be replaced under Edit** and is never shown again. The row shows the service account's email address and the key's ID, neither of which is secret, so the person knows which key to revoke in Google.
- **Removing a project asks first** and says what happens: resources already attached to technology assets stay, marked "no longer read"; anything still awaiting a decision goes; Compass deletes its copy of the key.
- **Who:** Inventory admins.

## Notes (technical)

- **`gcp_connections`**, company-scoped, on the shared connection parent from COM-925. `project_id` (unique across the deployment), `project_number`, `client_email`, `private_key_id`, `key_encrypted` (`core.secretbox`; the whole key file), plus whatever is this provider's own.
- **`core/gcp.py`: the one place a request to Google is made.** A JWT signed with the key (RS256, `pyjwt`) exchanged at `oauth2.googleapis.com/token`; the token cached until shortly before it expires and keyed so a replaced key takes effect at once; `get` and `pages` (follows `nextPageToken`), both taking a `fields` mask; 429 and 5xx retried with back-off. `_new_client` is the test seam (httpx `MockTransport`). No Google client library and no new dependency.
- **Where the token comes from is one function**, so COM-931 adds a second source beside it and changes nothing else.
- **The key file is validated on the way in:** `type` is `service_account`, and it carries a private key, a client email and a key ID. Nothing from it but the email and key ID is ever returned or logged. Its column name goes on the redaction list.
- **Errors leave as `GcpError`** with a sentence a person can act on. Google's own text is never passed through. `invalid_grant` covers a deleted key, an expired key and a disabled account; tell them apart where Google's answer allows and say "deleted or expired" where it does not.
- **Health.** `GET cloudresourcemanager.googleapis.com/v3/projects/{id}`; the same check as Test. A beat task every 15 minutes, in the shape of `tasks/azure_health.py`. A project whose state is `DELETE_REQUESTED` is unhealthy and says so.
- **The shipped role.** `docs/gcp/compass-discovery-role.yaml` (the form `gcloud iam roles create --file` takes), generated from the readers' declared permissions and held to them by a test, with `docs/gcp/README.md` for the steps. This task ships `resourcemanager.projects.get`; each reader task adds its own.
- **API.** `/api/v1/inventory/gcp-connections` (list, setup, create, update, delete, test) under `inventory.admin`. The key file is uploaded as text in the body, not as a multipart file. Regenerate `schema.d.ts`.
- **Audit.** `gcp_connections` joins `_AUDITED_TABLES`; health writes are actorless.
- **Screen.** `inventory/GcpProjectsCard.tsx` on the Inventory Settings panel. The card title and every label say "Google Cloud", not "GCP".

**Needs from Steve before smoke-testing:** a Google Cloud project that allows service account keys, and the right in it to create a role, a service account and a key (Owner, or Role Administrator with Service Account Admin and Service Account Key Admin). If the project's organisation blocks keys, this task is smoke-tested together with COM-931.

**Done when:** on staging a Google Cloud project is connected to a company, Test names the project, the health pill is green, and removing it works.