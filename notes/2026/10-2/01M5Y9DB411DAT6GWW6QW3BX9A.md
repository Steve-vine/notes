---
id: 01M5Y9DB411DAT6GWW6QW3BX9A
created: 2026-10-27T09:00:11.777234Z
updated: 2026-10-27T09:02:24.741651Z
type: task
title: The AWS tile — the identity Compass runs as, and each company's accounts and organisations, move in from Admin and Inventory ▸ Settings
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1352
sprint: s8fmesf
blocked_by:
- 01M5Y9C3P6MGA186PBB0BF38C4
assignee: steve
label:
- feature
priority: medium
task_status: todo
---
Sprint 90, Integrations (ADR in COM-1347). Builds on COM-1349. Azure (COM-1353) and Google Cloud (COM-1354) follow the same shape.

## What people see

- **Category:** Cloud.
- **Overview:**
  - the two ways to reach an account: as its own user (offered first) or through a role (ADR 0101);
  - the policy Compass needs, with the generated template from `docs/aws`;
  - what Compass reads, and that it changes nothing.
- **Configure:**
  - **Compass's identity**: the AWS identity Compass runs as, from today's Admin ▸ Integrations, with Test;
  - **Accounts** and **Organisations**: each company's AWS accounts and organisations, moved from Inventory ▸ Settings. They follow the company picker and work exactly as today: add, Test, Read now, switch accounts on and off, blocked regions, remove.
- **Features:**
  - **Inventory discovery**: read what runs in each account every 6 hours.
  - Sprint 93 adds **Vulnerabilities** (Security Hub and Inspector findings). Not shown until then.
- **Status:**
  - the identity's health;
  - one row per account across every company, with company, last read, what was found, and the last error.
  - The tile is Needs attention when any account's last read failed.

## Who can do what

- Compass's identity needs manage integrations, as today.
- Accounts and organisations need Inventory admin, as today.

## Notes (technical)

- Move `inventory/AwsAccountsCard`, `AwsOrganisationsCard` and `admin/AwsIdentityIntegration.tsx` into the tile. Endpoints unchanged.
- Gate the 6-hour AWS discovery Beat job and Read now on the switch.
- The Status tab lists every company's accounts. Use a read that isn't company-scoped and is gated on Inventory admin or manage integrations.
- Polaris's `inventory_list_connections` / `read_connection_now` tools are unchanged. Read now while discovery is off says so.

**Chain:** on the chain (API).

**Done when:**
- an AWS account is added, tested and read from the tile;
- Inventory ▸ Settings no longer shows AWS;
- switching discovery off skips the next scheduled read.