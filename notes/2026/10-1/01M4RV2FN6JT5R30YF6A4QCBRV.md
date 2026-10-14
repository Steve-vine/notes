---
id: 01M4RV2FN6JT5R30YF6A4QCBRV
created: 2026-10-12T19:57:41.92638Z
updated: 2026-10-14T20:41:44.039712Z
type: task
title: A Google Cloud organisation is connected once — its projects are listed, each is switched on for a company, and a new project does not go unread unnoticed
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 930
sprint: s70gjk2
blocked_by:
- 01M4RV1YVZ1K5T0V75TY85SYCR
comments:
- id: 01M4SCS67116J470T7KXRBJRZ7
  author: Steve Vine
  at: 2026-10-13T01:07:11.713678Z
  text: |-
    Merged to main (PR #934, 2026-10-13).

    What to look at:
    - Inventory ▸ Settings ▸ Google Cloud organisations, below Google Cloud projects.
    - Connect an organisation: enter a name, the organisation's number (not its domain name) and any project of yours for the organisation's service account to live in. Compass then shows the role file and the commands, filled in. Choose "With a key file" or "Without a stored key", as for a project.
    - List projects. Each project shows the folder it sits in and one of: On for a company, Left off, or New, not read.
    - Switch on asks which company, a name, Production or Non-production, and how Compass signs in: the organisation's service account (nothing more to enter), or a service account of the project's own.
    - A project switched on then appears under Google Cloud projects like any other. One read with the organisation's service account says so on its row.
    - A project that appears later is "new, not read" and raises one action for the Inventory admins.
    - Remove says which projects are read with the organisation's service account and will stop being read. They stay connected and keep what was found. Give each a service account of its own under Google Cloud projects ▸ Edit to carry on.

    Needed from you before this can be smoke-tested: a Google Cloud organisation with at least two projects, and the right to create a role and grant it at the organisation.

    My calls, yours to overturn:
    - Projects Google makes by itself for Apps Script are not listed. A Workspace organisation can hold hundreds.
    - A project the service account can see that belongs to a different organisation, or to none, is not listed.
    - A project whose folder Compass may not read is shown, with no folder, rather than hidden. Compass cannot tell which organisation it leads up to, and hiding it would be the wrong way to err.
    - The organisation's service account is named compass-organisation, so it cannot be mistaken for a project's own (compass-discovery).
    - A project that is being deleted in Google Cloud cannot be switched on, and is not counted as waiting for a decision.

    One thing to know about set-up: the commands switch on, in the service account's own project, every Google service Compass asks. Some of Google's services judge "switched on" by where the service account lives, not by the project being read. If one is missed, that kind says so and names the project; nothing is treated as "none found".

    Not tested against a real organisation.

    Technical: migration 0250 (gcp_organisations, gcp_organisation_projects; gcp_connections gains gcp_organisation_id and its client_email may be empty). A second generated role file, docs/gcp/compass-organisation-role.yaml. The sign-in fields are now shared between the two Google Cloud cards.
assignee: steve
label:
- feature
priority: high
task_status: done
---
Part of sprint 69, Inventory discovery - GCP (ADR in COM-924). The Google Cloud counterpart of connecting an AWS organisation (COM-890) and an Azure tenant (COM-922).

## What people see

- **Inventory ▸ Settings gains "Google Cloud organisations"** below "Google Cloud projects". Connecting an organisation asks for a name, the organisation ID and how Compass signs in: with a service account's key file, or without a stored key (COM-931), exactly as for a project.
- **Compass lists the projects that service account can see**, with the folder each sits in, each as one of: read (switched on for a company), left off with a reason, or new and not read.
- **Switching a project on** asks which company, a name, Production or Non-production, and how to sign in: **with the organisation's service account** (one click, if it holds the read-only role on the project) or **with a service account of its own** (a key file, or no stored key, entered then). It then appears under "Google Cloud projects" like any other and is read the same way. The screen says which each project uses.
- **A project that appears later is listed as new, not read,** and raises one action for the Inventory admins: switch on, or leave off with a reason.
- **A project that is being deleted is not read**, and says why.
- **Projects Google makes by itself for Apps Script are not listed.** A Workspace organisation can hold hundreds, and none is anything a person set up.
- **Removing an organisation** stops the listing. Projects read with a service account of their own carry on. Projects read with the organisation's service account stop being readable and say so, until given one of their own.
- **Who:** Inventory admins.

## Notes (technical)

- **`gcp_organisations`** (company-scoped; `organisation_id` unique; `auth` (`key` | `federated`), `client_email`, `private_key_id`, `key_encrypted`, `wif_audience`; health; `last_synced_at`) and **`gcp_organisation_projects`** (`project_id`, `project_number`, `name`, `folder`, `state`, `decision`, `off_reason`, who and when), in the shape of `azure_tenants` / `azure_tenant_subscriptions`.
- **`gcp_connections.auth` gains `organisation`** beside `key` and `federated`, with `gcp_organisation_id` (FK, SET NULL). An `organisation` connection signs in however the organisation row does; nothing is copied.
- **Without a stored key, the trust lives in one project.** Google's workload identity pools belong to a project, not to an organisation. The organisation's service account and its pool sit in a home project the customer chooses, and the role is granted at the organisation or a folder. The set-up commands ask for that home project.
- **Listing** is `projects.search` (Resource Manager v3) as the organisation's service account: Google returns the projects it may get. Folder names come from `folders.get` on each distinct parent, cached for the pass. `core/discovery/gcp_organisation.py`, in the shape of `azure_tenant.py`: new → undecided unless already connected; no longer listed → kept and marked gone; a failed listing changes nothing but the health.
- **Apps Script projects** are those whose ID begins `sys-` beneath the `system-gsuite` folder. Skipped in the listing, never stored.
- **The six-hourly pass lists organisations first**, and does not read a project whose state is not `ACTIVE`.
- **Whose project must have a service switched on.** For some Google APIs "enabled" is judged against the service account's own project. Read with the organisation's service account, a kind can be refused because that home project never switched the service on. That is a set-up fault on the organisation, not "none found" on the project; the error names which project it means. Confirm against a real organisation, and have the docs switch on every service the readers use in the home project.
- **Action source** `inventory_gcp_projects_undecided`, beside the AWS and Azure ones.
- **API.** `/api/v1/inventory/gcp-organisations` (list, setup, create, update, delete, refresh, switch on, leave off) under `inventory.admin`.
- **Docs.** `docs/gcp/README.md` gains the organisation route, both ways of signing in: create the role at the organisation, grant it at the organisation or a folder so every project beneath inherits it, plus the two listing permissions (`resourcemanager.projects.get`, `resourcemanager.folders.get`). A second generated file, `compass-organisation-role.yaml`, held to the code by a test.
- **Screen.** `inventory/GcpOrganisationsCard.tsx`.

**Needs from Steve before smoke-testing:** a Google Cloud organisation with at least two projects, and the right to create a role and grant it at the organisation (Organisation Administrator with Organisation Role Administrator).

**Done when:** on staging an organisation is connected, its projects are listed, one is switched on with the organisation's service account and read.